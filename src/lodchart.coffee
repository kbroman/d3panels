# lodchart: plot of LOD curves

d3panels.lodchart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    linecolor = chartOpts?.linecolor ? "darkslateblue" # color for LOD curves
    linewidth = chartOpts?.linewidth ? 2               # width (pixels) for LOD curves
    pointcolor = chartOpts?.pointcolor ? "#e9cfec"     # color of points at markers
    pointsize = chartOpts?.pointsize ? 0               # pointsize at markers (if 0, no points plotted)
    pointstroke = chartOpts?.pointstroke ? "black"     # color of circle around points at markers
    ylim = chartOpts?.ylim ? null # y-axis limits; if null, use range of data
    tipclass = chartOpts?.tipclass ? "tooltip" # class name for tool tips
    # chartOpts end
    yscale = null
    xscale = null
    chrSelect = null
    markerSelect = null
    markertip = null
    svg = null

    ## the main function
    chart = (selection, data) -> # data = {chr, pos, lod, marker} each an ordered vector
                                 #    optionally also chrname, chrstart, chrend with chr IDs, start and end positions

        # check lengths
        if(data.pos.length != data.chr.length)
            d3panels.displayError("data.pos.length (#{data.pos.length}) != data.chr.length (#{data.chr.length})")
        if(data.lod.length != data.chr.length)
            d3panels.displayError("data.lod.length (#{data.lod.length}) != data.chr.length (#{data.chr.length})")
        if(data.marker.length != data.chr.length)
            d3panels.displayError("data.marker.length (#{data.lod.length}) != data.chr.length (#{data.chr.length})")

        # create chrname, chrstart, chrend if missing
        data.chrname = d3panels.unique(data.chr) unless data.chrname?
        unless data.chrstart?
            data.chrstart = []
            for c in data.chrname
                these_pos = (data.pos[i] for i of data.chr when data.chr[i] == c)
                data.chrstart.push(d3.min(these_pos))
        unless data.chrend?
            data.chrend = []
            for c in data.chrname
                these_pos = (data.pos[i] for i of data.chr when data.chr[i] == c)
                data.chrend.push(d3.max(these_pos))

        # organize positions and LOD scores by chromosomes
        data = d3panels.reorgLodData(data)

        # y-axis limits
        chartOpts.ylim = ylim ? [0, d3.max(data.lod)*1.05]

        # set up frame
        myframe = d3panels.chrpanelframe(chartOpts)

        # Create SVG
        myframe(selection, {chr:data.chrname,start:data.chrstart,end:data.chrend})
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # chromosome rectangles
        chrSelect = myframe.chrSelect()

        # dummy chart for calling add_lodcurve()
        self_chart = {
            svg: -> svg
            xscale: -> xscale
            yscale: -> yscale}

        # plot curves and points
        add2chart = d3panels.add_lodcurve(chartOpts)
        add2chart(self_chart, data)

        # grab selections
        markerSelect = add2chart.markerSelect()
        markertip = add2chart.markertip()

        # move box to front
        myframe.box().moveToFront()

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.chrSelect = () -> chrSelect
    chart.markerSelect = () -> markerSelect
    chart.markertip = () -> markertip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      markertip.destroy()
                      return null

    # return the chart function
    chart
