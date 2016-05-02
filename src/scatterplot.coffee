# scatterplot: reuseable scatterplot

scatterplot = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xNA = chartOpts?.xNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    yNA = chartOpts?.yNA ? {handle:true, force:false} # handle: include separate boxes for NAs; force: include whether or not NAs in data
    xNA_size = chartOpts?.xNA_size ? {width:20, gap:10} # width and gap for x=NA box
    yNA_size = chartOpts?.yNA_size ? {width:20, gap:10} # width and gap for y=NA box
    xlim = chartOpts?.xlim ? null # x-axis limits
    ylim = chartOpts?.ylim ? null # y-axis limits
    pointcolor = chartOpts?.pointcolor ? null      # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black" # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3 # color of points
    jitter = chartOpts?.jitter ? "beeswarm" # method for jittering NA points (beeswarm|random|none)
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    points = null
    indtip = null
    svg = null

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID, group}
        # missing values can be any of null, "NA", or ""; replacing with nulls
        x = missing2null(data.x)
        y = missing2null(data.y)

        if x.length != y.length
            displayError("x.length (#{x.length}) != y.length (#{y.length})")
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

        # whether to include separate boxes for NAs
        xNA.handle = xNA.force or (xNA.handle and !(x.every (v) -> (v?)))
        yNA.handle = yNA.force or (yNA.handle and !(y.every (v) -> (v?)))

        xlim = xlim ? d3.extent(x)
        ylim = ylim ? d3.extent(y)

        # set up frame
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.xNA = xNA.handle
        chartOpts.yNA = yNA.handle
        chartOpts.xNA_size = xNA_size
        chartOpts.yNA_size = yNA_size

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
        if xNA.handle or yNA.handle
            if jitter == "random"
                xwid = xNA_size.width-pointsize-2
                xwid = if xwid <= 2 then 2 else xwid
                ywid = yNA_size.width-pointsize-2
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
                            if p.xnull == q.xnull and p.ynull == q.ynull and (p.xnull or p.ynull)
                                if p.xnull and p.ynull
                                    nearbyPoints[i].push(j)
                                else if p.xnull
                                    nearbyPoints[i].push(j) if Math.abs(p.y-q.y)<pointsize*2
                                else if p.ynull
                                    nearbyPoints[i].push(j) if Math.abs(p.x-q.x)<pointsize*2

                gravity = (p, alpha) ->
                    if p.xnull
                            p.x -= (p.x - p.true_x)*alpha
                    if p.ynull
                            p.y -= (p.y - p.true_y)*alpha

                collision = (p, alpha) ->
                    for i in nearbyPoints[p.index]
                        q = scaledPoints[i]
                        dx = p.x - q.x
                        dy = p.y - q.y
                        d = Math.sqrt(dx*dx + dy*dy)
                        if d < pointsize*2
                            if p.xnull
                                if dx < 0
                                    p.x -= (pointsize*2 - d)*alpha
                                    q.x += (pointsize*2 - d)*alpha
                                else
                                    p.x += (pointsize*2 - d)*alpha
                                    q.x -= (pointsize*2 - d)*alpha
                            if p.ynull
                                p.y -= (pointsize*2 - d)*alpha
                                q.y += (pointsize*2 - d)*alpha

                tick = (e) ->
                    for p in scaledPoints
                        collision(p, e.alpha*5)

                    for p in scaledPoints
                        gravity(p, e.alpha/5)

                    points.attr("cx", (d,i) -> scaledPoints[i].x)
                          .attr("cy", (d,i) -> scaledPoints[i].y)

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
                      null

    # return the chart function
    chart
