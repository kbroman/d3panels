# heatmap: heat map panel

d3panels.heatmap = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:0} # margins in pixels (left, top, right, bottom, inner)
    xlim = chartOpts?.xlim ? null                                  # x-axis limits (if null take from data)
    ylim = chartOpts?.ylim ? null                                  # y-axis limits (if null take from data)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6"                   # color for empty cells
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # vector of three colors for the color scale (negative - zero - positive)
    zlim = chartOpts?.zlim ? null                                  # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null                            # z threshold; if |z| < zthresh, not shown
    hilitcolor = chartOpts?.hilitcolor ? "black"                   # color of box around highlighted cell
    tipclass = chartOpts?.tipclass ? "tooltip"                     # class name for tool tips
    # chartOpts end
    # further chartOpts: panelframe (omit xNA yNA xNA_size yNA_size)
    # accessors start
    xscale = null     # x-axis scale
    yscale = null     # y-axis scale
    zscale = null     # z-axis scale
    cells = null      # cell selection
    celltip = null    # cell tooltip selection
    svg = null        # SVG selection
    # accessors end
    cellSelect = null # actual name for the cell selection

    ## the main function
    chart = (selection, data) -> # {x, y, z}  # z should be a double-indexed square matrix, z[xval][yval]
                                 #   optionally, include xcat and ycat in place of x and y
                                 #       then: categorial scales on x and y axis

        d3panels.displayError("heatmap: data.x is missing") unless data.x? or data.xcat?
        d3panels.displayError("heatmap: data.y is missing") unless data.y? or data.ycat?
        d3panels.displayError("heatmap: data.z is missing") unless data.z?

        # xcat and ycat included?
        if data.xcat?
            data.x = (+i for i of data.xcat)
            xlim = xlim ? [-0.5, data.x.length-0.5]
            chartOpts.xticks = data.x
            chartOpts.xlineOpts = {color:"none",width:0}
            chartOpts.xlab = chartOpts?.xlab ? ""
        if data.ycat?
            data.y = (+i for i of data.ycat)
            ylim = ylim ? [-0.5, data.x.length-0.5]
            chartOpts.yticks = data.y
            chartOpts.ylineOpts = {color:"none",width:0}
            chartOpts.ylab = chartOpts?.ylab ? ""

        # check input sizes
        nx = data.x.length
        ny = data.y.length
        if data.z.length != nx
            d3panels.displayError("heatmap: data.x.length (#{nx}) != data.z.length (#{data.z.length})")
        for i of data.z
            if data.z[i].length != ny
                d3panels.displayError("heatmap: data.y.length (#{ny}) != data.z[#{i}].length (#{data.z[i].length})")

        # organize by cell
        cells = []
        for i of data.z
            for j of data.z[i]
                cells.push({x:data.x[i], y:data.y[j], z:data.z[i][j], xindex: +i, yindex: +j})

        # calc x and y midpoints
        xmid = d3panels.calc_midpoints(d3panels.pad_vector(data.x))
        ymid = d3panels.calc_midpoints(d3panels.pad_vector(data.y))

        # x and y axis limits
        xlim = xlim ? d3.extent(xmid)
        ylim = ylim ? d3.extent(ymid)

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = d3panels.matrixMin(data.z)
        zmax = d3panels.matrixMaxAbs(data.z)
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            d3panels.displayError("heatmap: zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale = d3.scaleLinear().domain(zlim).range(colors)

        # discard cells with |z| < zthresh
        zthresh = zthresh ? zmin - 1
        cells = (cell for cell in cells when Math.abs(cell.z) >= zthresh)

        # set up frame
        chartOpts.margin = margin
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.xNA = false  # don't allow NA boxes
        chartOpts.yNA = false
        myframe = d3panels.panelframe(chartOpts)

        # create SVG
        myframe(selection)
        svg = myframe.svg()

        # scales
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # x- and y-axis labels
        xlabels = myframe.xlabels()
        ylabels = myframe.ylabels()

        celltip = d3.tip()
                    .attr('class', "d3-tip #{tipclass}")
                    .html((d) ->
                            x = d3panels.formatAxis(data.x)(d.x)
                            y = d3panels.formatAxis(data.y)(d.y)
                            z = d3panels.formatAxis([0, zmax/100])(d.z)
                            return "#{z}" if data.xcat? and data.ycat?
                            return "(#{y}) &rarr; #{z}" if data.xcat?
                            return "(#{x}) &rarr; #{z}" if data.ycat?
                            "(#{x}, #{y}) &rarr; #{z}")
                    .direction('e')
                    .offset([0,10])
        svg.call(celltip)

        # scaled x and y midpoints
        xmid_scaled = (xscale(xv) for xv in xmid)
        ymid_scaled = (yscale(yv) for yv in ymid)

        # calculate x,y,width,height of rectangles
        d3panels.calc_cell_rect(cells, xmid_scaled, ymid_scaled)

        cellrect = svg.append("g").attr("id", "cells")
        cellSelect =
            cellrect.selectAll("empty")
                    .data(cells)
                    .enter()
                    .append("rect")
                    .attr("x", (d) -> d.left)
                    .attr("y", (d) -> d.top)
                    .attr("width", (d) -> d.width)
                    .attr("height", (d) -> d.height)
                    .attr("class", (d,i) -> "cell#{i}")
                    .attr("fill", (d) -> if d.z? then zscale(d.z) else nullcolor)
                    .attr("stroke", "none")
                    .attr("stroke-width", "1")
                    .attr("shape-rendering", "crispEdges")
                    .on("mouseover.paneltip", (d) ->
                                                  d3.select(this).attr("stroke", hilitcolor).raise()
                                                  celltip.show(d)
                                                  if data.xcat? # show categorical scales
                                                      svg.select("text#xlab#{d.x}").attr("opacity", 1)
                                                  if data.ycat?
                                                      svg.select("text#ylab#{d.y}").attr("opacity", 1))
                    .on("mouseout.paneltip", (d) ->
                                                  d3.select(this).attr("stroke", "none")
                                                  celltip.hide()
                                                  if data.xcat? # hide categorical scales
                                                      svg.select("text#xlab#{d.x}").attr("opacity", 0)
                                                  if data.ycat?
                                                      svg.select("text#ylab#{d.y}").attr("opacity", 0))

        # handle categorical scales:
        #    replace text with category labels, add IDs, and hide them initially
        if data.xcat?
            xlabels.text((d,i) -> data.xcat[i])
                   .attr("opacity", 0)
                   .attr("id", (d,i) -> "xlab#{data.x[i]}")
        if data.ycat?
            ylabels.text((d,i) -> data.ycat[i])
                   .attr("opacity", 0)
                   .attr("id", (d,i) -> "ylab#{data.y[i]}")

        # move box to front
        myframe.box().raise()

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
