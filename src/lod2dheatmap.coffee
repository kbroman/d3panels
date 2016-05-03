# lod2dheatmap: reuseable heat map panel, broken into chromosomes

lod2dheatmap = (chartOpts) ->
    # chartOpts start
    chrGap = chartOpts?.chrGap ? 6 # gap between chromosomes in pixels
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]  # vector of three colors for the color scale (negative - zero - positive)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color for empty cells
    zlim = chartOpts?.zlim ? null # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null # z threshold; if |z| < zthresh, not shown
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    zscale = null
    celltip = null
    cellSelect = null
    svg = null

    ## the main function
    chart = (selection, data) ->  # (chr, pos, lod[chrx][chry])

        ny = data.z.length
        nx = (x.length for x in data.z)
        for i of nx
            if nx[i] != ny
                displayError("Row #{i+1} of data.z is not the right length: #{nx[i]} != #{ny}")
        nchr = data.nmar.length
        totmar = sumArray(data.nmar)
        if totmar != ny
            displayError("sum(data.nmar) [#{sumArray(data.nmar)}] != data.z.length [#{data.z.length}]")
        if data.chrnames.length != nchr
            displayError.log("data.nmar.length [#{data.nmar.length}] != data.chrnames.length [#{data.chrnames.length}]")
        if data.labels.length != totmar
            displayError("data.labels.length [#{data.labels.length}] != sum(data.nmar) [#{sum(data.nmar)}]")
        if chrGap < 1
            displayError("chrGap should be >= 2 (was #{chrGap})")
            chrGap = 2

        # determine start of each cell (leave 1 pixel border around each chromosome)
        xChrBorder = [0]
        xCellStart = []
        cur = chrGap/2
        for nm in data.nmar
            for j in [0...nm]
                xCellStart.push(cur+1)
                cur = cur+pixelPerCell
            xChrBorder.push(cur+1+chrGap/2)
            cur = cur+chrGap

        width = cur-chrGap/2
        height = width # always square

        if oneAtTop
            yChrBorder = (val for val in xChrBorder)
            yCellStart = (val for val in xCellStart)
        else
            yChrBorder = (height - val+1 for val in xChrBorder)
            yCellStart = (height-val-pixelPerCell for val in xCellStart)

        data.cells = []
        for i of data.z
            for j of data.z[i]
                data.cells.push({i:i, j:j, z:data.z[i][j], x:xCellStart[i]+margin.left, y:yCellStart[j]+margin.top})
        data.allz = (cell.z for cell in data.cells)

        # z-axis (color) limits; if not provided, make symmetric about 0
        zmin = d3.min(data.allz)
        zmax = d3.max(data.allz)
        zmax = -zmin if -zmin > zmax
        zlim = zlim ? [-zmax, 0, zmax]
        if zlim.length != colors.length
            displayError("zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
        zscale.domain(zlim).range(colors)

        # discard cells with |z| < zthresh
        zthresh = zthresh ? zmin - 1
        data.cells = (cell for cell in data.cells when cell.z >= zthresh or cell.z <= -zthresh)

        # set up frame
        chartOpts.chrGap = chrGap
        myframe = lod2dpanelframe(chartOpts)

        # create svg
        myframe(selection, {chr:chrname, start:chrstart, end:chrend})
        svg = myframe.svg()

        # scales
        xscale = myframe.xscale()
        yscale = myframe.yscale()


        celltip = d3.tip()
                    .attr('class', "d3-tip #{tipclass}")
                    .html((d) ->
                            "#{data.labels[d.i]}, #{data.labels[d.j]} &rarr; #{formatAxis(data.allz)(d.z)}")
                    .direction('e')
                    .offset([0,10])
        svg.call(celltip)

        cells = svg.append("g").attr("id", "cells")
        cellSelect =
            cells.selectAll("empty")
                 .data(data.cells)
                 .enter()
                 .append("rect")
                 .attr("x", (d) -> d.x)
                 .attr("y", (d) -> d.y)
                 .attr("width", pixelPerCell)
                 .attr("height", pixelPerCell)
                 .attr("class", (d,i) -> "cell#{i}")
                 .attr("fill", (d) -> if d.z? then zscale(d.z) else nullcolor)
                 .attr("stroke", "none")
                 .attr("stroke-width", "1")
                 .on("mouseover.paneltip", (d) ->
                                               d3.select(this).attr("stroke", "black")
                                               celltip.show(d) if hover)
                 .on("mouseout.paneltip", () ->
                                               d3.select(this).attr("stroke", "none")
                                               celltip.hide() if hover)

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.zscale = () -> zscale
    chart.chrSelect = () -> chrSelect
    chart.celltip = () -> chrSelect
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      celltip.destroy()
                      return null

    # return the chart function
    chart
