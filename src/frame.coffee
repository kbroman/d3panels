# frame: create a frame for a plot (rectangle + axes + labels)

frame = (chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 800 # overall height of chart in pixels
    height = chartOpts?.height ? 500 # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:45, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    title = chartOpts?.title ? "" # chart title
    xlab = chartOpts?.xlab ? "X"  # x-axis label
    ylab = chartOpts?.ylab ? "Y"  # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? null # whether to rotate the y-axis label
    xNA = chartOpts?.xNA ? false   # include box for x=NA values
    yNA = chartOpts?.yNA ? false   # include box for y=NA values
    xNA_size = chartOpts?.xNA_size ? {width:30, gap:10} # width and gap for x=NA box
    yNA_size = chartOpts?.yNA_size ? {width:30, gap:10} # width and gap for y=NA box
    xlim = chartOpts?.xlim ? [0,1] # x-axis limits
    ylim = chartOpts?.ylim ? [0,1] # y-axis limits
    nxticks = chartOpts?.nxticks ? 5  # no. ticks on x-axis
    xticks = chartOpts?.xticks ? null # vector of tick positions on x-axis
    nyticks = chartOpts?.nyticks ? 5  # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6" # color of background rectangle
    boxcolor = chartOpts?.boxcolor ? "black"     # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 1           # width of outer box in pixels
    vlineOpts = chartOpts?.vlineOpts ? {color:"white", width:2} # color and width of vertical lines
    hlineOpts = chartOpts?.hlineOpts ? {color:"white", width:2} # color and width of horizontal lines
    v_over_h = chartOpts?.v_over_h ? false # whether the vertical grid lines should be on top of the horizontal lines
    # chartOpts end
    yscale = null
    xscale = null
    xscale_wnull = null
    yscale_wnull = null
    vlines = null
    hlines = null
    xlabels = null
    ylabels = null
    svg = null

    ## the main function
    chart = (selection) ->
        selection.each (data) ->

            # Select the svg element, if it exists.
            svg = d3.select(this).selectAll("svg").data([data])

            # Otherwise, create the skeletal chart.
            gEnter = svg.enter().append("svg").attr("class", "d3panels").append("g")

            # Update the dimensions
            svg.attr("width", width)
               .attr("height", height)
               .attr("class", "d3panels")

            g = svg.select("g")

            # placement of boxes according to whether NAs will be treated specially
            plot_width = width - (margin.left + margin.right)
            plot_height = height - (margin.top + margin.bottom)
            if xNA and yNA # NA boxes for both X and Y
                inner_width = width - (margin.right + margin.left + xNA_size.width + xNA_size.gap)
                inner_height = height - (margin.top + margin.bottom + yNA_size.width + yNA_size.gap)
                boxes =
                    left:[margin.left+xNA_size.width+xNA_size.gap, margin.left, margin.left, margin.left+xNA_size.width+xNA_size.gap],
                    width:[inner_width, xNA_size.width, xNA_size.width, inner_width],
                    top:[margin.top, margin.top, height-(margin.bottom+yNA_size.width), height-(margin.bottom+yNA_size.width)],
                    height:[inner_height, inner_height, yNA_size.width, yNA_size.width]
                xNA_xpos = margin.left + xNA_size.width/2
                yNA_ypos = height-margin.bottom-yNA_size.width/2
            else if xNA    # NA box only for X
                inner_width = width - (margin.right + margin.left + xNA_size.width + xNA_size.gap)
                inner_height = height - (margin.top + margin.bottom)
                boxes =
                    left:[margin.left+xNA_size.width+xNA_size.gap, margin.left],
                    width:[inner_width, xNA_size.width],
                    top:[margin.top, margin.top],
                    height: [inner_height, inner_height]
                xNA_xpos = margin.left + xNA_size.width/2
                yNA_ypos = -5000
            else if yNA    # NA box only for Y
                inner_width = width - (margin.right + margin.left)
                inner_height = height - (margin.top + margin.bottom + yNA_size.width + yNA_size.gap)
                boxes =
                    left: [margin.left, margin.left],
                    width: [inner_width, inner_width],
                    top: [margin.top, height-(margin.bottom + yNA_size.width)],
                    height: [inner_height, yNA_size.width]
                xNA_xpos = -5000
                yNA_ypos = height-margin.bottom-yNA_size.width/2
            else           # no NA boxes
                inner_width = width - (margin.right + margin.left)
                inner_height = height - (margin.top + margin.bottom)
                boxes =
                    left: [margin.left],
                    width: [inner_width],
                    top: [margin.top],
                    height: [inner_height]
                xNA_xpos = -5000
                yNA_ypos = -5000
            xrange = [boxes.left[0], boxes.left[0] + boxes.width[0]]
            yrange = [boxes.top[0] + boxes.height[0], boxes.top[0]]

            # background rectangles
            for i of boxes.left
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

            if v_over_h # vlines on top
                yaxis = g.append("g").attr("class", "y axis")
                xaxis = g.append("g").attr("class", "x axis")
            else        # vlines on bottom
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
            xscale = d3.scale.linear().domain(xlim).range(xrange)
            yscale = d3.scale.linear().domain(ylim).range(yrange)
            # scales (handling nulls)
            xscale_wnull = (val) ->
                return xNA_xpos unless val?
                xscale(val)
            yscale_wnull = (val) ->
                return yNA_ypos unless val?
                yscale(val)

            # add X axis values + vlines
            # if xticks not provided, use nxticks to choose pretty ones
            xticks = xticks ? xscale.ticks(nxticks)
            xticklab = xticks
            if xNA
                xticklab = ["NA"].concat(xticks)
                xticks = [null].concat(xticks)

            # add Y axis values + hlines
            # if xticks not provided, use nxticks to choose pretty ones
            yticks = yticks ? yscale.ticks(nyticks)
            yticklab = yticks
            if yNA
                yticklab = ["NA"].concat(yticks)
                yticks = [null].concat(yticks)

            # do hlines first
            hlines = yaxis.selectAll("empty")
                      .data(yticks)
                      .enter()
                      .append("line")
                      .attr("y1", (d) -> yscale_wnull(d))
                      .attr("y2", (d) -> yscale_wnull(d))
                      .attr("x1", xrange[0])
                      .attr("x2", xrange[1])
                      .attr("fill", "none")
                      .attr("stroke", hlineOpts.color)
                      .attr("stroke-width", hlineOpts.width)

            # vlines
            vlines = xaxis.selectAll("empty")
                      .data(xticks)
                      .enter()
                      .append("line")
                      .attr("x1", (d) -> xscale_wnull(d))
                      .attr("x2", (d) -> xscale_wnull(d))
                      .attr("y1", yrange[0])
                      .attr("y2", yrange[1])
                      .attr("fill", "none")
                      .attr("stroke", vlineOpts.color)
                      .attr("stroke-width", vlineOpts.width)

            # axis labels
            xlabels = xaxis.selectAll("empty")
                       .data(xticklab)
                       .enter()
                       .append("text")
                       .attr("x", (d,i) -> xscale_wnull(xticks[i]))
                       .attr("y", height - margin.bottom + axispos.xlabel)
                       .text((d) -> formatAxis(xticks)(d))
            ylabels = yaxis.selectAll("empty")
                       .data(yticklab)
                       .enter()
                       .append("text")
                       .attr("y", (d,i) -> yscale_wnull(yticks[i]))
                       .attr("x", margin.left - axispos.ylabel)
                       .text((d,i) -> formatAxis(yticks)(d))

            # background rectangle boxes
            for i of boxes.left
                g.append("rect")
                 .attr("x", boxes.left[i])
                 .attr("y", boxes.top[i])
                 .attr("height", boxes.height[i])
                 .attr("width", boxes.width[i])
                 .attr("fill", "none")
                 .attr("stroke", boxcolor)
                 .attr("stroke-width", boxwidth)

    # functions to grab stuff
    chart.xscale = () -> xscale_wnull
    chart.yscale = () -> yscale_wnull
    chart.vlines = () -> vlines
    chart.hlines = () -> hlines
    chart.xlabels = () -> xlabels
    chart.ylabels = () -> ylabels

    chart.remove = () ->
                      svg.remove()
                      return null

    # return the chart function
    chart
