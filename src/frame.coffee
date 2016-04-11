# frame: create a frame for a plot (rectangle + axes + labels)

frame = (chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 800 # overall height of chart in pixels
    height = chartOpts?.height ? 500 # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
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
    ylim = chartOpts?.ylab ? [0,1] # y-axis limits
    nxticks = chartOpts?.nxticks ? 5  # no. ticks on x-axis
    xticks = chartOpts?.xticks ? null # vector of tick positions on x-axis
    nyticks = chartOpts?.nyticks ? 5  # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6" # color of background rectangle
    boxcolor = chartOpts?.boxcolor ? "black"     # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 1           # width of outer box in pixels
    vlines = chartOpts?.vlines ? {color:"white", width:1} # color and width of vertical lines
    hlines = chartOpts?.hlines ? {color:"white", width:1} # color and width of horizontal lines
    v_over_h = chartOpts?.v_over_h ? false # whether the vertical grid lines should be on top of the horizontal lines
    # chartOpts end
    yscale = d3.scale.linear()
    xscale = d3.scale.linear()
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
            else if xNA    # NA box only for X
                inner_width = width - (margin.right + margin.left + xNA_size.width + xNA_size.gap)
                inner_height = height - (margin.top + margin.bottom)
                boxes =
                    left:[margin.left+xNA_size.width+xNA_size.gap, margin.left],
                    width:[inner_width, xNA_size.width],
                    top:[margin.top, margin.top],
                    height: [inner_height, inner_height]
            else if yNA    # NA box only for Y
                inner_width = width - (margin.right + margin.left)
                inner_height = height - (margin.top + margin.bottom + yNA_size.width + yNA_size.gap)
                boxes =
                    left: [margin.left, margin.left],
                    width: [inner_width, inner_width],
                    top: [margin.top, height-(margin.bottom + yNA_size.width)],
                    height: [inner_height, yNA_size.width]
            else           # no NA boxes
                inner_width = width - (margin.right + margin.left)
                inner_height = height - (margin.top + margin.bottom)
                boxes =
                    left: [margin.left],
                    width: [inner_width],
                    top: [margin.top],
                    height: [inner_height]
            xrange = [boxes.left[0], boxes.left[0] + boxes.width[0]]
            yrange = [boxes.top[0],  boxes.top[0] +  boxes.height[0]]

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

            # add X and Y axis labels
            rotate_ylab = rotate_ylab ? (ylab.length > 1)
            g.append("g").attr("class", "x axis")
             .append("text")
             .text(xlab)
             .attr("x", (width-margin.left-margin.right)/2 + margin.left)
             .attr("y", plot_height + margin.top + axispos.xtitle)
            ylabpos_y = (height-margin.top-margin.bottom)/2 + margin.top
            ylabpos_x = margin.left - axispos.ytitle
            g.append("g").attr("class", "y axis")
             .append("text")
             .text(ylab)
             .attr("y", ylabpos_y)
             .attr("x", ylabpos_x)
             .attr("transform", if rotate_ylab then "rotate(270,#{ylabpos_x},#{ylabpos_y})" else "")

            # scales (ignoring NA business)
            xscale.domain(xlim).range(xrange)
            yscale.domain(ylim).range(yrange)
            xs = d3.scale.linear().domain(xlim).range(xrange)
            ys = d3.scale.linear().domain(ylim).range(yrange)

            # NA value for both x and y axes
            na_value = d3.min(xlim.concat(ylim)) - 1

            # "polylinear" scales to handle missing values
            if xNA.handle
                xscale.domain([na_value].concat xlim)
                      .range([margin.left + xNA.width/2].concat xrange)
                x = x.map (e) -> if e? then e else na_value
            if yNA.handle
                yscale.domain([na_value].concat ylim)
                      .range([height+margin.top-yNA.width/2].concat yrange)
                y = y.map (e) -> if e? then e else na_value

            # add X axis values + vlines
            # if xticks not provided, use nxticks to choose pretty ones
            xticks = xticks ? xs.ticks(nxticks)


            # add Y axis values + hlines
            # if xticks not provided, use nxticks to choose pretty ones
            yticks = yticks ? ys.ticks(nyticks)

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

    chart.yscale = () ->
                      return yscale

    chart.xscale = () ->
                      return xscale

    chart.remove = () ->
                      svg.remove()
                      return null

    # return the chart function
    chart
