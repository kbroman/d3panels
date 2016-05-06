# chr2dpanelframe: create a frame for a 2d LOD heatmap

d3panels.chr2dpanelframe = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800 # overall height of chart in pixels
    height = chartOpts?.height ? 800 # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 60} # margins in pixels (left, top, right, bottom)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:45, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    title = chartOpts?.title ? "" # chart title
    xlab = chartOpts?.xlab ? "Chromosome"  # x-axis label
    ylab = chartOpts?.ylab ? "Chromosome"  # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? null # whether to rotate the y-axis label
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6" # color of background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#d4d4d4" # color of background rectangle for alternate chromosomes (if "", not created)
    chrlinecolor = chartOpts?.chrlinecolor ? "" # color of lines between chromosomes (if "", leave off)
    chrlinewidth = chartOpts?.chrlinewidth ? 2 # width of lines between chromosomes
    boxcolor = chartOpts?.boxcolor ? "black"     # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 2           # width of outer box in pixels
    chrGap = chartOpts?.chrGap ? 6 # gap between chromosomes in pixels
    oneAtTop = chartOpts?.oneAtTop ? false # if true, put chromosome 1 at the top rather than bottom
    # chartOpts end
    # accessors start
    xscale = null     # x-axis scale (vector by chromosome)
    yscale = null     # y-axis scale (vector by chromosome)
    xlabels = null    # x-axis labels selection
    ylabels = null    # y-axis labels selection
    chrSelect = null  # chromosome rectangle selection
    chrlines = null   # chromosome lines selection
    box = null        # outer box selection
    svg = null        # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = chr, start, end  (vectors with chromosome IDs, start positions, and end positions)
        # Create SVG
        svg = selection.append("svg")

        # Update the dimensions
        svg.attr("width", width)
           .attr("height", height)
           .attr("class", "d3panels")

        g = svg.append("g").attr("id", "frame")

        # placement of boxes according to whether NAs will be treated specially
        plot_width = width - (margin.left + margin.right)
        plot_height = height - (margin.top + margin.bottom)

        # if start missing, use 0
        data.start = (0 for c in data.chr) unless data?.start
        if(data.chr.length != data.start.length)
            d3panels.displayError("data.start.length (#{data.start.length}) != data.chr.length (#{data.chr.length})")
        if(data.chr.length != data.end.length)
            d3panels.displayError("data.end.length (#{data.end.length}) != data.chr.length (#{data.chr.length})")

        # scales
        xscale = d3panels.calc_chrscales(plot_width, margin.left, chrGap, data.chr, data.start, data.end)
        yscale = d3panels.calc_chrscales(plot_height, margin.top, chrGap, data.chr, data.start, data.end, !oneAtTop) # last arg is for reverse scale

        # solid background
        g.append("rect")
         .attr("x", margin.left)
         .attr("width", plot_width)
         .attr("y", margin.top)
         .attr("height", plot_height)
         .attr("fill", rectcolor)
         .attr("shape-rendering", "crispEdges")

        chrRect = []
        for chrx,x in data.chr
            for chry,y in data.chr
                chrRect.push({chrx:chrx, xi:x, chry:chry, yi:y, odd:(x+y)%2})

        # background rectangles, alternating colors
        if altrectcolor != ""
            chrSelect = g.append("g")
                         .selectAll("empty")
                         .data(chrRect)
                         .enter()
                         .append("rect")
                         .attr("x", (d) -> xscale[d.chrx](data.start[d.xi]) - chrGap/2)
                         .attr("width", (d) -> xscale[d.chrx](data.end[d.xi]) - xscale[d.chrx](data.start[d.xi]) + chrGap)
                         .attr("y", (d) ->
                             return yscale[d.chry](data.start[d.yi]) - chrGap/2 if oneAtTop
                             yscale[d.chry](data.end[d.yi]) - chrGap/2)
                         .attr("height", (d) ->
                             return yscale[d.chry](data.end[d.yi]) - yscale[d.chry](data.start[d.yi]) + chrGap if oneAtTop
                             yscale[d.chry](data.start[d.yi]) - yscale[d.chry](data.end[d.yi]) + chrGap)
                         .attr("fill", (d,i) ->
                             return rectcolor unless d.odd
                             altrectcolor)
                         .attr("shape-rendering", "crispEdges")

        # add title
        g.append("g").attr("class", "title")
         .append("text")
         .text(title)
         .attr("x", (width-margin.left-margin.right)/2 + margin.left)
         .attr("y", titlepos)

        # rotate y-axis title?
        rotate_ylab = rotate_ylab ? (ylab.length > 1)

        xaxis = g.append("g").attr("class", "x axis")
        yaxis = g.append("g").attr("class", "y axis")

        xaxis.append("text").attr("class", "title")
             .text(() -> xlab)
             .attr("x", (width-margin.left-margin.right)/2 + margin.left)
             .attr("y", plot_height + margin.top + axispos.xtitle)
        ylabpos_y = (height-margin.top-margin.bottom)/2 + margin.top
        ylabpos_x = margin.left - axispos.ytitle
        yaxis.append("text").attr("class", "title")
             .text(() -> ylab)
             .attr("y", ylabpos_y)
             .attr("x", ylabpos_x)
             .attr("transform", if rotate_ylab then "rotate(270,#{ylabpos_x},#{ylabpos_y})" else "")

        # axis labels
        xlabels = xaxis.append("g").attr("id", "xlabels")
                   .selectAll("empty")
                   .data(data.chr)
                   .enter()
                   .append("text")
                   .attr("x", (d,i) -> (xscale[d](data.start[i]) + xscale[d](data.end[i]))/2)
                   .attr("y", height - margin.bottom + axispos.xlabel)
                   .text((d) -> d)
        ylabels = yaxis.append("g").attr("id", "ylabels")
                   .selectAll("empty")
                   .data(data.chr)
                   .enter()
                   .append("text")
                   .attr("y", (d,i) -> (yscale[d](data.start[i]) + yscale[d](data.end[i]))/2)
                   .attr("x", margin.left - axispos.ylabel)
                   .text((d) -> d)

        # chrlines
        if chrlinecolor != "" and data.chr.length > 1
            chrlines = svg.append("g").attr("id", "chrlines")
            chrlines.selectAll("empty")
             .data(data.chr[0..(data.chr.length - 2)])
             .enter()
             .append("line")
             .attr("x1", (d,i) -> xscale[d](data.end[i])+chrGap/2)
             .attr("x2", (d,i) -> xscale[d](data.end[i])+chrGap/2)
             .attr("y1", margin.top)
             .attr("y2", margin.top + plot_height)
             .attr("stroke", chrlinecolor)
             .attr("stroke-width", chrlinewidth)
             .attr("shape-rendering", "crispEdges")
            chrlines.selectAll("empty")
             .data(data.chr[0..(data.chr.length - 2)])
             .enter()
             .append("line")
             .attr("y1", (d,i) ->
                 return yscale[d](data.end[i])+chrGap/2 if oneAtTop
                 yscale[d](data.end[i])-chrGap/2)
             .attr("y2", (d,i) ->
                 return yscale[d](data.end[i])+chrGap/2 if oneAtTop
                 yscale[d](data.end[i])-chrGap/2)
             .attr("x1", margin.left)
             .attr("x2", margin.left + plot_width)
             .attr("stroke", chrlinecolor)
             .attr("stroke-width", chrlinewidth)
             .attr("shape-rendering", "crispEdges")

        # background rectangle box
        box = svg.append("rect").attr("class", "box")
                 .attr("x", margin.left)
                 .attr("y", margin.top)
                 .attr("height", plot_height)
                 .attr("width", plot_width)
                 .attr("fill", "none")
                 .attr("stroke", boxcolor)
                 .attr("stroke-width", boxwidth)
                 .attr("shape-rendering", "crispEdges")

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.xlabels = () -> xlabels
    chart.ylabels = () -> ylabels
    chart.chrSelect = () -> chrSelect
    chart.chrlines = () -> chrlines
    chart.plot_width = () -> plot_width
    chart.plot_height = () -> plot_height
    chart.width = () -> width
    chart.height = () -> height
    chart.margin = () -> margin
    chart.box = () -> box
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      null

    # return the chart function
    chart
