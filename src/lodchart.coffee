# lodchart: reuseable LOD score chart

lodchart = (chartOpts) ->

    # chartOpts start
    linecolor = chartOpts?.linecolor ? "darkslateblue" # color for LOD curves
    linewidth = chartOpts?.linewidth ? 2               # width (pixels) for LOD curves
    pointcolor = chartOpts?.pointcolor ? "#e9cfec"     # color of points at markers
    pointsize = chartOpts?.pointsize ? 0               # pointsize at markers (if 0, no points plotted)
    pointstroke = chartOpts?.pointstroke ? "black"     # color of circle around points at markers
    ylim = chartOpts?.ylim ? null # y-axis limits; if null, use range of data
    tipclass = chartOpts?.tipclass ? "pointtip" # class name for tool tips
    # chartOpts end
    yscale = null
    xscale = null
    ylines = null
    ylabels = null
    chrSelect = null
    markerSelect = null
    markertip = null
    svg = null

    ## the main function
    chart = (selection, data) -> # data = {chr, pos, lod, marker} each an ordered vector
                                 #    optionally also chrname, chrstart, chrend with chr IDs, start and end positions

        # check lengths
        if(data.pos.length != data.chr.length)
            displayError("data.pos.length (#{data.pos.length}) != data.chr.length (#{data.chr.length})")
        if(data.lod.length != data.chr.length)
            displayError("data.lod.length (#{data.lod.length}) != data.chr.length (#{data.chr.length})")
        if(data.marker.length != data.chr.length)
            displayError("data.marker.length (#{data.lod.length}) != data.chr.length (#{data.chr.length})")

        # create chrname, chrstart, chrend if missing
        data.chrname = unique(data.chr) unless data?.chrname?
        unless data?.chrstart
            data.chrstart = []
            for c in data.chrname
                these_pos = (data.pos[i] for i of data.chr when data.chr[i] == c)
                data.chrstart.push(d3.min(these_pos))
        unless data?.chrend
            data.chrend = []
            for c in data.chrname
                these_pos = (data.pos[i] for i of data.chr when data.chr[i] == c)
                data.chrend.push(d3.max(these_pos))

        # organize positions and LOD scores by chromosomes
        data = reorgLodData(data)

        # y-axis limits
        chartOpts.ylim = ylim ? [0, d3.max(data.lod)*1.05]

        # set up frame
        myframe = lodpanelframe(chartOpts)

        # Create SVG
        myframe(selection, {chr:data.chrname,start:data.chrstart,end:data.chrend})
        svg = myframe.svg()

        # grab scale functions
        xscale = myframe.xscale()
        yscale = myframe.yscale()

        # chromosome rectangles
        chrSelect = myframe.chrSelect()

        # lod curves by chr
        lodcurve = (chr) ->
                d3.svg.line()
                  .x((d) -> xscale[chr](d))
                  .y((d,i) -> yscale(data.lodByChr[chr][i]))

        curves = svg.append("g").attr("id", "curves")

        for chr in data.chrname
            curves.append("path")
                  .datum(data.posByChr[chr])
                  .attr("d", lodcurve(chr))
                  .attr("stroke", linecolor)
                  .attr("fill", "none")
                  .attr("stroke-width", linewidth)
                  .style("pointer-events", "none")

        # points at markers
        if pointsize > 0
            markerpoints = svg.append("g").attr("id", "markerpoints_visible")
            markerpoints.selectAll("empty")
                        .data(data.markerinfo)
                        .enter()
                        .append("circle")
                        .attr("cx", (d) -> xscale[d.chr](d.pos))
                        .attr("cy", (d) -> yscale(d.lod))
                        .attr("r", (d) -> if d.lod? then pointsize else null)
                        .attr("fill", pointcolor)
                        .attr("stroke", pointstroke)
                        .attr("pointer-events", "hidden")

        # these hidden points are what get selected...a bit larger
        hiddenpoints = svg.append("g").attr("id", "markerpoints_hidden")

        markertip = d3.tip()
                      .attr('class', "d3-tip #{tipclass}")
                      .html((d) ->
                                 [d.name, " LOD = #{d3.format('.2f')(d.lod)}"])
                      .direction("e")
                      .offset([0,10])
        svg.call(markertip)

        bigpointsize = d3.max([2*pointsize, 3])

        markerSelect =
            hiddenpoints.selectAll("empty")
                        .data(data.markerinfo)
                        .enter()
                        .append("circle")
                        .attr("cx", (d) -> xscale[d.chr](d.pos))
                        .attr("cy", (d) -> yscale(d.lod))
                        .attr("id", (d) -> d.name)
                        .attr("r", (d) -> if d.lod? then bigpointsize else null)
                        .attr("opacity", 0)
                        .attr("fill", pointcolor)
                        .attr("stroke", pointstroke)
                        .attr("stroke-width", "1")
                        .on "mouseover.paneltip", (d) ->
                                                       d3.select(this).attr("opacity", 1)
                                                       markertip.show(d)
                        .on "mouseout.paneltip", ->
                                                       d3.select(this).attr("opacity", 0)
                                                                      .call(markertip.hide)
    # functions to grab stuff
    chart.yscale = () -> yscale
    chart.xscale = () -> xscale
    chart.markerSelect = () -> markerSelect
    chart.chrSelect = () -> chrSelect
    chart.svg = () -> svg
    chart.markertip = () -> indtip

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      markertip.destroy()
                      return null

    # return the chart function
    chart
