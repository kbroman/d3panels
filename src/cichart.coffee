# cichart: reuseable CI chart (plot of estimates and confidence intervals for a set of categories)

cichart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xcatlabels = chartOpts?.xcatlabels ? null # category labels
    segwidth = chartOpts?.segwidth ? 0.4 # segment width as proportion of distance between categories
    segcolor = chartOpts?.segcolor ? "slateblue" # color for segments
    segstrokewidth = chartOpts?.segstrokewidth ? "3" # stroke width for segments
    vertsegcolor = chartOpts?.vertsegcolor ? "slateblue" # color for vertical segments
    xlab = chartOpts?.xlab ? "Group" # x-axis label
    ylab = chartOpts?.ylab ? "Response" # y-axis label
    ylim = chartOpts?.ylim ? null # y-axis limits
    xlineOpts = chartOpts?.xlineOpts ? {color:"#CDCDCD", width:5} # color and width of vertical lines
    horizontal = chartOpts?.horizontal ? false # whether to interchange x and y-axes
    v_over_h = chartOpts?.v_over_h ? horizontal # whether vertical lines should be on top of horizontal lines
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    segments = null
    tip = null
    svg = null

    ## the main function
    chart = (selection, data) ->  # {mean, low, high} each vectors

        # input:
        mean = data.mean
        low = data.low
        high = data.high
        ncat = mean.length
        if ncat != low.length
            displayError("low.length [#{low.length}] != mean.length [#{ncat}]")
        if ncat != high.length
            displayError("high.length [#{high.length}] != mean.length [#{ncat}]")

        xticks = (+i+1 for i of mean)
        xcatlabels = xcatlabels ? xticks
        if xcatlabels.length != mean.length
            displayError("xcatlabels.length [#{xcatlabels.length}] != mean.length [#{ncat}]")

        # x- and y-axis limits + category locations
        ylim = ylim ? [d3.min(low), d3.max(high)]
        xlim = [0.5, mean.length + 0.5]

        # expand segcolor and vertsegcolor to length of mean
        segcolor = expand2vector(forceAsArray(segcolor), mean.length)
        vertsegcolor = expand2vector(forceAsArray(vertsegcolor), mean.length)

        if horizontal
            chartOpts.ylim = xlim.reverse()
            chartOpts.xlim = ylim
            chartOpts.xlab = ylab
            chartOpts.ylab = xlab
            chartOpts.xlineOpts = chartOpts.ylineOpts
            chartOpts.ylineOpts = xlineOpts
            chartOpts.yNA = chartOpts.xNA
            chartOpts.xNA = chartOpts.yNA
            chartOpts.yticks = xticks
            chartOpts.yticklab = xcatlabels
            chartOpts.v_over_h = v_over_h
        else
            chartOpts.ylim = ylim
            chartOpts.xlim = xlim
            chartOpts.xlab = xlab
            chartOpts.ylab = ylab
            chartOpts.ylineOpts = chartOpts.ylineOpts
            chartOpts.xlineOpts = xlineOpts
            chartOpts.xticks = xticks
            chartOpts.xticklab = xcatlabels
            chartOpts.v_over_h = v_over_h

        # set up frame
        myframe = panelframe(chartOpts)

        # Create SVG
        myframe(selection)
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        tip = d3.tip()
                .attr('class', "d3-tip #{tipclass}")
                .html((d,i) ->
                      index = i % mean.length
                      f = formatAxis([low[index],mean[index]], 1)
                      "#{f(mean[index])} (#{f(low[index])} - #{f(high[index])})")
                .direction(() ->
                    return 'n' if horizontal
                    'e')
                .offset(() ->
                    return [-10,0] if horizontal
                    [0,10])
        svg.call(tip)

        segmentGroup = svg.append("g").attr("id", "segments")

        # lines from low to high
        segments = segmentGroup.selectAll("empty")
                .data(low)
                .enter()
                .append("line")
                .attr("x1", (d,i) ->
                    return xscale(i+1) unless horizontal
                    xscale(d))
                .attr("x2", (d,i) ->
                    return xscale(i+1) unless horizontal
                    xscale(high[i]))
                .attr("y1", (d,i) ->
                    return yscale(d) unless horizontal
                    yscale(i+1))
                .attr("y2", (d,i) ->
                    return yscale(high[i]) unless horizontal
                    yscale(i+1))
                .attr("fill", "none")
                .attr("stroke", (d,i) -> vertsegcolor[i])
                .attr("stroke-width", segstrokewidth)
                .attr("shape-rendering", "crispEdges")
                .on("mouseover.paneltip", tip.show)
                .on("mouseout.paneltip", tip.hide)

        # lines at low, mean, and high
        yval = mean.concat(low,high)
        xval = (+(i % ncat)+1 for i of yval)
        segments = segmentGroup.selectAll("empty")
                .data(yval)
                .enter()
                .append("line")
                .attr("x1", (d,i) ->
                           if horizontal
                               return xscale(d)
                           else
                               return xscale(xval[i] - segwidth/2) if i < ncat
                               return xscale(xval[i] - segwidth/3))
                .attr("x2", (d,i) ->
                           if horizontal
                               return xscale(d)
                           else
                               return xscale(xval[i] + segwidth/2) if i < ncat
                               return xscale(xval[i] + segwidth/3))
                .attr("y1", (d,i) ->
                           if horizontal
                               return yscale(xval[i] - segwidth/2) if i < ncat
                               return yscale(xval[i] - segwidth/3)
                           else
                               return yscale(d))
                .attr("y2", (d,i) ->
                           if horizontal
                               return yscale(xval[i] + segwidth/2) if i < ncat
                               return yscale(xval[i] + segwidth/3)
                           else
                               return yscale(d))
                .attr("fill", "none")
                .attr("stroke", (d,i) -> segcolor[i % mean.length])
                .attr("stroke-width", segstrokewidth)
                .attr("shape-rendering", "crispEdges")
                .on("mouseover.paneltip", tip.show)
                .on("mouseout.paneltip", tip.hide)

        # move box to front
        myframe.box().moveToFront()

    # functions to grab stuff
    chart.yscale = () -> yscale
    chart.xscale = () -> xscale
    chart.segments = () -> segments
    chart.tip = () -> tip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
