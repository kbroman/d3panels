# curvechart: chart with multiple curves

d3panels.curvechart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xlim = chartOpts?.xlim ? null                     # x-axis limits (if null, taken from data)
    ylim = chartOpts?.ylim ? null                     # y-axis limits (if null, taken from data)
    linecolor = chartOpts?.linecolor ? null           # color of curves (if null, use pastel colors by group)
    linecolorhilit = chartOpts?.linecolorhilit ? null # color of highlighted curve (if null, use dark colors by group)
    linewidth = chartOpts?.linewidth ? 2              # width of curve
    linewidthhilit = chartOpts?.linewidthhilit ? 2    # width of highlighted curve
    tipclass = chartOpts?.tipclass ? "tooltip"        # class name for tool tips
    # chartOpts end
    # further chartOpts: panelframe (omit xNA yNA xNA_size yNA_size)
    # accessors start
    xscale = null        # x-axis scale
    yscale = null        # y-axis scale
    curves = null        # curves selection
    points = null        # hidden points where the tool tips attach
    indtip = null        # tooltip selection
    svg = null           # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # {x, y, indID, group}
                                 # x and y both ragged arrays indexed as y[subject][response_index]
                                 # if x has one subject, y's should all have same length, and x is then expanded to match

        d3panels.displayError("curvechart: data.x is missing") unless data.x?
        d3panels.displayError("curvechart: data.y is missing") unless data.y?

        x = data.x
        y = data.y

        n_ind = y.length
        if x.length == 1 and y.length > 1 # expand to same length
            for j in [2..n_ind]
                x.push(x[0])
        if(x.length != n_ind)
            d3panels.displayError("curvechart: data.x.length (#{x.length}) != data.y.length (#{n_ind})")

        # x- and y-axis limits
        xlim = xlim ? d3panels.matrixExtent(x)
        ylim = ylim ? d3panels.matrixExtent(y)
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim

        # don't allow NA boxes
        chartOpts.xNA = false
        chartOpts.yNA = false

        # set up frame
        myframe = d3panels.panelframe(chartOpts)

        # create SVG
        myframe(selection)
        svg = myframe.svg()

        # scales
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        add_curves = d3panels.add_curves({
            linecolor:linecolor
            linecolorhilit:linecolorhilit
            linewidth:linewidth
            linewidthhilit:linewidthhilit
            tipclass:tipclass})
        add_curves(myframe, data)
        curves = add_curves.curves()
        points = add_curves.points()
        indtip = add_curves.indtip()

        # move box to front
        myframe.box().raise()

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.curves = () -> curves
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
