# heatmap: reuseable heat map panel

heatmap = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:0} # margins in pixels (left, top, right, bottom, inner)
    xlim = chartOpts?.xlim ? null # x-axis limits (if null take from data)
    ylim = chartOpts?.ylim ? null # y-axis limits (if null take from data)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color for empty cells
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # vector of three colors for the color scale (negative - zero - positive)
    zlim = chartOpts?.zlim ? null # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null # z threshold; if |z| < zthresh, not shown
    boxcolor = chartOpts?.boxcolor ? "black"     # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 1           # width of outer box in pixels
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    zscale = null
    cellSelect = null
    celltip = null
    svg = null

    ## the main function
    chart = (selection, data) -> # data = {x, y, z}

        # check input sizes
        nx = data.x.length
        ny = data.y.length
        if data.z.length != nx
            displayError("data.x.length (#{nx}) != data.z.length (#{data.z.length})")
        for i of data.z
            if data.z[i].length != ny
                displayError("data.y.length (#{ny}) != data.z[#{i}].length (#{data.z[i].length})")

        # organize by cell
        cells = []
        for i of data.z
            for j of data.z[i]
                cells.push({x:data.x[i], y:data.y[j], z:data.z[i][j]})

        # sort the x and y values
        data.x.sort((a,b) -> a-b)
        data.y.sort((a,b) -> a-b)

        # x values to left and right of each value
        xLR = getLeftRight(data.x)
        yLR = getLeftRight(data.y)

        # x and y axis limits
        xlim = xlim ? xLR.extent
        ylim = ylim ? yLR.extent

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = matrixMin(data.z)
        zmax = matrixMax(data.z)
        zmax = -zmin if -zmin > zmax
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            displayError("zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale = d3.scale.linear().domain(zlim).range(colors)

        # discard cells with |z| < zthresh
        zthresh = zthresh ? zmin - 1
        cells = (cell for cell in cells when Math.abs(cell.z) >= zthresh)

        # insert info about left, right, top, bottom points of cell rectangles
        for cell in cells
            cell.recLeft = (xLR[cell.x].left+cell.x)/2
            cell.recRight = (xLR[cell.x].right+cell.x)/2
            cell.recTop = (yLR[cell.y].right+cell.y)/2
            cell.recBottom = (yLR[cell.y].left+cell.y)/2

        # set up frame
        chartOpts.margin = margin
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.xNA = false
        chartOpts.yNA = false
        myframe = panelframe(chartOpts)

        # create SVG
        myframe(selection)
        svg = myframe.svg()

        # scales
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        celltip = d3.tip()
                    .attr('class', "d3-tip #{tipclass}")
                    .html((d) ->
                            x = formatAxis(data.x)(d.x)
                            y = formatAxis(data.y)(d.y)
                            z = formatAxis([0, zmax/100])(d.z)
                            "(#{x}, #{y}) &rarr; #{z}")
                    .direction('e')
                    .offset([0,10])
        svg.call(celltip)

        cellrect = svg.append("g").attr("id", "cells")
        cellSelect =
            cellrect.selectAll("empty")
                    .data(cells)
                    .enter()
                    .append("rect")
                    .attr("x", (d) -> xscale(d.recLeft))
                    .attr("y", (d) -> yscale(d.recTop))
                    .attr("width", (d) -> xscale(d.recRight)-xscale(d.recLeft))
                    .attr("height", (d) -> yscale(d.recBottom) - yscale(d.recTop))
                    .attr("class", (d,i) -> "cell#{i}")
                    .attr("fill", (d) -> if d.z? then zscale(d.z) else nullcolor)
                    .attr("stroke", "none")
                    .attr("stroke-width", "1")
                    .attr("shape-rendering", "crispEdges")
                    .on("mouseover.paneltip", (d) ->
                                                  d3.select(this).attr("stroke", "black").moveToFront()
                                                  celltip.show(d))
                    .on("mouseout.paneltip", () ->
                                                  d3.select(this).attr("stroke", "none")
                                                  celltip.hide())

        # add box again
        svg.append("rect")
           .attr("height", svg.attr("height")-margin.top-margin.bottom)
           .attr("width", svg.attr("width")-margin.left-margin.right)
           .attr("x", margin.left)
           .attr("y", margin.top)
           .attr("fill", "none")
           .attr("stroke", boxcolor)
           .attr("stroke-width", boxwidth)
           .attr("shape-rendering", "crispEdges")
           .style("pointer-events", "none")

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.zscale = () -> zscale
    chart.cellSelect = () -> cellSelect
    chart.celltip = () -> celltip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      celltip.destroy()
                      return null

    # return the chart function
    chart
