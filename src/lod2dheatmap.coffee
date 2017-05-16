# lod2dheatmap: heat map panel, with the two dimensions broken into chromosomes

d3panels.lod2dheatmap = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800               # overall height of chart in pixels
    height = chartOpts?.height ? 800             # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 60} # margins in pixels (left, top, right, bottom)
    chrGap = chartOpts?.chrGap ? 6               # gap between chromosomes in pixels
    equalCells = chartOpts?.equalCells ? false   # if true, make all cells equal-sized; in this case, chartOpts.chrGap is ignored
    oneAtTop = chartOpts?.oneAtTop ? false       # if true, put chromosome 1 at the top rather than bottom
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]       # vector of three colors for the color scale (negative - zero - positive)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color for empty cells
    zlim = chartOpts?.zlim ? null                # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null          # z threshold; if |z| < zthresh, not shown
    hilitcolor = chartOpts?.hilitcolor ? "black" # color of box around highlighted cell
    tipclass = chartOpts?.tipclass ? "tooltip"   # class name for tool tips
    # chartOpts end
    # further chartOpts: chr2dpanelframe
    # accessors start
    xscale = null      # x-axis scale (vector by chromosome)
    yscale = null      # y-axis scale (vector by chromosome)
    zscale = null      # z-axis scale
    celltip = null     # cell tooltip selection
    cells = null       # cell selection
    svg = null         # SVG selection
    # accessors end
    cellSelect = null  # actual name for the cell selection

    ## the main function
    chart = (selection, data) ->  # (chr, pos, lod[chrx][chry])  optionally poslabel (e.g., marker names)

        # args that are lists: check that they have all the pieces
        margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 60})

        d3panels.displayError("lod2dheatmap: data.chr is missing") unless data.chr?
        d3panels.displayError("lod2dheatmap: data.pos is missing") unless data.pos?
        d3panels.displayError("lod2dheatmap: data.lod is missing") unless data.lod?

        n_pos = data.chr.length
        if(data.pos.length != n_pos)
            d3panels.displayError("lod2dheatmap: data.pos.length (#{data.pos.length}) != data.chr.length (#{n_pos})")
        if(data.lod.length != n_pos)
            d3panels.displayError("lod2dheatmap: data.lod.length (#{data.lod.length}) != data.chr.length (#{n_pos})")
        for i of data.lod
            if(data.lod[i].length != n_pos)
                d3panels.displayError("lod2dheatmap: data.lod[#{i}].length (#{data.lod[i].length}) != data.chr.length (#{n_pos})")

        if data.poslabel?
            if(data.poslabel.length != n_pos)
                d3panels.displayError("lod2dheatmap: data.poslabel.length (#{data.poslabel.length}) != data.chr.length (#{n_pos})")
        else
            # create position labels
            data.poslabel = ("#{data.chr[i]}@#{d3panels.formatAxis(data.pos)(data.pos[i])}" for i of data.chr)

        # create chrname if missing
        data.chrname = d3panels.unique(data.chr) unless data.chrname?
        data.chrname = d3panels.forceAsArray(data.chrname)

        # if equalCells, change positions to dummy values
        if equalCells
            data.pos = []
            for chr in data.chrname
                data.pos = data.pos.concat(+i for i of data.chr when data.chr[i] == chr)

        # create chrstart, chrend if missing
        data = d3panels.add_chrname_start_end(data)

        # if equalCells, adjust chrGap to make chromosome ends equal
        if equalCells
            chrGap = ((width - margin.left - margin.right) - 2*data.chrname.length)/data.chr.length + 2

        # create frame
        chartOpts.chrGap = chrGap
        chartOpts.width = width
        chartOpts.height = height
        chartOpts.margin = margin
        myframe = d3panels.chr2dpanelframe(chartOpts)

        # create SVG
        myframe(selection, {chr:data.chrname, start:data.chrstart, end:data.chrend})
        svg = myframe.svg()

        # scales
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # split position by chromosome
        posByChr = d3panels.reorgByChr(data.chrname, data.chr, data.pos)

        # scaled midpoints
        xmid_scaled = {}
        ymid_scaled = {}
        for chr in data.chrname
            xmid_scaled[chr] = d3panels.calc_midpoints(d3panels.pad_vector(xscale[chr](x) for x in posByChr[chr], chrGap-2))
            ymid_scaled[chr] = d3panels.calc_midpoints(d3panels.pad_vector(yscale[chr](y) for y in posByChr[chr], if oneAtTop then chrGap-2 else 2-chrGap))

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = d3panels.matrixMin(data.lod)
        zmax = d3panels.matrixMaxAbs(data.lod)
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            d3panels.displayError("lod2dheatmap: zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale = d3.scaleLinear().domain(zlim).range(colors)
        zthresh = zthresh ? zmin - 1

        # create within-chromosome index
        indexWithinChr = []
        for chr in data.chrname
            indexWithinChr = indexWithinChr.concat(+i for i of posByChr[chr])

        # create cells for plotting
        cells = []
        for i of data.chr
            for j of data.chr
                if Math.abs(data.lod[i][j]) >= zthresh
                    cells.push({
                        lod:data.lod[i][j]
                        chrx:data.chr[i]
                        chry:data.chr[j]
                        poslabelx:data.poslabel[i]
                        poslabely:data.poslabel[j]
                        xindex:i
                        yindex:j
                        xindexByChr:indexWithinChr[i]
                        yindexByChr:indexWithinChr[j]})

        # calc cell height, width
        d3panels.calc_2dchrcell_rect(cells, xmid_scaled, ymid_scaled)

        # tool tip
        celltip = d3.tip()
                    .attr('class', "d3-tip #{tipclass}")
                    .html((d) ->
                            z = d3.format(".2f")(Math.abs(d.lod))
                            "(#{d.poslabelx},#{d.poslabely}) &rarr; #{z}")
                    .direction('e')
                    .offset([0,10])
        svg.call(celltip)

        cellg = svg.append("g").attr("id", "cells")
        cellSelect =
            cellg.selectAll("empty")
                 .data(cells)
                 .enter()
                 .append("rect")
                 .attr("x", (d) -> d.left)
                 .attr("y", (d) -> d.top)
                 .attr("width", (d) -> d.width)
                 .attr("height", (d) -> d.height)
                 .attr("class", (d,i) -> "cell#{i}")
                 .attr("fill", (d) -> if d.lod? then zscale(d.lod) else nullcolor)
                 .attr("stroke", "none")
                 .attr("stroke-width", "1")
                 .on("mouseover.paneltip", (d) ->
                                               d3.select(this).attr("stroke", hilitcolor).raise()
                                               celltip.show(d))
                 .on("mouseout.paneltip", () ->
                                               d3.select(this).attr("stroke", "none")
                                               celltip.hide())

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.zscale = () -> zscale
    chart.cells = () -> cellSelect
    chart.celltip = () -> celltip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      celltip.destroy()
                      return null

    # return the chart function
    chart
