# add_points: add points to a plain panelframe() chart

d3panels.add_points = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    pointcolor = chartOpts?.pointcolor ? null      # fill color of points
    pointsize = chartOpts?.pointsize ? 3           # size of points
    pointstroke = chartOpts?.pointstroke ? "black" # color of points' outer circle
    jitter = chartOpts?.jitter ? "beeswarm"        # method for jittering NA points (beeswarm|random|none)
    tipclass = chartOpts?.tipclass ? "tooltip"     # class name for tool tips
    # chartOpts end
    # accessors start
    points = null # points selection
    indtip = null # tooltip selection
    # accessors end
    pointGroup = null    # group containing the curves

    chart = (prevchart, data) -> # prevchart = chart function used to create lodchart to which we're adding
                                 # data = {x, y, indID, group}

        d3panels.displayError("add_points: data.x is missing") unless data.x?
        d3panels.displayError("add_points: data.y is missing") unless data.y?

        x = d3panels.missing2null(data.x)
        y = d3panels.missing2null(data.y)

        if x.length != y.length
            d3panels.displayError("add_points: x.length (#{x.length}) != y.length (#{y.length})")
        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? null
        indID = indID ? [1..x.length]
        if indID.length != x.length
            d3panels.displayError("add_points: indID.length (#{indID.length}) != x.length (#{x.length})")

        # groups of colors
        group = data?.group ? (1 for i in x)
        ngroup = d3.max(group)
        group = ((if g? then g-1 else g) for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if d3panels.sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            d3panels.displayError("add_points: group values out of range")
            console.log("ngroup: #{ngroup}")
            console.log("distinct groups: #{d3panels.unique(group)}")
        if group.length != x.length
            d3panels.displayError("add_points: group.length (#{group.length}) != x.length (#{x.length})")

        # colors of the points in the different groups
        pointcolor = pointcolor ? d3panels.selectGroupColors(ngroup, "dark")
        pointcolor = d3panels.expand2vector(pointcolor, ngroup)
        if pointcolor.length < ngroup
            d3panels.displayError("add_points: pointcolor.length (#{pointcolor.length}) < ngroup (#{ngroup})")

        svg = prevchart.svg()

        # grab scale functions
        xscale = prevchart.xscale()
        yscale = prevchart.yscale()

        # individual tooltips
        indtip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d,i) -> indID[i])
                   .direction('e')
                   .offset([0,10+pointsize])
        svg.call(indtip)

        pointGroup = svg.append("g").attr("id", "points")
        points =
            pointGroup.selectAll("empty")
                  .data(d3.range(x.length))
                  .enter()
                  .append("circle")
                  .attr("cx", (d,i) -> xscale(x[i]))
                  .attr("cy", (d,i) -> yscale(y[i]))
                  .attr("class", (d,i) -> "pt#{i}")
                  .attr("r", pointsize)
                  .attr("fill", (d,i) -> pointcolor[group[i]])
                  .attr("stroke", pointstroke)
                  .attr("stroke-width", "1")
                  .on("mouseover.paneltip", indtip.show)
                  .on("mouseout.paneltip", indtip.hide)


        # jitter missing values?
        if prevchart.xNA() or prevchart.yNA()
            if jitter == "random"
                xwid = 20-pointsize-2
                xwid = if xwid <= 2 then 2 else xwid
                ywid = 20-pointsize-2
                ywid = if ywid <= 2 then 2 else ywid
                ux = ((Math.random()-0.5)*xwid for i of x)
                uy = ((Math.random()-0.5)*ywid for i of x)
                points.attr("cx", (d,i) ->
                            return xscale(x[i]) if x[i]?
                            xscale(x[i])+ux[i])
                      .attr("cy", (d,i) ->
                            return yscale(y[i]) if y[i]?
                            yscale(y[i])+uy[i])

            else if jitter == "beeswarm"

                scaledPoints = ({x:xscale(x[i]),y:yscale(y[i]),xnull:!x[i]?,ynull:!y[i]?} for i of x)

                # assign .fx and .fy when you don't want .x or .y to change
                d3.range(scaledPoints.length).map((i) ->
                    scaledPoints[i].fx = scaledPoints[i].x unless scaledPoints[i].xnull
                    scaledPoints[i].fy = scaledPoints[i].y unless scaledPoints[i].ynull)

                ticked = () ->
                    points.attr("cx", (d,i) -> scaledPoints[i].x)
                          .attr("cy", (d,i) -> scaledPoints[i].y)

                force = d3.forceSimulation(scaledPoints)
                          .force("x", d3.forceX((d) -> d.x))
                          .force("y", d3.forceY((d) -> d.y))
                          .force("collide", d3.forceCollide(pointsize*1.1))
                          .on("tick", ticked)

            else if jitter != "none"
                d3panels.displayError('add_points: jitter should be "beeswarm", "random", or "none"')

        # move box to front
        prevchart.box().raise()

    # functions to grab stuff
    chart.points = () -> points
    chart.indtip = () -> indtip

    # function to remove chart
    chart.remove = () ->
                      pointGroup.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
