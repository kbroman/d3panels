# mapchart: reuseable marker map plot

mapchart = (chartOpts) ->
    chartOpts = {} unless chartOpts?

    # chartOpts start
    tickwidth = chartOpts?.tickwidth ? 10                 # width of ticks at markers
    linecolor = chartOpts?.linecolor ? "slateblue"        # line color
    linecolorhilit = chartopts?.linecolorhilit ? "Orchid" # line color when highlighted
    linewidth = chartOpts?.linewidth ? 3                  # line width (pixels)
    xlab = chartOpts?.xlab ? "Chromosome" # x-axis label
    ylab = chartOpts?.ylab ? "Position (cM)" # y-axis label
    xlineOpts = chartOpts?.xlineOpts ? {color:"#cdcdcd", width:5} # color and width of vertical lines
    horizontal = chartOpts?.horizontal ? false # whether chromosomes should be laid at horizontally
    v_over_h = chartOpts?.v_over_h ? horizontal # whether vertical lines should be on top of horizontal lines
    shiftStart = chartOpts?.shiftStart ? false  # if true, shift start of chromosomes to 0
    tipclass = chartOpts?.tipclass ? "pointtip" # class name for tool tips
    # chartOpts end
    xscale = null
    yscale = null
    markerSelect = null
    svg = null
    martip = null

    ## the main function
    chart = (selection, data) -> # {chr, pos, marker, (optionally) chrname}

        n_pos = data.pos.length
        if(data.chr.length != n_pos)
            displayError("data.chr.length (#{data.chr.length}) != data.pos.length (#{n_pos})")
        if(data.marker.length != n_pos)
            displayError("data.marker.length (#{data.marker.length}) != data.pos.length (#{n_pos})")

        unless data.chrname?
            data.chrname = unique(data.chr)

        data.adjpos = data.pos.slice(0)
        if shiftStart # shift positions so that each chromosome starts at 0
            for chr in data.chrname
                these_pos = (data.pos[i] for i of data.pos when data.chr[i] == chr)
                these_index = (i for i of data.pos when data.chr[i] == chr)
                minpos = d3.min(these_pos)
                these_pos = (x-minpos for x in these_pos)
                for j of these_pos
                    data.adjpos[these_index[j]] = these_pos[j]

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

        chartOpts.xNA = false
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
        myframe = panelframe(chartOpts)

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
           .style("pointer-events", "none")


        # hash with rounded marker positions
        markerpos = {}
        for i of data.marker
            markerpos[data.marker[i]] = d3.format(".1f")(data.pos[i])

        martip = d3.tip()
                   .attr('class', "d3-tip #{tipclass}")
                   .html((d) -> "#{d} (#{markerpos[d]})")
                   .direction('e')
                   .offset([0,10])
        svg.call(martip)

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
                   .on "mouseover.paneltip", (d) ->
                                                 d3.select(this).attr("stroke", linecolorhilit)
                                                 martip.show(d)
                   .on "mouseout.paneltip", () ->
                                                 d3.select(this).attr("stroke", linecolor)
                                                 martip.hide()

    # functions to grab stuff
    chart.yscale = () -> yscale
    chart.xscale = () -> xscale
    chart.markerSelect = () -> markerSelect
    chart.svg = () -> svg
    chart.martip = () -> martip

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      martip.destroy()
                      return null

    # return the chart function
    chart
