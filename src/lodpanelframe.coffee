# lodpanelframe: create a frame for a lod curve plot (rectangle + axes + labels)

lodpanelframe = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800 # overall height of chart in pixels
    height = chartOpts?.height ? 500 # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:45, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    title = chartOpts?.title ? "" # chart title
    xlab = chartOpts?.xlab ? "Chromosome"  # x-axis label
    ylab = chartOpts?.ylab ? "LOD score"  # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? null # whether to rotate the y-axis label
    ylim = chartOpts?.ylim ? [0,1] # y-axis limits
    nyticks = chartOpts?.nyticks ? 5  # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    yticklab = chartOpts?.yticklab ? null # vector of y-axis tick labels
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6" # color of background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#d4d4d4" # color of background rectangle for alternate chromosomes
    boxcolor = chartOpts?.boxcolor ? "black"     # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 1           # width of outer box in pixels
    ylineOpts = chartOpts?.ylineOpts ? {color:"white", width:2} # color and width of horizontal lines
    gap = chartOpts?.gap ? 5 # gap between chromosomes in pixels
    # chartOpts end
    xscale = null
    yscale = null
    chrSelect = null
    svg = null

    ## the main function
    chart = (selection, data) -> # data = chr, start, end  (vectors with chromosome IDs, start positions, and end positions)
        # Create SVG
        svg = selection.append("svg")

        # Update the dimensions
        svg.attr("width", width)
           .attr("height", height)
           .attr("class", "d3panels")

        # put all of this stuff in a group
        g = svg.append("g").attr("id", "frame")

        # placement of boxes according to whether NAs will be treated specially
        plot_width = width - (margin.left + margin.right)
        plot_height = height - (margin.top + margin.bottom)

        # if start missing, use 0
        data.start = (0 for c in data.chr) unless data?.start
        if(data.chr.length != data.start.length)
            displayError("data.start.length (#{data.start.length}) != data.chr.length (#{data.chr.length})")
        if(data.chr.length != data.end.length)
            displayError("data.end.length (#{data.end.length}) != data.chr.length (#{data.chr.length})")

        # scales (x-axis scale is a has by chromosome ID
        yscale = d3.scale.linear().domain(ylim).range([plot_height + margin.top, margin.top])
        xscale = calc_chrscales(plot_width, margin.left, gap, data.chr, data.start, data.end)

        # solid background
        g.append("rect")
         .attr("x", margin.left)
         .attr("width", plot_width)
         .attr("y", margin.top)
         .attr("height", plot_height)
         .attr("fill", rectcolor)

        # background rectangles, alternating colors
        chrSelect = g.append("g")
                     .selectAll("empty")
                     .data(data.chr)
                     .enter()
                     .append("rect")
                     .attr("x", (d,i) -> xscale[d](data.start[i])-gap/2)
                     .attr("width", (d,i) -> xscale[d](data.end[i]) - xscale[d](data.start[i]) + gap)
                     .attr("y", margin.top)
                     .attr("height", plot_height)
                     .attr("fill", (d,i) ->
                         return rectcolor if i % 2 == 0
                         altrectcolor)

        # add title
        g.append("g").attr("class", "title")
         .append("text")
         .text(title)
         .attr("x", (width-margin.left-margin.right)/2 + margin.left)
         .attr("y", titlepos)

        # rotate y-axis title?
        rotate_ylab = rotate_ylab ? (ylab.length > 1)

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

        # add Y axis values + ylines
        # if yticks not provided, use nyticks to choose pretty ones
        yticks = yticks ? yscale.ticks(nyticks)
        if yticklab? and yticklab.length != yticks.length
            displayError("yticklab.length (#{yticklab.length}) != yticks.length (#{yticks.length})")
        unless yticklab? and yticklab.length == yticks.length
            yticklab = (formatAxis(yticks)(d) for d in yticks)

        # horizontal grid lines
        ylines = yaxis.append("g").attr("id", "ylines")
                  .selectAll("empty")
                  .data(yticks.concat(yticks))
                  .enter()
                  .append("line")
                  .attr("y1", (d) -> yscale(d))
                  .attr("y2", (d) -> yscale(d))
                  .attr("x1", (d,i) -> margin.left)
                  .attr("x2", (d,i) -> plot_width + margin.left)
                  .attr("fill", "none")
                  .attr("stroke", ylineOpts.color)
                  .attr("stroke-width", ylineOpts.width)
                  .attr("shape-rendering", "crispEdges")
                  .style("pointer-events", "none")

        # axis labels
        xlabels = xaxis.append("g").attr("id", "xlabels")
                   .selectAll("empty")
                   .data(data.chr)
                   .enter()
                   .append("text")
                   .attr("x", (d,i) -> (xscale[d](data.start[i]) + xscale[d](data.end[i]))/2)
                   .attr("y", height - margin.bottom + axispos.xlabel)
                   .text((d) -> d)
        ylabels = yaxis.append("g").attr("id", "ylabels")
                   .selectAll("empty")
                   .data(yticklab)
                   .enter()
                   .append("text")
                   .attr("y", (d,i) -> yscale(yticks[i]))
                   .attr("x", margin.left - axispos.ylabel)
                   .text((d) -> d)

        # background rectangle box
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top)
         .attr("height", plot_height)
         .attr("width", plot_width)
         .attr("fill", "none")
         .attr("stroke", boxcolor)
         .attr("stroke-width", boxwidth)
         .attr("shape-rendering", "crispEdges")

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.chrSelect = () -> chrSelect
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      null

    # return the chart function
    chart
