# lodheatmap: heat map for multiple LOD curves (with one dimension broken by chromosomes)

d3panels.lodheatmap = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800               # overall height of chart in pixels
    height = chartOpts?.height ? 500             # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40} # margins in pixels (left, top, right, bottom)
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]       # vector of three colors for the color scale (negative - zero - positive)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color for empty cells
    xlab = chartOpts?.xlab ? null                # x-axis label
    ylab = chartOpts?.ylab ? ""                  # y-axis label
    ylim = chartOpts?.ylim ? null                # y-axis limits (if null take from data)
    zlim = chartOpts?.zlim ? null                # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null          # z threshold; if |z| < zthresh, not shown
    horizontal = chartOpts?.horizontal ? false   # if true, have chromosomes arranged vertically
    hilitcolor = chartOpts?.hilitcolor ? "black" # color of box around highlighted cell
    chrGap = chartOpts?.chrGap ? 6               # gap between chromosomes (in pixels)
    equalCells = chartOpts?.equalCells ? false   # if true, make all cells equal-sized; in this case, chartOpts.chrGap is ignored
    tipclass = chartOpts?.tipclass ? "tooltip"   # class name for tool tips
    # chartOpts end
    # further chartOpts: chrpanelframe
    # accessors start
    xscale = null     # x-axis scale (vector by chromosome)
    yscale = null     # y-axis scale
    zscale = null     # z-axis scale
    cells = null      # cell selection
    celltip = null    # cell tooltip selection
    svg = null        # SVG selection
    # accessors end
    cellSelect = null # actual name for the cell selection

    ## the main function
    chart = (selection, data) -> # (chr, pos, lod) optionally: y or ycat giving scale for y-axis
                                 # also, optionally poslabel (e.g. marker name)
                                 # also, optionally chrname, chrstart, chrend

        # args that are lists: check that they have all the pieces
        margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40})

        d3panels.displayError("lodheatmap: data.chr is missing") unless data.chr?
        d3panels.displayError("lodheatmap: data.pos is missing") unless data.pos?
        d3panels.displayError("lodheatmap: data.lod is missing") unless data.lod?

        # for categorical scale
        if data.ycat? # if data.ycat provided (categorical labels), data.y ignored
            data.y = (i+1 for i of data.ycat)
        unless data.y? # if neither data.ycat nor data.y provided, create labels
            data.ycat = (i+1 for i of data.lod[0])
            data.y = (i+1 for i of data.lod[0])
        data.y = (+yv for yv in data.y) # make sure it's numeric
        n_pos = data.chr.length
        n_lod = data.y.length

        # check inputs
        if n_pos != data.pos.length
            d3panels.displayError("lodheatmap: data.pos.length (#{data.pos.length}) != data.chr.length (#{n_pos})")
        if n_pos != data.lod.length
            d3panels.displayError("lodheatmap: data.lod.length (#{data.lod.length}) != data.chr.length (#{n_pos})")
        for i of data.lod
            if data.lod[i].length != data.y.length
                d3panels.displayError("lodheatmap: data.lod[#{i}].length (#{data.lod[i].length}) != data.y.length (#{n_lod})")

        if data.poslabel?
            if(data.poslabel.length != n_pos)
                d3panels.displayError("lodheatmap: data.poslabel.length (#{data.poslabel.length}) != data.chr.length (#{n_pos})")
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

        # organize positions and LOD scores by chromosomes
        data = d3panels.reorgLodData(data)

        # y-axis midpoints
        ymid = d3panels.calc_midpoints(d3panels.pad_vector(data.y))

        # set up frame
        chartOpts.ylim = ylim ? d3.extent(ymid)
        chartOpts.horizontal = horizontal
        chartOpts.xlab = xlab
        chartOpts.ylab = ylab
        chartOpts.chrGap = chrGap
        chartOpts.width = width
        chartOpts.height = height
        chartOpts.margin = margin
        if data.ycat? # categorical labels
            chartOpts.yticks = data.y
            chartOpts.yticklab = data.ycat
        myframe = d3panels.chrpanelframe(chartOpts)

        # Create SVG
        myframe(selection, {chr:data.chrname,start:data.chrstart,end:data.chrend})
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # y-axis labels
        ylabels = myframe.ylabels()

        # scaled y-axis midpoints
        ymid_scaled = (yscale(y) for y in ymid)

        # x-axis midpoints
        xmid_scaled = {}
        for chr in data.chrname
            xmid_scaled[chr] = d3panels.calc_midpoints(d3panels.pad_vector(xscale[chr](x) for x in data.posByChr[chr], (chrGap-2)/2))

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = d3panels.matrixMin(data.lod)
        zmax = d3panels.matrixMaxAbs(data.lod)
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            d3panels.displayError("lodheatmap: zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale = d3.scaleLinear().domain(zlim).range(colors)
        zthresh = zthresh ? zmin - 1

        # create cells for plotting
        cells = []
        for chr in data.chrname
            for pos,i in data.posByChr[chr]
                for lod,j in data.lodByChr[chr][i]
                    if Math.abs(lod) >= zthresh
                        cells.push({lod: lod, chr:chr, pos:pos, poslabel: data.poslabelByChr[chr][i], posindex:+i, lodindex:+j})
        d3panels.calc_chrcell_rect(cells, xmid_scaled, ymid_scaled)

        cellg = svg.append("g").attr("id", "cells")
        cellSelect =
            cellg.selectAll("empty")
                 .data(cells)
                 .enter()
                 .append("rect")
                 .attr("x", (d) ->
                     return d.top if horizontal
                     d.left)
                 .attr("y", (d) ->
                     return d.left if horizontal
                     d.top)
                 .attr("width", (d) ->
                     return d.height if horizontal
                     d.width)
                 .attr("height", (d) ->
                     return d.width if horizontal
                     d.height)
                 .attr("class", (d,i) -> "cell#{i}")
                 .attr("fill", (d) -> if d.lod? then zscale(d.lod) else nullcolor)
                 .attr("stroke", "none")
                 .attr("stroke-width", "1")
                 .attr("shape-rendering", "crispEdges")
                 .on("mouseover", (d) ->
                                               d3.select(this).attr("stroke", hilitcolor).raise()
                                               if data.ycat?
                                                   svg.select("text#ylab#{d.lodindex}").attr("opacity",1))
                 .on("mouseout", (d) ->
                                               d3.select(this).attr("stroke", "none")
                                               if data.ycat?
                                                   svg.select("text#ylab#{d.lodindex}").attr("opacity",0))

        # if horizontal, remove y-axis labels and lines
        if data.ycat?
            svg.selectAll("g#ylines").remove()
            ylabels.attr("opacity", 0)
                   .attr("id", (d,i) -> "ylab#{i}")

        # tool tips
        celltipfunc = (d) ->
                             z = d3.format(".2f")(Math.abs(d.lod))
                             lodlabel = if data.ycat? then data.ycat[d.lodindex] else d3panels.formatAxis(data.y)(data.y[d.lodindex])
                             return "#{lodlabel}, #{d.poslabel} &rarr; #{z}" if horizontal
                             "#{d.poslabel}, #{lodlabel} &rarr; #{z}"
        direction = if horizontal then "north" else "east"
        celltip = d3panels.tooltip_create(d3.select("body"), cellg.selectAll("rect"),
                                          {direction:direction, tipclass:tipclass},
                                          celltipfunc)

        myframe.box().raise()


    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.zscale = () -> yscale
    chart.cells = () -> cellSelect
    chart.celltip = () -> celltip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      d3panels.tooltip_destroy(celltip)
                      return null

    # return the chart function
    chart
