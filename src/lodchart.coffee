# lodchart: plot of LOD curves

d3panels.lodchart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    linecolor = chartOpts?.linecolor ? "darkslateblue" # color for LOD curves
    linewidth = chartOpts?.linewidth ? 2               # width (pixels) for LOD curves
    pointcolor = chartOpts?.pointcolor ? "#e9cfec"     # color of points at markers
    pointsize = chartOpts?.pointsize ? 0               # pointsize at markers (if 0, no points plotted)
    pointstroke = chartOpts?.pointstroke ? "black"     # color of circle around points at markers
    ylim = chartOpts?.ylim ? null                      # y-axis limits; if null, use range of data
    tipclass = chartOpts?.tipclass ? "tooltip"         # class name for tool tips
    # chartOpts end
    # further chartOpts: chrpanelframe
    # accessors start
    xscale = null         # x-axis scale (vector by chromosome)
    yscale = null         # y-axis scale
    chrSelect = null      # chromosome rectangle selection
    markerSelect = null   # points at markers selection
    markertip = null      # tooltips selection
    svg = null            # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = {chr, pos, lod, marker} each an ordered vector
                                 #    optionally also chrname, chrstart, chrend with chr IDs, start and end positions

        d3panels.displayError("lodchart: data.chr is missing") unless data.chr?
        d3panels.displayError("lodchart: data.pos is missing") unless data.pos?
        d3panels.displayError("lodchart: data.lod is missing") unless data.lod?
        d3panels.displayError("lodchart: data.marker is missing") unless data.marker?

        # check lengths
        if(data.pos.length != data.chr.length)
            d3panels.displayError("lodchart: data.pos.length (#{data.pos.length}) != data.chr.length (#{data.chr.length})")
        if(data.lod.length != data.chr.length)
            d3panels.displayError("lodchart: data.lod.length (#{data.lod.length}) != data.chr.length (#{data.chr.length})")
        unless data.marker? # if data.marker not included, create it with a bunch of blanks
            data.marker = ['' for i of data.chr]
        if(data.marker.length != data.chr.length)
            d3panels.displayError("lodchart: data.marker.length (#{data.marker.length}) != data.chr.length (#{data.chr.length})")

        # create chrname, chrstart, chrend if missing
        data = d3panels.add_chrname_start_end(data)

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
        myframe.box().raise()

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
                      d3panels.tooltip_destroy(markertip)
                      return null

    # return the chart function
    chart
