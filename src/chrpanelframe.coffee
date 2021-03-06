# chrpanelframe: create a frame for a lod curve plot (rectangle + axes + labels)

d3panels.chrpanelframe = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800                     # overall height of chart in pixels
    height = chartOpts?.height ? 500                   # overall width of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40}      # margins in pixels (left, top, right, bottom)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:45, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20                # position of chart title in pixels
    title = chartOpts?.title ? ""                      # chart title
    xlab = chartOpts?.xlab ? null                      # x-axis label
    ylab = chartOpts?.ylab ? "LOD score"               # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? null        # whether to rotate the y-axis label
    ylim = chartOpts?.ylim ? [0,1]                     # y-axis limits
    nyticks = chartOpts?.nyticks ? 5                   # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null                  # vector of tick positions on y-axis
    yticklab = chartOpts?.yticklab ? null              # vector of y-axis tick labels
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"       # color of background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#d4d4d4" # color of background rectangle for alternate chromosomes (if "", not created)
    chrlinecolor = chartOpts?.chrlinecolor ? ""        # color of lines between chromosomes (if "", leave off)
    chrlinewidth = chartOpts?.chrlinewidth ? 2         # width of lines between chromosomes
    boxcolor = chartOpts?.boxcolor ? "black"           # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 2                 # width of outer box in pixels
    xlineOpts = chartOpts?.xlineOpts ? {color:"#d4d4d4", width:2} # color and width of vertical lines (if one chromosome)
    ylineOpts = chartOpts?.ylineOpts ? {color:"white", width:2} # color and width of horizontal lines
    chrGap = chartOpts?.chrGap ? 6                     # gap between chromosomes in pixels
    horizontal = chartOpts.horizontal ? false          # if true, chromosomes on vertical axis (xlab, ylab, etc stay the same)
    # chartOpts end
    # accessors start
    xscale = null     # x-axis scale (vector by chromosome)
    yscale = null     # y-axis scale
    xlabels = null    # x-axis labels selection
    ylabels = null    # y-axis labels selection
    chrSelect = null  # chromosome rectangle selection
    chrlines = null   # chromosome lines selection
    box = null        # outer box selection
    svg = null        # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = chr, start, end  (vectors with chromosome IDs, start positions, and end positions)

        # args that are lists: check that they have all the pieces
        margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 60})
        axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:45, xlabel:5, ylabel:5})
        xlineOpts = d3panels.check_listarg_v_default(xlineOpts, {color:"white", width:2})
        ylineOpts = d3panels.check_listarg_v_default(ylineOpts, {color:"white", width:2})

        d3panels.displayError("chrpanelframe: data.chr is missing") unless data.chr?
        d3panels.displayError("chrpanelframe: data.end is missing") unless data.end?

        unless xlab? # "Chromosome" or "Position" depending on whether >1 or ==1 chr
            xlab = if data.chr.length==1 then "Position" else "Chromosome"

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
            d3panels.displayError("chrpanelframe: data.start.length (#{data.start.length}) != data.chr.length (#{data.chr.length})")
        if(data.chr.length != data.end.length)
            d3panels.displayError("chrpanelframe: data.end.length (#{data.end.length}) != data.chr.length (#{data.chr.length})")

        # scales (x-axis scale has by chromosome ID)
        if horizontal # when horizontal, vertical is x-axis and horizontal is y-axis
            xscale = d3panels.calc_chrscales(plot_height, margin.top, chrGap, data.chr, data.start, data.end)
            yscale = d3.scaleLinear().domain(ylim.reverse()).range([plot_width + margin.left, margin.left])
        else
            xscale = d3panels.calc_chrscales(plot_width, margin.left, chrGap, data.chr, data.start, data.end)
            yscale = d3.scaleLinear().domain(ylim).range([plot_height + margin.top, margin.top])

        # solid background
        g.append("rect")
         .attr("x", margin.left)
         .attr("width", plot_width)
         .attr("y", margin.top)
         .attr("height", plot_height)
         .attr("fill", rectcolor)
         .attr("shape-rendering", "crispEdges")

        # background rectangles, alternating colors
        if altrectcolor != ""
            chrSelect = g.append("g")
                         .selectAll("empty")
                         .data(data.chr)
                         .enter()
                         .append("rect")
                         .attr("x", (d,i) ->
                             return margin.left if horizontal
                             xscale[d](data.start[i])-chrGap/2)
                         .attr("width", (d,i) ->
                             return plot_width if horizontal
                             xscale[d](data.end[i]) - xscale[d](data.start[i]) + chrGap)
                         .attr("y", (d,i) ->
                             return xscale[d](data.start[i])-chrGap/2 if horizontal
                             margin.top)
                         .attr("height", (d,i) ->
                             return xscale[d](data.end[i]) - xscale[d](data.start[i]) + chrGap if horizontal
                             plot_height)
                         .attr("fill", (d,i) ->
                             return rectcolor if i % 2 == 0
                             altrectcolor)
                         .attr("shape-rendering", "crispEdges")

        # add title
        g.append("g").attr("class", "title")
         .append("text")
         .text(title)
         .attr("x", (width-margin.left-margin.right)/2 + margin.left)
         .attr("y", titlepos)

        # rotate y-axis title?
        if horizontal
            rotate_ylab = rotate_ylab ? (xlab.length > 1)
        else
            rotate_ylab = rotate_ylab ? (ylab.length > 1)

        xaxis = g.append("g").attr("class", () ->
                                return "y axis" if horizontal
                                "x axis")
        yaxis = g.append("g").attr("class", () ->
                                return "x axis" if horizontal
                                "y axis")

        xaxis.append("text").attr("class", "title")
             .text(() ->
                return ylab if horizontal
                xlab)
             .attr("x", (width-margin.left-margin.right)/2 + margin.left)
             .attr("y", plot_height + margin.top + axispos.xtitle)

        ylabpos_y = (height-margin.top-margin.bottom)/2 + margin.top
        ylabpos_x = margin.left - axispos.ytitle
        yaxis.append("text").attr("class", "title")
             .text(() ->
                return xlab if horizontal
                ylab)
             .attr("y", ylabpos_y)
             .attr("x", ylabpos_x)
             .attr("transform", if rotate_ylab then "rotate(270,#{ylabpos_x},#{ylabpos_y})" else "")

        # axis labels
        if data.chr.length > 1
            xlabels = xaxis.append("g").attr("id", "xlabels")
                       .selectAll("empty")
                       .data(data.chr)
                       .enter()
                       .append("text")
                       .attr("x", (d,i) ->
                            return margin.left - axispos.ylabel if horizontal
                            (xscale[d](data.start[i]) + xscale[d](data.end[i]))/2)
                       .attr("y", (d,i) ->
                            return (xscale[d](data.start[i]) + xscale[d](data.end[i]))/2 if horizontal
                            height - margin.bottom + axispos.xlabel)
                       .text((d) -> d)
        else
            thechr = data.chr[0]
            xticks = xscale[thechr].ticks(5)
            xlabels = xaxis.append("g").attr("id", "xlabels")
                       .selectAll("empty")
                       .data(xticks)
                       .enter()
                       .append("text")
                       .attr("x", (d) ->
                            return margin.left - axispos.ylabel if horizontal
                            xscale[thechr](d))
                       .attr("y", (d,i) ->
                            return xscale[thechr](d) if horizontal
                            height - margin.bottom + axispos.xlabel)
                       .text((d) -> d)

            # vertical grid lines
            xlines = xaxis.append("g").attr("id", "xlines")
                      .selectAll("empty")
                      .data(xticks)
                      .enter()
                      .append("line")
                      .attr("x1", (d) ->
                              return margin.left if horizontal
                              xscale[thechr](d))
                      .attr("x2", (d) ->
                              return margin.left+plot_width if horizontal
                              xscale[thechr](d))
                      .attr("y1", (d,i) ->
                              return xscale[thechr](d) if horizontal
                              margin.top)
                      .attr("y2", (d,i) ->
                              return xscale[thechr](d) if horizontal
                              plot_height + margin.top)
                      .attr("fill", "none")
                      .attr("stroke", xlineOpts.color)
                      .attr("stroke-width", xlineOpts.width)
                      .attr("shape-rendering", "crispEdges")
                      .style("pointer-events", "none")

        # add Y axis values + ylines
        # if yticks not provided, use nyticks to choose pretty ones
        yticks = yticks ? yscale.ticks(nyticks)
        if yticklab? and yticklab.length != yticks.length
            displayError("chrpanelframe: yticklab.length (#{yticklab.length}) != yticks.length (#{yticks.length})")
        unless yticklab? and yticklab.length == yticks.length
            yticklab = (d3panels.formatAxis(yticks)(d) for d in yticks)

        # horizontal grid lines
        ylines = yaxis.append("g").attr("id", "ylines")
                  .selectAll("empty")
                  .data(yticks.concat(yticks))
                  .enter()
                  .append("line")
                  .attr("y1", (d) ->
                          return margin.top if horizontal
                          yscale(d))
                  .attr("y2", (d) ->
                          return margin.top+plot_height if horizontal
                          yscale(d))
                  .attr("x1", (d,i) ->
                          return yscale(d) if horizontal
                          margin.left)
                  .attr("x2", (d,i) ->
                          return yscale(d) if horizontal
                          plot_width + margin.left)
                  .attr("fill", "none")
                  .attr("stroke", ylineOpts.color)
                  .attr("stroke-width", ylineOpts.width)
                  .attr("shape-rendering", "crispEdges")
                  .style("pointer-events", "none")

        ylabels = yaxis.append("g").attr("id", "ylabels")
                   .selectAll("empty")
                   .data(yticklab)
                   .enter()
                   .append("text")
                   .attr("y", (d,i) ->
                        return height - margin.bottom + axispos.xlabel if horizontal
                        yscale(yticks[i]))
                   .attr("x", (d,i) ->
                        return yscale(yticks[i]) if horizontal
                        margin.left - axispos.ylabel)
                   .text((d) -> d)

        # chrlines
        if chrlinecolor != "" and data.chr.length > 1
            chrlines = svg.append("g").attr("id", "chrlines")
            chrlines.selectAll("empty")
             .data(data.chr[0..(data.chr.length - 2)])
             .enter()
             .append("line")
             .attr("x1", (d,i) ->
                 return margin.left if horizontal
                 xscale[d](data.end[i])+chrGap/2)
             .attr("x2", (d,i) ->
                 return margin.left + plot_width if horizontal
                 xscale[d](data.end[i])+chrGap/2)
             .attr("y1", (d,i) ->
                 return xscale[d](data.end[i])+chrGap/2 if horizontal
                 margin.top)
             .attr("y2", (d,i) ->
                 return xscale[d](data.end[i])+chrGap/2 if horizontal
                 margin.top + plot_height)
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
