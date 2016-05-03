# lodheatmap: reuseable panel with heat map of LOD curves

lodheatmap = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts begin
    width = chartOpts?.width ? 800 # overall height of chart in pixels
    height = chartOpts?.height ? 500 # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40} # margins in pixels (left, top, right, bottom)
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]  # vector of three colors for the color scale (negative - zero - positive)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color for empty cells
    xlab = chartOpts?.xlab ? "Chromosome" # x-axis label
    ylab = chartOpts?.ylab ? ""           # y-axis label
    ylim = chartOpts?.ylim ? null # y-axis limits (if null take from data)
    zlim = chartOpts?.zlim ? null # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null # z threshold; if |z| < zthresh, not shown
    horizontal = chartOpts?.horizontal ? false # if true, have chromosomes arranged vertically
    hilitcolor = chartOpts?.hilitcolor ? "black" # color of box around highlighted cell
    chrGap = chartOpts?.chrGap ? 6 # gap between chromosomes (in pixels)
    equalCells = chartOpts?.equalCells ? false # if true, make all cells equal-sized; in this case, chartOpts.chrGap is ignored
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    zscale = null
    cellSelect = null
    celltip = null
    svg = null

    ## the main function
    chart = (selection, data) -> # (chr, pos, lod) optionally: y or ycat giving scale for y-axis
                                 # also, optionally poslabel (e.g. marker name)
                                 # also, optionally chrname, chrstart, chrend

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
            displayError("data.pos.length (#{data.pos.length}) != data.chr.length (#{n_pos})")
        if n_pos != data.lod.length
            displayError("data.lod.length (#{data.lod.length}) != data.chr.length (#{n_pos})")
        for i of data.lod
            if data.lod[i].length != data.y.length
                displayError("data.lod[#{i}].length (#{data.lod[i].length}) != data.y.length (#{n_lod})")

        if data.poslabel?
            if(data.poslabel.length != n_pos)
                displayError("data.poslabel.length (#{data.poslabel.length}) != data.chr.length (#{n_pos})")
        else
            # create position labels
            data.poslabel = ("#{data.chr[i]}@#{formatAxis(data.pos)(data.pos[i])}" for i of data.chr)

        # create chrname if missing
        data.chrname = unique(data.chr) unless data.chrname?

        # if equalCells, change positions to dummy values
        if equalCells
            data.pos = []
            for chr in data.chrname
                data.pos = data.pos.concat(+i for i of data.chr when data.chr[i] == chr)

        # create chrstart, chrend if missing
        unless data.chrstart?
            data.chrstart = []
            for c in data.chrname
                these_pos = (data.pos[i] for i of data.chr when data.chr[i] == c)
                data.chrstart.push(d3.min(these_pos))
        unless data.chrend?
            data.chrend = []
            for c in data.chrname
                these_pos = (data.pos[i] for i of data.chr when data.chr[i] == c)
                data.chrend.push(d3.max(these_pos))

        # if equalCells, adjust chrGap to make chromosome ends equal
        if equalCells
            chrGap = ((width - margin.left - margin.right) - 2*data.chrname.length)/data.chr.length + 2

        # organize positions and LOD scores by chromosomes
        data = reorgLodData(data)

        # y-axis midpoints
        ymid = calc_midpoints(pad_vector(data.y))

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
        myframe = chrpanelframe(chartOpts)

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
            xmid_scaled[chr] = calc_midpoints(pad_vector(xscale[chr](x) for x in data.posByChr[chr], (chrGap-2)/2))

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = matrixMin(data.lod)
        zmax = matrixMax(data.lod)
        zmax = -zmin if -zmin > zmax
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            displayError("zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale = d3.scale.linear().domain(zlim).range(colors)
        zthresh = zthresh ? zmin - 1

        # create cells for plotting
        cells = []
        for chr in data.chrname
            for pos,i in data.posByChr[chr]
                for lod,j in data.lodByChr[chr][i]
                    if Math.abs(lod) >= zthresh
                        cells.push({lod: lod, chr:chr, pos:pos, poslabel: data.poslabelByChr[chr][i], posindex:+i, lodindex:+j})
        calc_chrcell_rect(cells, xmid_scaled, ymid_scaled)

        # tool tips
        celltip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d) ->
                             z = d3.format(".2f")(Math.abs(d.lod))
                             lodlabel = if data.ycat? then data.ycat[d.lodindex] else formatAxis(data.y)(data.y[d.lodindex])
                             return "#{lodlabel}, #{d.poslabel} &rarr; #{z}" if horizontal
                             "#{d.poslabel}, #{lodlabel} &rarr; #{z}")
                   .direction(() ->
                       return 'n' if horizontal
                       'e')
                   .offset(() ->
                       return [-10, 0] if horizontal
                       [0,10])
        svg.call(celltip)

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
                 .on("mouseover.paneltip", (d) ->
                                               d3.select(this).attr("stroke", hilitcolor).moveToFront()
                                               celltip.show(d)
                                               if data.ycat?
                                                   svg.select("text#ylab#{d.lodindex}").attr("opacity",1))
                 .on("mouseout.paneltip", (d) ->
                                               d3.select(this).attr("stroke", "none")
                                               celltip.hide()
                                               if data.ycat?
                                                   svg.select("text#ylab#{d.lodindex}").attr("opacity",0))

        # if horizontal, remove y-axis labels and lines
        if data.ycat?
            svg.selectAll("g#ylines").remove()
            ylabels.attr("opacity", 0)
                   .attr("id", (d,i) -> "ylab#{i}")

        myframe.box().moveToFront()


    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.zscale = () -> yscale
    chart.cellSelect = () -> chrSelect
    chart.celltip = () -> chrSelect
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      celltip.destroy()
                      return null

    # return the chart function
    chart
