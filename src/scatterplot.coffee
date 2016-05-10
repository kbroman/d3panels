# scatterplot: plot scatter of points, y versus x

d3panels.scatterplot = (chartOpts) ->
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
    # further chartOpts: panelframe
    # accessors start
    xscale = null # x-axis scale
    yscale = null # y-axis scale
    xNA = xNA     # true if x-axis NAs are handled in a separate box
    yNA = yNA     # true if y-axis NAs are handled in a separate box
    points = null # points selection
    indtip = null # tooltip selection
    svg = null    # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID, group}
        # missing values can be any of null, "NA", or ""; replacing with nulls
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

        # whether to include separate boxes for NAs
        xNA.handle = xNA.force or (xNA.handle and !(x.every (v) -> (v?)))
        yNA.handle = yNA.force or (yNA.handle and !(y.every (v) -> (v?)))

        xlim = xlim ? d3panels.pad_ylim(d3.extent(x))
        ylim = ylim ? d3panels.pad_ylim(d3.extent(y))

        # set up frame
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.xNA = xNA.handle
        chartOpts.yNA = yNA.handle
        chartOpts.xNA_size = xNA_size
        chartOpts.yNA_size = yNA_size

        myframe = d3panels.panelframe(chartOpts)

        # Create SVG
        myframe(selection)
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # add points
        addpts = d3panels.add_points({
            pointcolor:pointcolor
            pointstroke:pointstroke
            pointsize:pointsize
            jitter:jitter
            tipclass:tipclass})
        addpts(myframe, {x:x, y:y, indID:indID, group:(g+1 for g in group)})
        points = addpts.points()
        indtip = addpts.indtip()

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
                      null

    # return the chart function
    chart
