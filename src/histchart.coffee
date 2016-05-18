# histchart: chart with multiple curves

d3panels.histchart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    xlim = chartOpts?.xlim ? null                     # x-axis limits (if null, taken from data)
    ylim = chartOpts?.ylim ? null                     # y-axis limits (if null, taken from data)
    xlab = chartOpts?.xlab ? ""                       # x-axis label
    ylab = chartOpts?.ylab ? ""                       # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? null       # whether to rotate the y-axis label
    linecolor = chartOpts?.linecolor ? null           # color of curves (if null, use pastel colors by group)
    linecolorhilit = chartOpts?.linecolorhilit ? null # color of highlighted curve (if null, use dark colors by group)
    linewidth = chartOpts?.linewidth ? 2              # width of curve
    linewidthhilit = chartOpts?.linewidthhilit ? 2    # width of highlighted curve
    density = chartOpts?.density ? true               # density scale (vs counts)
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
    chart = (selection, data) -> # {x, breaks, indID}
                                 # x is a 2-d ragged array indexed as x[subject][response_index]
                                 # breaks is either a number or its a vector of breakpoints
                                 #    if breaks is missing, we take 2*sqrt(maximum number of x values)
                                 # indID is optional; if provided, it should have length x.length

        d3panels.displayError("histchart: data.x is missing") unless data.x?
        x = data.x
        data.group = (+i+1 for i of x)

        n_ind = x.length

        unless data.breaks?
            maxn = d3.max( (xv.length for xv in x) )
            data.breaks = [2 * Math.ceil(Math.sqrt(maxn)+1)]
        breaks = d3panels.forceAsArray(data.breaks)

        xlim = xlim ? d3panels.matrixExtent(x)

        if breaks.length == 1 # number
            breaks = d3panels.calc_breaks(breaks[0], xlim[0], xlim[1])

        # omit values that are not within the limit
        brlim = [d3.min(breaks)-1e-6, d3.max(breaks)+1e-6]
        x = ((xv for xv in xx when xv >= brlim[0] & xv <= brlim[1]) for xx in x)

        # calculate frequencies
        freq = (d3panels.calc_freq(xv, breaks, !density) for xv in x)

        # find maximum location for each curve (to use for tool tips)
        maxpos = []
        for f in freq
            pt = {x:breaks[1], y:f[0]}
            for j in d3.range(f.length)
                if f[j] > pt.y
                    pt.y = f[j]
                    pt.x = breaks[j+1]
            maxpos.push(pt)

        # y-axis limit
        ylim = ylim ? [0, d3panels.matrixMax(freq)*1.05]

        # set up frame
        chartOpts.xlim = xlim
        chartOpts.ylim = ylim
        chartOpts.xNA = false # don't allow NA boxes
        chartOpts.yNA = false
        chartOpts.xlab = xlab
        chartOpts.ylab = ylab
        chartOpts.rotate_ylab = rotate_ylab
        myframe = d3panels.panelframe(chartOpts)

        # create SVG
        myframe(selection)
        svg = myframe.svg()

        # scales
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # curve data
        path_data = (d3panels.calc_hist_path(f, breaks) for f in freq)

        # pull apart the path data
        path_x = ((d.x for d in p) for p in path_data)
        path_y = ((d.y for d in p) for p in path_data)

        add_curves = d3panels.add_curves({
            linecolor:linecolor
            linecolorhilit:linecolorhilit
            linewidth:linewidth
            linewidthhilit:linewidthhilit
            tipclass:tipclass})
        add_curves(myframe, {x:path_x, y:path_y, indID:data.indID, group:data.group})
        curves = add_curves.curves()
        indtip = add_curves.indtip()

        # adjust locations of hidden points
        add_curves.points()
                  .attr("cx", (d,i) -> xscale(maxpos[i].x))
                  .attr("cy", (d,i) -> yscale(maxpos[i].y))


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
