# scatterplot: reuseable scatterplot

scatterplot = (chartOpts) ->

    # chartOpts start
    xNA = chartOpts?.xNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    yNA = chartOpts?.yNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    xlim = chartOpts?.xlim ? null # x-axis limits
    ylim = chartOpts?.ylim ? null # y-axis limits
    pointcolor = chartOpts?.pointcolor ? null      # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black" # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3 # color of points
    tipclass = chartOpts?.tipclass ? "pointtip" # class name for tool tips
    # chartOpts end
    points = null
    svg = null
    indtip = null
    xscale = null
    yscale = null

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID, group}
        x = data.x
        y = data.y

        if x.length != y.length
            displayError("x.length (#{x.length}) != y.length (#{y.length})")

        # missing values can be any of null, "NA", or ""; replacing with nulls
        x = missing2null(x, ["NA", ""])
        y = missing2null(y, ["NA", ""])

        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? null
        indID = indID ? [1..x.length]
        if indID.length != x.length
            displayError("indID.length (#{indID.length}) != x.length (#{x.length})")

        # groups of colors
        group = data?.group ? (1 for i in x)
        ngroup = d3.max(group)
        group = (g-1 for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            displayError("group values out of range")
            console.log("ngroup: #{ngroup}")
            console.log("g:")
            console.log(g)
        if group.length != x.length
            displayError("group.length (#{group.length}) != x.length (#{x.length})")

        # colors of the points in the different groups
        pointcolor = pointcolor ? selectGroupColors(ngroup, "dark")
        pointcolor = expand2vector(pointcolor, ngroup)
        if pointcolor.length != ngroup
            displayError("pointcolor.length (#{pointcolor.length}) != ngroup (#{ngroup})")

        # if all (x,y) not null
        xNA.handle = false if x.every (v) -> (v?) and !xNA.force
        yNA.handle = false if y.every (v) -> (v?) and !yNA.force

        xlim = xlim ? d3.extent(x)
        ylim = ylim ? d3.extent(y)

        # set up frame
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.xNA = xNA.handle
        chartOpts.yNA = yNA.handle
        myframe = panelframe(chartOpts)

        # Create SVG
        myframe(selection)
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # individual tooltips
        indtip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d,i) -> indID[i])
                   .direction('e')
                   .offset([0,10])
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
                  .attr("opacity", (d,i) ->
                                       return 1 if (x[i]? or xNA.handle) and (y[i]? or yNA.handle)
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
                      null

    # return the chart function
    chart
