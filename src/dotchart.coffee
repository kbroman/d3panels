# dotchart: scatter plot where one dimension is categorical (sometimes called a strip chart)

d3panels.dotchart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xcategories = chartOpts?.xcategories ? null         # group categories
    xcatlabels = chartOpts?.xcatlabels ? null           # labels for group categories
    xNA = chartOpts?.xNA ? {handle:true, force:false}   # handle: include separate boxes for NAs; force: include whether or not NAs in data
    yNA = chartOpts?.yNA ? {handle:true, force:false}   # handle: include separate boxes for NAs; force: include whether or not NAs in data
    xNA_size = chartOpts?.xNA_size ? {width:20, gap:10} # width and gap for x=NA box
    yNA_size = chartOpts?.yNA_size ? {width:20, gap:10} # width and gap for y=NA box
    ylim = chartOpts?.ylim ? null                       # y-axis limits
    xlab = chartOpts?.xlab ? "Group"                    # x-axis title
    ylab = chartOpts?.ylab ? "Response"                 # y-axis title
    xlineOpts = chartOpts?.xlineOpts ? {color:"#cdcdcd", width:5} # color and width of vertical lines
    pointcolor = chartOpts?.pointcolor ? null           # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black"      # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3                # color of points
    jitter = chartOpts?.jitter ? "beeswarm"             # method for jittering points (beeswarm|random|none)
    tipclass = chartOpts?.tipclass ? "tooltip"          # class name for tool tips
    horizontal = chartOpts?.horizontal ? false          # whether to interchange x and y-axes
    v_over_h = chartOpts?.v_over_h ? horizontal         # whether vertical lines should be on top of horizontal lines
    # chartOpts end
    # further chartOpts: panelframe
    # accessors start
    xscale = null # x-axis scale
    yscale = null # y-axis scale
    xNA = xNA     # true if x-axis NAs are handled in a separate box
    yNA = yNA     # true if y-axis NAs are handled in a separate box
    points = null # point selection
    indtip = null # tooltip selection
    svg = null    # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID, group} # x should be a set of positive integers; xcategories has the possible values

        # args that are lists: check that they have all the pieces
        xNA = d3panels.check_listarg_v_default(xNA, {handle:true, force:false})
        yNA = d3panels.check_listarg_v_default(yNA, {handle:true, force:false})
        xNA_size = d3panels.check_listarg_v_default(xNA, {width:20, gap:10})
        yNA_size = d3panels.check_listarg_v_default(yNA, {width:20, gap:10})

        d3panels.displayError("dotchart: data.x is missing") unless data.x?
        d3panels.displayError("dotchart: data.y is missing") unless data.y?

        x = d3panels.missing2null(data.x)
        y = d3panels.missing2null(data.y)

        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? [1..x.length]

        # a few checks
        if x.length != y.length
            d3panels.displayError("dotchart: length(x) [#{x.length}] != length(y) [#{y.length}]")
        if indID.length != x.length
            d3panels.displayError("dotchart: length(indID) [#{indID.length}] != length(x) [#{x.length}]")

        # groups of colors
        group = data?.group ? (1 for i in x)
        ngroup = d3.max(group)
        group = ((if g? then g-1 else g) for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if d3panels.sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            d3panels.displayError("dotchart: group values out of range")
            console.log("ngroup: #{ngroup}")
            console.log("distinct groups: #{d3panels.unique(group)}")
        if group.length != x.length
            d3panels.displayError("dotchart: group.length (#{group.length}) != x.length (#{x.length})")

        # colors of the points in the different groups
        pointcolor = pointcolor ? d3panels.selectGroupColors(ngroup, "dark")
        pointcolor = d3panels.expand2vector(pointcolor, ngroup)
        if pointcolor.length < ngroup
            d3panels.displayError("add_points: pointcolor.length (#{pointcolor.length}) < ngroup (#{ngroup})")

        xcategories = xcategories ? d3panels.unique(x)
        xcategories = d3panels.forceAsArray(xcategories) # force it to be an array rather than a scalar
        xcatlabels = xcatlabels ? xcategories
        xcatlabels = d3panels.forceAsArray(xcatlabels)
        if xcatlabels.length != xcategories.length
            d3panels.displayError("dotchart: xcatlabels.length [#{xcatlabels.length}] != xcategories.length [#{xcategories.length}]")

        # check all x in xcategories
        if d3panels.sumArray(xv? and !(xv in xcategories) for xv in x) > 0
            d3panels.displayError("dotchart: Some x values not in xcategories")
            console.log("xcategories:")
            console.log(xcategories)
            console.log("x:")
            console.log(x)
            for i of x
                x[i] = null if x[i]? and !(x[i] in xcategories)

        # x- and y-axis limits
        ylim = ylim ? d3panels.pad_ylim(d3.extent(y))
        xlim = [d3.min(xcategories)-0.5, d3.max(xcategories) + 0.5]

        # whether to include separate boxes for NAs
        xNA.handle = xNA.force or (xNA.handle and !(x.every (v) -> (v?)))
        yNA.handle = yNA.force or (yNA.handle and !(y.every (v) -> (v?)))

        if horizontal
            chartOpts.ylim = xlim.reverse()
            chartOpts.xlim = ylim
            chartOpts.xlab = ylab
            chartOpts.ylab = xlab
            chartOpts.xlineOpts = chartOpts.ylineOpts
            chartOpts.ylineOpts = xlineOpts
            chartOpts.yNA = xNA.handle
            chartOpts.xNA = yNA.handle
            chartOpts.xNA_size = yNA_size
            chartOpts.yNA_size = xNA_size
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
            chartOpts.xNA_size = xNA_size
            chartOpts.yNA_size = yNA_size
            chartOpts.xticks = xcategories
            chartOpts.xticklab = xcatlabels
            chartOpts.v_over_h = v_over_h

        # set up frame
        myframe = d3panels.panelframe(chartOpts)

        # Create SVG
        myframe(selection)
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        indtip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d,i) -> indID[i])
                   .direction(() ->
                       return 'n' if horizontal
                       'e')
                   .offset(() ->
                       return [-10-pointsize,0] if horizontal
                       [0,10+pointsize])
        svg.call(indtip)

        # scaled versions of points
        if horizontal
            scaledPoints = ({x:xscale(y[i]),y:yscale(x[i])} for i of x)
        else
            scaledPoints = ({x:xscale(x[i]),y:yscale(y[i])} for i of x)

        pointGroup = svg.append("g").attr("id", "points")
        points =
            pointGroup.selectAll("empty")
                  .data(scaledPoints)
                  .enter()
                  .append("circle")
                  .attr("class", (d,i) -> "pt#{i}")
                  .attr("r", pointsize)
                  .attr("fill", (d,i) -> pointcolor[group[i]])
                  .attr("stroke", pointstroke)
                  .attr("stroke-width", "1")
                  .attr("cx", (d) -> d.x)
                  .attr("cy", (d) -> d.y)
                  .on("mouseover.paneltip", indtip.show)
                  .on("mouseout.paneltip", indtip.hide)

        if jitter == "random"
            jitter_width = 0.2
            u = ((Math.random()-0.5)*jitter_width for i of scaledPoints)
            if horizontal
                points.attr("cy", (d,i) ->
                    return yscale(x[i] + u[i]) if x[i]?
                    yscale(x[i]) + u[i]/jitter_width*xNA_size.width/2)
            else
                points.attr("cx", (d,i) ->
                    return xscale(x[i] + u[i]) if x[i]?
                    xscale(x[i]) + u[i]/jitter_width*xNA_size.width/2)

        else if jitter == "beeswarm"
            if horizontal
                d3.range(scaledPoints.length).map( (i) ->
                    scaledPoints[i].fx = scaledPoints[i].x )

                force = d3.forceSimulation(scaledPoints)
                      .force("y", d3.forceY((d) -> d.y))
                      .force("collide", d3.forceCollide(pointsize*1.1))
                      .stop()

            else
                d3.range(scaledPoints.length).map( (i) ->
                    scaledPoints[i].fy = scaledPoints[i].y)

                force = d3.forceSimulation(scaledPoints)
                      .force("x", d3.forceX((d) -> d.x))
                      .force("collide", d3.forceCollide(pointsize*1.1))
                      .stop()

            [0..30].map((d) ->
                force.tick()
                points.attr("cx", (d) -> d.x)
                      .attr("cy", (d) -> d.y))

        else if jitter != "none"
            d3panels.displayError('dotchart: jitter should be "beeswarm", "random", or "none"')

        # move box to front
        myframe.box().raise()

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.xNA = () -> xNA.handle
    chart.yNA = () -> yNA.handle
    chart.points = () -> points
    chart.indtip = () -> indtip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
