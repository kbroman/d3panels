# add_lodcurve: add lod curve to a lodchart() chart

add_lodcurve = (chart, chartOpts, data) ->

    # chartOpts start
    linecolor = chartOpts?.linecolor ? "darkslateblue" # color for LOD curves
    linewidth = chartOpts?.linewidth ? 2               # width (pixels) for LOD curves
    pointcolor = chartOpts?.pointcolor ? "#e9cfec"     # color of points at markers
    pointsize = chartOpts?.pointsize ? 0               # pointsize at markers (if 0, no points plotted)
    pointstroke = chartOpts?.pointstroke ? "black"     # color of circle around points at markers
    tipclass = chartOpts?.tipclass ? "pointtip" # class name for tool tips
    # chartOpts end
    markerSelect = null
    markertip = null

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

    svg = chart.svg()

    # grab scale functions
    xscale = chart.xscale()
    yscale = chart.yscale()

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
