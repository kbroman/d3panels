# mapchart: plot of a genetic marker map

d3panels.mapchart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    tickwidth = chartOpts?.tickwidth ? 10                 # width of ticks at markers
    linecolor = chartOpts?.linecolor ? "slateblue"        # line color
    linecolorhilit = chartOpts?.linecolorhilit ? "Orchid" # line color when highlighted
    linewidth = chartOpts?.linewidth ? 3                  # line width (pixels)
    xlab = chartOpts?.xlab ? "Chromosome"                 # x-axis label
    ylab = chartOpts?.ylab ? "Position (cM)"              # y-axis label
    xlineOpts = chartOpts?.xlineOpts ? {color:"#cdcdcd", width:5} # color and width of vertical lines
    horizontal = chartOpts?.horizontal ? false            # whether chromosomes should be laid at horizontally
    v_over_h = chartOpts?.v_over_h ? horizontal           # whether vertical lines should be on top of horizontal lines
    shiftStart = chartOpts?.shiftStart ? false            # if true, shift start of chromosomes to 0
    tipclass = chartOpts?.tipclass ? "tooltip"            # class name for tool tips
    # chartOpts end
    # further chartOpts: panelframe (omit xNA yNA xNA_size yNA_size)
    # accessors start
    xscale = null       # x-axis scale
    yscale = null       # y-axis scale
    markerSelect = null # marker segment selection
    martip = null       # marker tool tip selection
    svg = null          # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # {chr, pos, marker, (optionally) chrname}

        # args that are lists: check that they have all the pieces
        xlineOpts = d3panels.check_listarg_v_default(xlineOpts, {color:"#cdcdcd", width:5})

        d3panels.displayError("mapchart: data.chr is missing") unless data.chr?
        d3panels.displayError("mapchart: data.pos is missing") unless data.pos?
        d3panels.displayError("mapchart: data.marker is missing") unless data.marker?

        n_pos = data.pos.length
        if(data.chr.length != n_pos)
            d3panels.displayError("mapchart: data.chr.length (#{data.chr.length}) != data.pos.length (#{n_pos})")
        if(data.marker.length != n_pos)
            d3panels.displayError("mapchart: data.marker.length (#{data.marker.length}) != data.pos.length (#{n_pos})")

        unless data.chrname?
            data.chrname = d3panels.unique(data.chr)
        data.chrname = d3panels.forceAsArray(data.chrname)

        data.adjpos = data.pos.slice(0)
        # shift positions so that each chromosome starts at 0
        if shiftStart
            for chr in data.chrname
                these_pos = (data.pos[i] for i of data.pos when data.chr[i] == chr)
                these_index = (i for i of data.pos when data.chr[i] == chr)
                minpos = d3.min(these_pos)
                these_pos = (x-minpos for x in these_pos)
                for j of these_pos
                    data.adjpos[these_index[j]] = these_pos[j]
        # hereafter: data.adjpos is location to be plotted
        #            data.pos remains the real position

        # find min and max position on each chromosome
        extentByChr = {}
        for chr in data.chrname
            pos = (data.adjpos[i] for i of data.adjpos when data.chr[i] == chr)
            extentByChr[chr] = d3.extent(pos)

        ylim = ylim ? d3.extent(data.adjpos)
        n_chr = data.chrname.length
        xlim = [0.5, n_chr+0.5]
        xticks = (i+1 for i in d3.range(n_chr))
        xticklab = data.chrname

        chartOpts.xNA = false # don't allow NA boxes
        chartOpts.yNA = false
        if horizontal
            chartOpts.xlim = ylim
            chartOpts.ylim = xlim.reverse()
            chartOpts.xlineOpts = chartOpts.ylineOpts
            chartOpts.ylineOpts = xlineOpts
            chartOpts.xlab = ylab
            chartOpts.ylab = xlab
            chartOpts.xticks = chartOpts.yticks
            chartOpts.yticks = xticks
            chartOpts.nxticks = chartOpts.nyticks
            chartOpts.xticklab = chartOpts.yticklab
            chartOpts.yticklab = xticklab
            chartOpts.v_over_h = v_over_h
        else
            chartOpts.xlim = xlim
            chartOpts.ylim = ylim.reverse()
            chartOpts.xlineOpts = xlineOpts
            chartOpts.xlab = xlab
            chartOpts.ylab = ylab
            chartOpts.xticks = xticks
            chartOpts.xticklab = xticklab
            chartOpts.v_over_h = v_over_h

        # set up frame
        myframe = d3panels.panelframe(chartOpts)

        # Create SVG
        myframe(selection)
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        chrscale = (chr) ->
            chrpos = data.chrname.indexOf(chr) + 1
            return xscale(chrpos) unless horizontal
            yscale(chrpos)

        # vertical lines for each chromosome
        svg.append("g").attr("id", "chromosomes").selectAll("empty")
           .data(data.chrname)
           .enter()
           .append("line")
           .attr("x1", (d) ->
               return xscale(extentByChr[d][0]) if horizontal
               chrscale(d))
           .attr("x2", (d) ->
               return xscale(extentByChr[d][1]) if horizontal
               chrscale(d))
           .attr("y1", (d) ->
               return chrscale(d) if horizontal
               yscale(extentByChr[d][0]))
           .attr("y2", (d) ->
               return chrscale(d) if horizontal
               yscale(extentByChr[d][1]))
           .attr("fill", "none")
           .attr("stroke", linecolor)
           .attr("stroke-width", linewidth)
           .attr("shape-rendering", "crispEdges")
           .style("pointer-events", "none")


        # hash with rounded marker positions
        markerpos = {}
        for i of data.marker
            markerpos[data.marker[i]] = d3.format(".1f")(data.pos[i])

        markers = svg.append("g").attr("id", "points")
        markerSelect =
            markers.selectAll("empty")
                   .data(data.marker)
                   .enter()
                   .append("line")
                   .attr("x1", (d,i) ->
                       return xscale(data.adjpos[i]) if horizontal
                       chrscale(data.chr[i]) - tickwidth)
                   .attr("x2", (d,i) ->
                       return xscale(data.adjpos[i]) if horizontal
                       chrscale(data.chr[i]) + tickwidth)
                   .attr("y1", (d,i) ->
                       return chrscale(data.chr[i]) - tickwidth if horizontal
                       yscale(data.adjpos[i]))
                   .attr("y2", (d,i) ->
                       return chrscale(data.chr[i]) + tickwidth if horizontal
                       yscale(data.adjpos[i]))
                   .attr("id", (d) -> d)
                   .attr("fill", "none")
                   .attr("stroke", linecolor)
                   .attr("stroke-width", linewidth)
                   .attr("shape-rendering", "crispEdges")
                   .on "mouseover.paneltip", (d) ->
                                                 d3.select(this).attr("stroke", linecolorhilit)
                                                 martip.show(d)
                   .on "mouseout.paneltip", () ->
                                                 d3.select(this).attr("stroke", linecolor)
                                                 martip.hide()


        direction = if horizontal then "north" else "east"
        martip = d3panels.tooltip_create(d3.select("body"), markers, {direction:direction,tipclass:tipclass}, (d,i) -> "#{i} (#{markerpos[i]})")

        # move box to front
        myframe.box().raise()

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.markerSelect = () -> markerSelect
    chart.martip = () -> martip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      d3panels.tooltip_destroy(martip)
                      return null

    # return the chart function
    chart
