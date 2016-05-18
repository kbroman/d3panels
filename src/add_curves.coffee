# add_curves: add curves to a plain panelframe() chart

d3panels.add_curves = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    linecolor = chartOpts?.linecolor ? null            # color for curves (if null, use pastel colors by group)
    linecolorhilit = chartOpts?.linecolorhilit ? null  # color for curves when hightlighted (if null, use dark colors by group)
    linewidth = chartOpts?.linewidth ? 2               # width (pixels) for curves
    linewidthhilit = chartOpts?.linewidthhilit ? 2     # width (pixels) for curves
    tipclass = chartOpts?.tipclass ? "tooltip"         # class name for tool tips
    # chartOpts end
    # accessors start
    curves = null   # select the curve
    points = null   # hidden points where the tool tips attach
    indtip = null   # tool tip selection
    # accessors end
    curveGroup = null    # group containing the curves
    pointGroup = null    # group containing the hidden points

    chart = (prevchart, data) -> # prevchart = chart function used to create lodchart to which we're adding
                                 # data = {x, y, indID, group}
                                 #    x and y both ragged arrays indexed as y[subject][response_index]
                                 # if x has one subject, y's should all have same length, and x is then expanded to match

        d3panels.displayError("add_curves: data.x is missing") unless data.x?
        d3panels.displayError("add_curves: data.y is missing") unless data.y?

        x = (d3panels.missing2null(x) for x in data.x)
        y = (d3panels.missing2null(y) for y in data.y)

        n_ind = y.length
        if x.length == 1 and y.length > 1 # expand to same length
            for j in [2..n_ind]
                x.push(x[0])
        if(x.length != n_ind)
            d3panels.displayError("add_curves: data.x.length (#{x.length}) != data.y.length (#{n_ind})")

        indID = data?.indID ? [1..n_ind]
        if(indID.length != n_ind)
            d3panels.displayError("add_curves: data.indID.length (#{indID.length}) != data.y.length (#{n_ind})")

        group = data?.group ? (1 for i of y)
        ngroup = d3.max(group)
        group = ((if g? then g-1 else g) for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if d3panels.sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            d3panels.displayError("add_curves: group values out of range")
            console.log("distinct groups: #{d3panels.unique(group)}")
        if(group.length != n_ind)
            d3panels.displayError("add_curves: data.group.length (#{group.length}) != data.y.length (#{n_ind})")

        # check that x's and y's are all of the same length
        for i of y
            if(x[i].length != y[i].length)
                d3panels.displayError("add_curves: length(x) (#{x[i].length}) != length(y) (#{y[i].length}) for individual #{indID[i]} (index #{i+1})")

        # default light line colors
        linecolor = linecolor ? d3panels.selectGroupColors(ngroup, "pastel")
        linecolor = d3panels.expand2vector(linecolor, ngroup)

        # default dark line colors
        linecolorhilit = linecolorhilit ? d3panels.selectGroupColors(ngroup, "dark")
        linecolorhilit = d3panels.expand2vector(linecolorhilit, ngroup)

        svg = prevchart.svg()

        # grab scale functions
        xscale = prevchart.xscale()
        yscale = prevchart.yscale()

        # reorganize data
        dataByPoint = []
        for i of y
            dataByPoint.push({x:x[i][j], y:y[i][j]} for j of y[i] when x[i][j]? and y[i][j]?)

        indtip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d) -> indID[d])
                   .direction('e')
                   .offset([0,10])
        svg.call(indtip)

        curvefunc = d3.svg.line()
                 .x((d) -> xscale(d.x))
                 .y((d) -> yscale(d.y))

        curveGroup = svg.append("g").attr("id", "curves")
        curves =
           curveGroup.selectAll("empty")
                 .data(d3.range(n_ind))
                 .enter()
                 .append("path")
                 .datum((d) -> dataByPoint[d])
                 .attr("d", curvefunc)
                 .attr("class", (d,i) -> "path#{i}")
                 .attr("fill", "none")
                 .attr("stroke", (d,i) -> linecolor[group[i]])
                 .attr("stroke-width", linewidth)
                 .on "mouseover.panel", (d,i) ->
                                           d3.select(this).attr("stroke", linecolorhilit[group[i]])
                                                          .attr("stroke-width", linewidthhilit)
                                                          .moveToFront()
                                           circle = svg.select("circle#hiddenpoint#{i}")
                                           indtip.show(i, circle.node())
                 .on "mouseout.panel", (d,i) ->
                                           d3.select(this).attr("stroke", linecolor[group[i]])
                                                          .attr("stroke-width", linewidth)
                                           indtip.hide()

        # grab the last non-null point from each curve
        lastpoint = ({x:null, y:null} for i of data.x)
        for i of dataByPoint
            for v in dataByPoint[i]
                lastpoint[i] = v if v.x? and v.y?

        pointGroup = svg.append("g").attr("id", "invisiblepoints")
        points = pointGroup.selectAll("empty")
                        .data(lastpoint)
                        .enter()
                        .append("circle")
                        .attr("id", (d,i) -> "hiddenpoint#{i}")
                        .attr("cx", (d) -> xscale(d.x))
                        .attr("cy", (d) -> yscale(d.y))
                        .attr("r", 1)
                        .attr("opacity", 0)

        # move box to front
        prevchart.box().moveToFront()

    # functions to grab stuff
    chart.curves = () -> curves
    chart.indtip = () -> indtip
    chart.points = () -> points

    # function to remove chart
    chart.remove = () ->
                      curveGroup.remove()
                      pointGroup.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
