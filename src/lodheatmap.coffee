# lodheatmap: reuseable panel with heat map of LOD curves

lodheatmap = (chartOpts) ->
    # chartOpts begin
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]  # vector of three colors for the color scale (negative - zero - positive)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color for empty cells
    xlab = chartOpts?.xlab ? "Chromosome" # x-axis label
    ylab = chartOpts?.ylab ? ""           # y-axis label
    ylim = chartOpts?.ylim ? null # y-axis limits (if null take from data)
    zlim = chartOpts?.zlim ? null # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null # z threshold; if |z| < zthresh, not shown
    horizontal = chartOpts?.horizontal ? false # if true, have chromosomes arranged vertically
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
                                 # also, optionally chrname, chrstart, chrend

        # for categorical scale
        if data.ycat?
            data.y = (i+1 for i of data.ycat)
        unless data.y?
            data.ycat = (i+1 for i of data.lod[0])
            data.y = (i+1 for i of data.lod[0])
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

        # create chrname, chrstart, chrend if missing
        data.chrname = unique(data.chr) unless data.chrname?
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

        # organize positions and LOD scores by chromosomes
        data = reorgLodData(data)

        # set up frame
        chartOpts.ylim = ylim ? d3.extent(data.y)
        chartOpts.horizontal = horizontal
        chartOpts.xlab = xlab
        chartOpts.ylab = ylab
        myframe = lodpanelframe(chartOpts)

        # Create SVG
        myframe(selection, {chr:data.chrname,start:data.chrstart,end:data.chrend})
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        nlod = data.lodnames.length

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = matrixMin(data.z)
        zmax = matrixMax(data.z)
        zmax = -zmin if -zmin > zmax
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            displayError("zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale = d3.scale.linear().domain(zlim).range(colors)
        zthresh = zthresh ? zmin - 1

        data.cells = []
        for chr in data.chrnames
            for pos, i in data.posByChr[chr]
                for lod,j in data.lodByChr[chr][i]
                    if lod >= zthresh or lod <= -zthresh
                        data.cells.push({z: lod, left: (xscale[chr](pos) + xscale[chr](xLR[chr][pos].left) )/2,
                        right: (xscale[chr](pos) + xscale[chr](xLR[chr][pos].right) )/2, lodindex:j, chr:chr, pos:pos})

        celltip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d) ->
                             z = d3.format(".2f")(Math.abs(d.z))
                             p = d3.format(".1f")(d.pos)
                             "#{d.chr}@#{p}, #{lod_labels[d.lodindex]} &rarr; #{z}")
                   .direction('e')
                   .offset([0,10])
        svg.call(celltip)

        cells = g.append("g").attr("id", "cells")
        cellSelect =
            cells.selectAll("empty")
                 .data(data.cells)
                 .enter()
                 .append("rect")
                 .attr("x", (d) -> d.left)
                 .attr("y", (d) -> yscale(d.lodindex)-rectHeight/2)
                 .attr("width", (d) -> d.right - d.left)
                 .attr("height", rectHeight)
                 .attr("class", (d,i) -> "cell#{i}")
                 .attr("fill", (d) -> if d.z? then zscale(d.z) else nullcolor)
                 .attr("stroke", "none")
                 .attr("stroke-width", "1")
                 .on("mouseover.paneltip", (d) ->
                                               yaxis.select("text#yaxis#{d.lodindex}").attr("opacity", 1)
                                               d3.select(this).attr("stroke", "black")
                                               celltip.show(d))
                 .on("mouseout.paneltip", (d) ->
                                               yaxis.select("text#yaxis#{d.lodindex}").attr("opacity", 0)
                                               d3.select(this).attr("stroke", "none")
                                               celltip.hide())

        mypanel.box().moveToFront()


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
