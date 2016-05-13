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
    # further chartOpts: panelframe
    # accessors start
    xscale = null        # x-axis scale
    yscale = null        # y-axis scale
    curves = null        # curves selection
    indtip = null        # tooltip selection
    svg = null           # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # {x, y, indID, group}
                                 # x and y both ragged arrays indexed as y[subject][response_index]
                                 # if x has one subject, y's should all have same length, and x is then expanded to match

        x = d3panels.missing2null(data.x)
        y = d3panels.missing2null(data.y)

        n_ind = y.length
        if x.length == 1 and y.length > 1 # expand to same length
            for j in [2..n_ind]
                x.push(x[0])
        if(x.length != n_ind)
            d3panels.displayError("data.x.length (#{x.length}) != data.y.length (#{n_ind})")

        # grab indID if it's there
        # if no indID, create a vector of them
        indID = data?.indID ? [1..n_ind]
        if(indID.length != n_ind)
            d3panels.displayError("data.indID.length (#{indID.length}) != data.y.length (#{n_ind})")

        # groups of colors
        group = data?.group ? (1 for i of y)
        ngroup = d3.max(group)
        group = (if g? then g-1 else null for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if d3panels.sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            d3panels.displayError("group values out of range")
            console.log("groups:")
            console.log(g)
        if(group.length != n_ind)
            d3panels.displayError("data.group.length (#{group.length}) != data.y.length (#{n_ind})")

        # check that x's and y's are all of the same length
        for i of y
            if(x[i].length != y[i].length)
                d3panels.displayError("length(x) (#{x[i].length}) != length(y) (#{y[i].length}) for individual #{indID[i]} (index #{i+1})")

        # default light stroke colors
        strokecolor = strokecolor ? d3panels.selectGroupColors(ngroup, "pastel")
        strokecolor = d3panels.expand2vector(strokecolor, ngroup)

        # default dark stroke colors
        strokecolorhilit = strokecolorhilit ? d3panels.selectGroupColors(ngroup, "dark")
        strokecolorhilit = d3panels.expand2vector(strokecolorhilit, ngroup)

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
        indtip = add_curves.indtip()

        # move box to front
        myframe.box().moveToFront()

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.curves = () -> curves
    chart.indtip = () -> indtip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      return null

    # return the chart function
    chart
