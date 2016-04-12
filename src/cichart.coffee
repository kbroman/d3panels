# cichart: reuseable CI chart (plot of estimates and confidence intervals for a set of categories)

cichart = (chartOpts) ->
    # chartOpts start
    xcatlabels = chartOpts?.xcatlabels ? null # category labels
    segwidth = chartOpts?.segwidth ? 0.2 # segment width as proportion of distance between categories
    segcolor = chartOpts?.segcolor ? "slateblue" # color for segments
    segstrokewidth = chartOpts?.segstrokewidth ? "3" # stroke width for segments
    vertsegcolor = chartOpts?.vertsegcolor ? "slateblue" # color for vertical segments
    xlab = chartOpts?.xlab ? "Group" # x-axis label
    ylab = chartOpts?.ylab ? "Response" # y-axis label
    ylim = chartOpts?.ylim ? null # y-axis limits
    xlineOpts = chartOpts?.xlineOpts ? {color:"#CDCDCD", width:5} # color and width of vertical lines
    horizontal = chartOpts?.horizontal ? false # whether to interchange x and y-axes
    v_over_h = chartOpts?.v_over_h ? horizontal # whether vertical lines should be on top of horizontal lines
    tipclass = chartOpts?.tipclass ? "pointtip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    segments = null
    svg = null
    tip = null

    ## the main function
    chart = (selection, data) ->

        # input:
        means = data.means
        low = data.low
        high = data.high
        categories = data.categories
        if means.length != low.length
            displayError("means.length [#{means.length}] != low.length [#{low.length}]")
        if means.length != high.length
            displayError("means.length [#{means.length}] != high.length [#{high.length}]")
        if means.length != categories.length
            displayError("means.length [#{means.length}] != categories.length [#{categories.length}]")

        xcatlabels = xcatlabels ? categories
        if xcatlabels.length != categories.length
            displayError("xcatlabels.length [#{xcatlabels.length}] != categories.length [#{categories.length}]")

        # x- and y-axis limits + category locations
        console.log(low)
        console.log(high)
        ylim = ylim ? [d3.min(low), d3.max(high)]
        xlim = [0.5, categories.length+0.5]
        xticks = (+i+1 for i of categories)
        console.log("xlim:")
        console.log(xlim)
        console.log("ylim:")
        console.log(ylim)

        # expand segcolor and vertsegcolor to length of means
        segcolor = expand2vector(forceAsArray(segcolor), means.length)
        vertsegcolor = expand2vector(forceAsArray(vertsegcolor), means.length)

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
        console.log(xscale(1))
        console.log(xscale(2))
        console.log(xscale(3))
        console.log(xscale(21))
        console.log(xscale(22))
        console.log(xscale(23))


        tip = d3.tip()
                .attr('class', "d3-tip #{tipclass}")
                .html((d,i) ->
                      index = i % means.length
                      f = formatAxis([low[index],means[index]], 1)
                      "#{f(means[index])} (#{f(low[index])} - #{f(high[index])})")
                .direction('e')
                .offset([0,10])
        svg.call(tip)

        segmentGroup = svg.append("g").attr("id", "segments")
        segments = segmentGroup.selectAll("empty")
                .data(low)
                .enter()
                .append("line")
                .attr("x1", (d,i) ->
                    return xscale(categories[i]) unless horizontal
                    xscale(d))
                .attr("x2", (d,i) ->
                    return xscale(categories[i]) unless horizontal
                    xscale(high[i]))
                .attr("y1", (d,i) ->
                    return yscale(d) unless horizontal
                    yscale(categories[i]))
                .attr("y2", (d,i) ->
                    return yscale(high[i]) unless horizontal
                    yscale(categories[i]))
                .attr("fill", "none")
                .attr("stroke", (d,i) -> vertsegcolor[i])
                .attr("stroke-width", segstrokewidth)
        segments = segmentGroup.selectAll("empty")
                .data(means.concat(low, high))
                .enter()
                .append("line")
                .attr("x1", (d,i) ->
                           if horizontal
                               return xscale(d)
                           else
                               x = xscale(categories[i % means.length])
                               return x - segwidth/2 if i < means.length
                               return x - segwidth/3)
                .attr("x2", (d,i) ->
                           if horizontal
                               return xscale(d)
                           else
                               x = xscale(categories[i % means.length])
                               return x + segwidth/2 if i < means.length
                               return x + segwidth/3)
                .attr("y1", (d) ->
                           if horizontal
                               x = yscale(categories[i % means.length])
                               return x - segwidth/2 if i < means.length
                               return x - segwidth/3
                           else
                               return yscale(d))
                .attr("y2", (d) ->
                           if horizontal
                               x = yscale(categories[i % means.length])
                               return x + segwidth/2 if i < means.length
                               return x + segwidth/3
                           else
                               return yscale(d))
                .attr("fill", "none")
                .attr("stroke", (d,i) -> segcolor[i % means.length])
                .attr("stroke-width", segstrokewidth)
                .on("mouseover.paneltip", tip.show)
                .on("mouseout.paneltip", tip.hide)


    # functions to grab stuff
    chart.yscale = () -> yscale
    chart.xscale = () -> xscale
    chart.segments = () -> segments
    chart.svg = () -> svg
    chart.tip = () -> tip

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
