# timeplot: plot scatter of points but where x-axis is time

d3panels.timeplot = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    yNA = chartOpts?.yNA ? {handle:true, force:false}   # handle: include separate boxes for NAs; force: include whether or not NAs in data
    yNA_size = chartOpts?.yNA_size ? {width:20, gap:10} # width and gap for y=NA box
    xlim = chartOpts?.xlim ? null                       # x-axis limits
    ylim = chartOpts?.ylim ? null                       # y-axis limits
    pointcolor = chartOpts?.pointcolor ? null           # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black"      # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3                # color of points
    jitter = chartOpts?.jitter ? "beeswarm"             # method for jittering NA points (beeswarm|random|none)
    tipclass = chartOpts?.tipclass ? "tooltip"          # class name for tool tips
    # chartOpts end
    # further chartOpts: panelframe
    # accessors start
    xscale = null # x-axis scale
    yscale = null # y-axis scale
    yNA = yNA     # true if y-axis NAs are handled in a separate box
    points = null # points selection
    indtip = null # tooltip selection
    svg = null    # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = {x, y, indID, group}

        # args that are lists: check that they have all the pieces
        yNA = d3panels.check_listarg_v_default(yNA, {handle:true, force:false})
        yNA_size = d3panels.check_listarg_v_default(yNA, {width:20, gap:10})

        d3panels.displayError("timeplot: data.x is missing") unless data.x?
        d3panels.displayError("timeplot: data.y is missing") unless data.y?

        # missing values can be any of null, "NA", or ""; replacing with nulls
        x = d3panels.missing2null(data.x)
        y = d3panels.missing2null(data.y)

        if x.length != y.length
            d3panels.displayError("timeplot: x.length (#{x.length}) != y.length (#{y.length})")

        # convert x to datetimes
        x = (new Date(v) for v in x)
        # convert to milliseconds
        x = (v.getTime() for v in x)

        # whether to include separate boxes for NAs
        yNA.handle = yNA.force or (yNA.handle and !(y.every (v) -> (v?)))

        xlim = xlim ? d3panels.pad_ylim(d3.extent(x))
        ylim = ylim ? d3panels.pad_ylim(d3.extent(y))

        # set up frame
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.yNA = yNA.handle
        chartOpts.yNA_size = yNA_size
        chartOpts.xNA = false # don't handle NAs on x-axis

        myframe = d3panels.panelframe(chartOpts)

        # Create SVG
        myframe(selection)
        svg = myframe.svg()

        # TODO
        # need to delete and re-form the x-axis, if possible
        # or maybe just the x-axis labels

        # grab scale functions
        xscale = myframe.xscale() # TODO revise xscale to be time
        yscale = myframe.yscale()

        # add points
        addpts = d3panels.add_points({
            pointcolor:pointcolor
            pointstroke:pointstroke
            pointsize:pointsize
            jitter:jitter
            tipclass:tipclass})
        addpts(myframe, {x:x, y:y, indID:data.indID, group:data.group})
        points = addpts.points()
        indtip = addpts.indtip()

        svg.selectAll("g#xlabels text")  # grab x-axis labels
           .text((d) ->
               z = new Date(d*1) # coerce to integer and then to date
               "#{z.getFullYear()}-#{d3panels.padzeros(z.getMonth()+1)}-#{d3panels.padzeros(z.getDate())}")

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.yNA = () -> yNA.handle
    chart.points = () -> points
    chart.indtip = () -> indtip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      d3panels.tooltip_destroy(indtip)
                      null

    # return the chart function
    chart
