# add_points: add points to a plain panelframe() chart

d3panels.add_points = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    pointcolor = chartOpts?.pointcolor ? null      # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black" # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3 # color of points
    jitter = chartOpts?.jitter ? "beeswarm" # method for jittering NA points (beeswarm|random|none)
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    # accessors start
    points = null # points selection
    indtip = null # tooltip selection
    # accessors end
    pointGroup = null    # group containing the curves

    chart = (prevchart, data) -> # prevchart = chart function used to create lodchart to which we're adding
                                 # data = {x, y, indID, group}

        x = d3panels.missing2null(data.x)
        y = d3panels.missing2null(data.y)

        if x.length != y.length
            d3panels.displayError("x.length (#{x.length}) != y.length (#{y.length})")
        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? null
        indID = indID ? [1..x.length]
        if indID.length != x.length
            d3panels.displayError("indID.length (#{indID.length}) != x.length (#{x.length})")

        # groups of colors
        group = data?.group ? (1 for i in x)
        ngroup = d3.max(group)
        group = (g-1 for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if d3panels.sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            d3panels.displayError("group values out of range")
            console.log("ngroup: #{ngroup}")
            console.log("g:")
            console.log(g)
        if group.length != x.length
            d3panels.displayError("group.length (#{group.length}) != x.length (#{x.length})")

        # colors of the points in the different groups
        pointcolor = pointcolor ? d3panels.selectGroupColors(ngroup, "dark")
        pointcolor = d3panels.expand2vector(pointcolor, ngroup)
        if pointcolor.length != ngroup
            d3panels.displayError("pointcolor.length (#{pointcolor.length}) != ngroup (#{ngroup})")

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

        # move box to front
        prevchart.box().moveToFront()

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
