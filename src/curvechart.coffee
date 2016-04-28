# curvechart: reuseable chart with many curves

curvechart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xlim = chartOpts?.xlim ? null # x-axis limits (if null, taken from data)
    ylim = chartOpts?.ylim ? null # y-axis limits (if null, taken from data)
    strokecolor = chartOpts?.strokecolor ? null           # color of curves (if null, use paste colors by group)
    strokecolorhilit = chartOpts?.strokecolorhilit ? null # color of highlighted curve (if null, use dark colors by group)
    strokewidth = chartOpts?.strokewidth ? 2           # width of curve
    strokewidthhilit = chartOpts?.strokewidthhilit ? 2 # width of highlighted curve
    tipclass = chartOpts?.tipclass ? "curvetip"
    # chartOpts end
    xscale = null
    yscale = null
    curvesSelect = null
    svg = null
    indtip = null

    ## the main function
    chart = (selection, data) -> # {x, y, indID, group}
                                 # x and y both ragged arrays indexed as y[subject][response_index]
                                 # if x has one subject, y's should all have same length, and x is then expanded to match

            x = data.x
            y = data.y

            n_ind = y.length
            if x.length == 1 # expand to same length
                for j in [2..n_ind]
                    x.push(x[0])
            if(x.length != n_ind)
                displayError("data.x.length (#{x.length}) != data.y.length (#{n_ind})")

            # grab indID if it's there
            # if no indID, create a vector of them
            indID = data?.indID ? [1..n_ind]
            if(indID.length != n_ind)
                displayError("data.indID.length (#{indID.length}) != data.y.length (#{n_ind})")

            # groups of colors
            group = data?.group ? (1 for i of y)
            ngroup = d3.max(group)
            group = (g-1 for g in group) # changed from (1,2,3,...) to (0,1,2,...)
            if sumArray(g < 0 or g > ngroup-1 for g in group) > 0
                displayError("group values out of range")
                console.log("groups:")
                console.log(g)
            if(group.length != n_ind)
                displayError("data.group.length (#{group.length}) != data.y.length (#{n_ind})")

            # check that x's and y's are all of the same length
            for i of y
                if(x[i].length != y[i].length)
                    displayError("length(x) (#{x[i].length}) != length(y) (#{y[i].length}) for individual #{indID[i]} (index #{i+1})")

            # default light stroke colors
            strokecolor = strokecolor ? selectGroupColors(ngroup, "pastel")
            strokecolor = expand2vector(strokecolor, ngroup)

            # default dark stroke colors
            strokecolorhilit = strokecolorhilit ? selectGroupColors(ngroup, "dark")
            strokecolorhilit = expand2vector(strokecolorhilit, ngroup)

            # x- and y-axis limits
            xlim = xlim ? matrixExtent(x)
            ylim = ylim ? matrixExtent(y)
            chartOpts.xlim = xlim
            chartOpts.ylim = ylim

            # convert NAs to null
            for i of x
                x[i] = missing2null(x[i])
                y[i] = missing2null(y[i])

            # reorganize data
            dataByPoint = []
            for i of y
                dataByPoint.push({x:x[i][j], y:y[i][j]} for j of y[i] when x[i][j]? and y[i][j]?)

            # don't allow NA boxes
            chartOpts.xNA = false
            chartOpts.yNA = false

            # set up frame
            myframe = panelframe(chartOpts)

            # create SVG
            myframe(selection)
            svg = myframe.svg()

            # scales
            xscale = myframe.xscale()
            yscale = myframe.yscale()

            indtip = d3.tip()
                       .attr('class', "d3-tip #{tipclass}")
                       .html((d) -> indID[d])
                       .direction('e')
                       .offset([0,10])
            svg.call(indtip)

            curve = d3.svg.line()
                     .x((d) -> xscale(d.x))
                     .y((d) -> yscale(d.y))

            curves = svg.append("g").attr("id", "curves")
            curvesSelect =
               curves.selectAll("empty")
                     .data(d3.range(n_ind))
                     .enter()
                     .append("path")
                     .datum((d) -> dataByPoint[d])
                     .attr("d", curve)
                     .attr("class", (d,i) -> "path#{i}")
                     .attr("fill", "none")
                     .attr("stroke", (d,i) -> strokecolor[group[i]])
                     .attr("stroke-width", strokewidth)
                     .on "mouseover.panel", (d,i) ->
                                               d3.select(this).attr("stroke", strokecolorhilit[group[i]]).moveToFront()
                                               circle = d3.select("circle#hiddenpoint#{i}")
                                               indtip.show(i, circle.node())
                     .on "mouseout.panel", (d,i) ->
                                               d3.select(this).attr("stroke", strokecolor[group[i]]).moveToBack()
                                               indtip.hide()

            # grab the last non-null point from each curve
            lastpoint = ({x:null, y:null} for i of data)
            for i of dataByPoint
                for v in dataByPoint[i]
                    lastpoint[i] = v if v.x? and v.y?

            pointsg = svg.append("g").attr("id", "invisiblepoints")
            points = pointsg.selectAll("empty")
                            .data(lastpoint)
                            .enter()
                            .append("circle")
                            .attr("id", (d,i) -> "hiddenpoint#{i}")
                            .attr("cx", (d) -> xscale(d.x))
                            .attr("cy", (d) -> yscale(d.y))
                            .attr("r", 1)
                            .attr("opacity", 0)

    # functions to grab stuff
    chart.yscale = () -> yscale
    chart.xscale = () -> xscale
    chart.curvesSelect = () -> curvesSelect
    chart.svg = () -> svg
    chart.indtip = () -> indtip

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
