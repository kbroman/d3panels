# dotchart: reuseable dot plot (like a scatter plot where one dimension is categorical)

dotchart = (chartOpts) ->

    # chartOpts start
    xcategories = chartOpts?.xcategories ? null # group categories
    xcatlabels = chartOpts?.xcatlabels ? null # labels for group categories
    xjitter = chartOpts?.xjitter ? null # amount to jitter horizontally
    xNA = chartOpts?.xNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    yNA = chartOpts?.yNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    ylim = chartOpts?.ylim ? null # y-axis limits
    xlab = chartOpts?.xlab ? "Group" # x-axis title
    ylab = chartOpts?.ylab ? "Response" # y-axis title
    xlineOpts = chartOpts?.xlineOpts ? {color:"#CDCDCD", width:5} # color and width of vertical lines
    pointcolor = chartOpts?.pointcolor ? "slateblue" # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black" # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3 # color of points
    tipclass = chartOpts?.tipclass ? "pointtip" # class name for tool tips
    horizontal = chartOpts?.horizontal ? false # whether to interchange x and y-axes
    v_over_h = chartOpts?.v_over_h ? horizontal # whether vertical lines should be on top of horizontal lines
    # chartOpts end
    xscale = null
    yscale = null
    points = null
    svg = null
    indtip = null

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID} # x should be a set of positive integers; xcategories has the possible values
        x = data.x
        y = data.y

        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? null
        indID = indID ? [1..x.length]

        # a few checks
        if x.length != y.length
            displayError("length(x) [#{x.length}] != length(y) [#{y.length}]")
        if indID.length != x.length
            displayError("length(indID) [#{indID.length}] != length(x) [#{x.length}]")

        xcategories = xcategories ? unique(x)
        xcatlabels = xcatlabels ? xcategories
        if xcatlabels.length != xcategories.length
            displayError("xcatlabels.length [#{xcatlabels.length}] != xcategories.length [#{xcategories.length}]")

        # check all x in xcategories
        if sumArray(xv? and !(xv in xcategories) for xv in x) > 0
            displayError("Some x values not in xcategories")
            console.log("xcategories:")
            console.log(xcategories)
            console.log("x:")
            console.log(x)

        # x- and y-axis limits
        ylim = ylim ? d3.extent(y)
        xlim = [d3.min(xcategories)-0.5, d3.max(xcategories) + 0.5]

        # whether to include separate boxes for NAs
        xNA.handle = false if x.every (v) -> (v?) and !xNA.force
        yNA.handle = false if y.every (v) -> (v?) and !yNA.force

        if horizontal
            chartOpts.ylim = xlim.reverse()
            chartOpts.xlim = ylim
            chartOpts.xlab = ylab
            chartOpts.ylab = xlab
            chartOpts.xlineOpts = chartOpts.ylineOpts
            chartOpts.ylineOpts = xlineOpts
            chartOpts.yNA = xNA.handle
            chartOpts.xNA = yNA.handle
            chartOpts.yticks = xcategories
            chartOpts.yticklab = xcatlabels
            chartOpts.v_over_h = v_over_h
        else
            chartOpts.ylim = ylim
            chartOpts.xlim = xlim
            chartOpts.xlab = xlab
            chartOpts.ylab = ylab
            chartOpts.ylineOpts = chartOpts.ylineOpts
            chartOpts.xlineOpts = xlineOpts
            chartOpts.xNA = xNA.handle
            chartOpts.yNA = yNA.handle
            chartOpts.xticks = xcategories
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

        # jitter x-axis
        if xjitter == null
            xjitter = ((Math.random()-0.5)*0.2 for v in d3.range(x.length))
        else
            xjitter = [xjitter] if typeof(xjitter) == 'number'
            xjitter = (xjitter[0] for v in d3.range(x.length)) if xjitter.length == 1

        displayError("xjitter.length [#{xjitter.length}] != x.length [#{x.length}]") if xjitter.length != x.length

        indtip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d,i) -> indID[i])
                   .direction('e')
                   .offset([0,10])
        svg.call(indtip)

        pointGroup = svg.append("g").attr("id", "points")
        points =
            pointGroup.selectAll("empty")
                  .data(x)
                  .enter()
                  .append("circle")
                  .attr("cx", (d,i) ->
                      return xscale(x[i]+xjitter[i]) unless horizontal
                      xscale(y[i]))
                  .attr("cy", (d,i) ->
                      return yscale(y[i]) unless horizontal
                      yscale(x[i]+xjitter[i]))
                  .attr("class", (d,i) -> "pt#{i}")
                  .attr("r", pointsize)
                  .attr("fill", pointcolor)
                  .attr("stroke", pointstroke)
                  .attr("stroke-width", "1")
                  .attr("opacity", (d,i) ->
                                       return 1 if (y[i]? or yNA.handle) and x[i]? and x[i] in xcategories
                                       return 0)
                  .on("mouseover.paneltip", indtip.show)
                  .on("mouseout.paneltip", indtip.hide)

    # functions to grab stuff
    chart.yscale = () -> yscale
    chart.xscale = () -> xscale
    chart.points = () -> points
    chart.svg = () -> svg
    chart.indtip = () -> indtip

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
