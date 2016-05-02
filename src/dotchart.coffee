# dotchart: reuseable dot plot (like a scatter plot where one dimension is categorical)

dotchart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xcategories = chartOpts?.xcategories ? null # group categories
    xcatlabels = chartOpts?.xcatlabels ? null # labels for group categories
    xNA = chartOpts?.xNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    yNA = chartOpts?.yNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    xNA_size = chartOpts?.xNA_size ? {width:20, gap:10} # width and gap for x=NA box
    yNA_size = chartOpts?.yNA_size ? {width:20, gap:10} # width and gap for y=NA box
    ylim = chartOpts?.ylim ? null # y-axis limits
    xlab = chartOpts?.xlab ? "Group" # x-axis title
    ylab = chartOpts?.ylab ? "Response" # y-axis title
    xlineOpts = chartOpts?.xlineOpts ? {color:"#cdcdcd", width:5} # color and width of vertical lines
    pointcolor = chartOpts?.pointcolor ? "slateblue" # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black" # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3 # color of points
    jitter = chartOpts?.jitter ? "beeswarm" # method for jittering points (beeswarm|random|none)
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    horizontal = chartOpts?.horizontal ? false # whether to interchange x and y-axes
    v_over_h = chartOpts?.v_over_h ? horizontal # whether vertical lines should be on top of horizontal lines
    # chartOpts end
    xscale = null
    yscale = null
    points = null
    indtip = null
    svg = null

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID} # x should be a set of positive integers; xcategories has the possible values
        x = missing2null(data.x)
        y = missing2null(data.y)

        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? [1..x.length]

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
            for i of x
                x[i] = null if x[i]? and !(x[i] in xcategories)

        # x- and y-axis limits
        ylim = ylim ? d3.extent(y)
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
        myframe = panelframe(chartOpts)

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
                  .attr("fill", pointcolor)
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

            for p in scaledPoints
                p.true_x = p.x
                p.true_y = p.y

            # nearby points
            nearbyPoints = []
            for i of scaledPoints
                p = scaledPoints[i]
                p.index = i
                nearbyPoints[i] = []
                for j of scaledPoints
                    if j != i
                        q = scaledPoints[j]
                        if horizontal
                            nearbyPoints[i].push(j) if p.y == q.y and Math.abs(p.x-q.x)<pointsize*2
                        else
                            nearbyPoints[i].push(j) if p.x == q.x and Math.abs(p.y-q.y)<pointsize*2

            gravity = (p, alpha) ->
                if horizontal
                    p.y -= (p.y - p.true_y)*alpha
                else
                    p.x -= (p.x - p.true_x)*alpha

            collision = (p, alpha) ->
                for i in nearbyPoints[p.index]
                    q = scaledPoints[i]
                    dx = p.x - q.x
                    dy = p.y - q.y
                    d = Math.sqrt(dx*dx + dy*dy)
                    if d < pointsize*2
                        if horizontal
                            if dy < 0
                                p.y -= (pointsize*2 - d)*alpha
                                q.y += (pointsize*2 - d)*alpha
                            else
                                p.y += (pointsize*2 - d)*alpha
                                q.y -= (pointsize*2 - d)*alpha
                        else
                            if dx < 0
                                p.x -= (pointsize*2 - d)*alpha
                                q.x += (pointsize*2 - d)*alpha
                            else
                                p.x += (pointsize*2 - d)*alpha
                                q.x -= (pointsize*2 - d)*alpha

            tick = (e) ->
                for p in scaledPoints
                    collision(p, e.alpha*5)

                for p in scaledPoints
                    gravity(p, e.alpha/5)

                if horizontal
                    points.attr("cy", (d) -> d.y)
                else
                    points.attr("cx", (d) -> d.x)

            force = d3.layout.force()
                      .gravity(0)
                      .charge(0)
                      .nodes(scaledPoints)
                      .on("tick", tick)
                      .start()
        else if jitter != "none"
            displayError('jitter should be "beeswarm", "random", or "none"')

        # move box to front
        myframe.box().moveToFront()

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
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
