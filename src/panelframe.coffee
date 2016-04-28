# panelframe: create a frame for a plot (rectangle + axes + labels)

panelframe = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800 # overall width of chart in pixels
    height = chartOpts?.height ? 500 # overall height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:3} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:45, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    title = chartOpts?.title ? "" # chart title
    xlab = chartOpts?.xlab ? "X"  # x-axis label
    ylab = chartOpts?.ylab ? "Y"  # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? null # whether to rotate the y-axis label
    xNA = chartOpts?.xNA ? false   # include box for x=NA values
    yNA = chartOpts?.yNA ? false   # include box for y=NA values
    xNA_size = chartOpts?.xNA_size ? {width:20, gap:10} # width and gap for x=NA box
    yNA_size = chartOpts?.yNA_size ? {width:20, gap:10} # width and gap for y=NA box
    xlim = chartOpts?.xlim ? [0,1] # x-axis limits
    ylim = chartOpts?.ylim ? [0,1] # y-axis limits
    nxticks = chartOpts?.nxticks ? 5  # no. ticks on x-axis
    xticks = chartOpts?.xticks ? null # vector of tick positions on x-axis
    xticklab = chartOpts?.xticklab ? null # vector of x-axis tick labels
    nyticks = chartOpts?.nyticks ? 5  # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    yticklab = chartOpts?.yticklab ? null # vector of y-axis tick labels
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6" # color of background rectangle
    boxcolor = chartOpts?.boxcolor ? "black"     # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 1           # width of outer box in pixels
    xlineOpts = chartOpts?.xlineOpts ? {color:"white", width:2} # color and width of vertical lines
    ylineOpts = chartOpts?.ylineOpts ? {color:"white", width:2} # color and width of horizontal lines
    v_over_h = chartOpts?.v_over_h ? false # whether the vertical grid lines should be on top of the horizontal lines
    # chartOpts end
    yscale = null
    xscale = null
    xscale_wnull = null
    yscale_wnull = null
    xlines = null
    ylines = null
    xlabels = null
    ylabels = null
    plot_width = null
    plot_height = null
    svg = null

    ## the main function
    chart = (selection) ->
        # Create SVG
        svg = selection.append("svg")

        # Update the dimensions
        svg.attr("width", width)
           .attr("height", height)
           .attr("class", "d3panels")

        # put all of this stuff in a group
        g = svg.append("g").attr("id", "frame")

        xNA_size = {width:0, gap:0} unless xNA # if no x-axis NA box
        yNA_size = {width:0, gap:0} unless yNA # if no y-axis NA box

        # placement of boxes according to whether NAs will be treated specially
        plot_width = width - (margin.left + margin.right)
        plot_height = height - (margin.top + margin.bottom)
        inner_width = width - (margin.right + margin.left + xNA_size.width + xNA_size.gap)
        inner_height = height - (margin.top + margin.bottom + yNA_size.width + yNA_size.gap)
        boxes =
                left:[margin.left+xNA_size.width+xNA_size.gap, margin.left, margin.left, margin.left+xNA_size.width+xNA_size.gap],
                width:[inner_width, xNA_size.width, xNA_size.width, inner_width],
                top:[margin.top, margin.top, height-(margin.bottom+yNA_size.width), height-(margin.bottom+yNA_size.width)],
                height:[inner_height, inner_height, yNA_size.width, yNA_size.width]
        xNA_xpos = if xNA then margin.left + xNA_size.width/2 else -50000
        yNA_ypos = if yNA then height-margin.bottom-yNA_size.width/2 else -50000
        xrange = [boxes.left[0], boxes.left[0] + boxes.width[0]]
        yrange = [boxes.top[0] + boxes.height[0], boxes.top[0]]

        # background rectangles
        for i of boxes.left
            if boxes.width[i]>0 and boxes.height[i]>0
                g.append("rect")
                 .attr("x", boxes.left[i])
                 .attr("y", boxes.top[i])
                 .attr("height", boxes.height[i])
                 .attr("width", boxes.width[i])
                 .attr("fill", rectcolor)
                 .attr("stroke", "none")

        # add title
        g.append("g").attr("class", "title")
         .append("text")
         .text(title)
         .attr("x", (width-margin.left-margin.right)/2 + margin.left)
         .attr("y", titlepos)

        # rotate y-axis title?
        rotate_ylab = rotate_ylab ? (ylab.length > 1)

        if v_over_h # xlines on top
            yaxis = g.append("g").attr("class", "y axis")
            xaxis = g.append("g").attr("class", "x axis")
        else        # xlines on bottom
            xaxis = g.append("g").attr("class", "x axis")
            yaxis = g.append("g").attr("class", "y axis")

        xaxis.append("text").attr("class", "title")
             .text(xlab)
             .attr("x", (width-margin.left-margin.right)/2 + margin.left)
             .attr("y", plot_height + margin.top + axispos.xtitle)
        ylabpos_y = (height-margin.top-margin.bottom)/2 + margin.top
        ylabpos_x = margin.left - axispos.ytitle
        yaxis.append("text").attr("class", "title")
             .text(ylab)
             .attr("y", ylabpos_y)
             .attr("x", ylabpos_x)
             .attr("transform", if rotate_ylab then "rotate(270,#{ylabpos_x},#{ylabpos_y})" else "")

        # scales (ignoring NA business)
        xscale = d3.scale.linear().domain(xlim).range([xrange[0]+margin.inner, xrange[1]-margin.inner])
        yscale = d3.scale.linear().domain(ylim).range([yrange[0]-margin.inner, yrange[1]+margin.inner])
        # scales (handling nulls)
        xscale_wnull = (val) ->
            return xNA_xpos unless val?
            xscale(val)
        yscale_wnull = (val) ->
            return yNA_ypos unless val?
            yscale(val)

        # add X axis values + xlines
        # if xticks not provided, use nxticks to choose pretty ones
        xticks = xticks ? xscale.ticks(nxticks)
        if xticklab? and xticklab.length != xticks.length
            displayError("xticklab.length (#{xticklab.length}) != xticks.length (#{xticks.length})")
        unless xticklab? and xticklab.length == xticks.length
            xticklab = (formatAxis(xticks)(d) for d in xticks)
        xticks = [null].concat(xticks)
        xticklab = ["NA"].concat(xticklab)

        # add Y axis values + ylines
        # if yticks not provided, use nyticks to choose pretty ones
        yticks = yticks ? yscale.ticks(nyticks)
        if yticklab? and yticklab.length != yticks.length
            displayError("yticklab.length (#{yticklab.length}) != yticks.length (#{yticks.length})")
        unless yticklab? and yticklab.length == yticks.length
            yticklab = (formatAxis(yticks)(d) for d in yticks)
        yticks = [null].concat(yticks)
        yticklab = ["NA"].concat(yticklab)

        # do ylines first
        ylines = yaxis.append("g").attr("id", "ylines")
                  .selectAll("empty")
                  .data(yticks.concat(yticks))
                  .enter()
                  .append("line")
                  .attr("y1", (d) -> yscale_wnull(d))
                  .attr("y2", (d) -> yscale_wnull(d))
                  .attr("x1", (d,i) ->
                      return xrange[0] if i < yticks.length
                      margin.left)
                  .attr("x2", (d,i) ->
                      return xrange[1] if i < yticks.length
                      margin.left+xNA_size.width)
                  .attr("fill", "none")
                  .attr("stroke", ylineOpts.color)
                  .attr("stroke-width", ylineOpts.width)
                  .attr("shape-rendering", "crispEdges")
                  .style("pointer-events", "none")


        # xlines
        xlines = xaxis.append("g").attr("id", "xlines")
                  .selectAll("empty")
                  .data(xticks.concat(xticks))
                  .enter()
                  .append("line")
                  .attr("x1", (d) -> xscale_wnull(d))
                  .attr("x2", (d) -> xscale_wnull(d))
                  .attr("y1", (d,i) ->
                      return yrange[0] if i < xticks.length
                      height-margin.bottom)
                  .attr("y2", (d,i) ->
                      return yrange[1] if i < xticks.length
                      height-margin.bottom-yNA_size.width)
                  .attr("fill", "none")
                  .attr("stroke", xlineOpts.color)
                  .attr("stroke-width", xlineOpts.width)
                  .attr("shape-rendering", "crispEdges")
                  .style("pointer-events", "none")

        # axis labels
        xlabels = xaxis.append("g").attr("id", "xlabels")
                   .selectAll("empty")
                   .data(xticklab)
                   .enter()
                   .append("text")
                   .attr("x", (d,i) -> xscale_wnull(xticks[i]))
                   .attr("y", height - margin.bottom + axispos.xlabel)
                   .text((d) -> d)
        ylabels = yaxis.append("g").attr("id", "ylabels")
                   .selectAll("empty")
                   .data(yticklab)
                   .enter()
                   .append("text")
                   .attr("y", (d,i) -> yscale_wnull(yticks[i]))
                   .attr("x", margin.left - axispos.ylabel)
                   .text((d) -> d)

        # background rectangle boxes
        for i of boxes.left
            if boxes.width[i]>0 and boxes.height[i]>0
                g.append("rect")
                 .attr("x", boxes.left[i])
                 .attr("y", boxes.top[i])
                 .attr("height", boxes.height[i])
                 .attr("width", boxes.width[i])
                 .attr("fill", "none")
                 .attr("stroke", boxcolor)
                 .attr("stroke-width", boxwidth)
                 .attr("shape-rendering", "crispEdges")

    # functions to grab stuff
    chart.xscale = () -> xscale_wnull
    chart.yscale = () -> yscale_wnull
    chart.xlines = () -> xlines
    chart.ylines = () -> ylines
    chart.xlabels = () -> xlabels
    chart.ylabels = () -> ylabels
    chart.plot_width = () -> plot_width
    chart.plot_height = () -> plot_height
    chart.width = () -> width
    chart.height = () -> height
    chart.margin = () -> margin
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      null

    # return the chart function
    chart
