# trichart: plot scatter of points, y versus x

# (x,y,z) -> ((x*2+y)/sqrt(3), y)
# xlim: [0, 2/sqrt(3)]
# ylim: [0, 1]


d3panels.trichart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 600                      # overall width of chart in pixels
    height = chartOpts?.height ? 520                    # overall height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:60, bottom: 10} # margins in pixels (left, top, right, bottom)
    labelpos = chartOpts?.labelpos ? 10                 # pixels between vertex and vertex label (horizontally)
    titlepos = chartOpts?.titlepos ? 20                 # position of chart title in pixels
    title = chartOpts?.title ? ""                       # chart title
    labels = chartOpts?.labels ? ["(1,0,0)", "(0,1,0)", "(0,0,1)"] # labels on the corners
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"        # color of background rectangle
    boxcolor = chartOpts?.boxcolor ? "black"            # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 2                  # width of outer box in pixels
    pointcolor = chartOpts?.pointcolor ? null           # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black"      # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3                # color of points
    gridlines = chartOpts?.gridlines ? 0                # number of grid lines
    gridcolor = chartOpts?.gridcolor ? "white"          # color of grid lines
    gridwidth = chartOpts?.gridwidth ? 1                # width of grid lines in pixels
    tipclass = chartOpts?.tipclass ? "tooltip"          # class name for tool tips
    # chartOpts end
    # accessors start
    xscale = null # x-axis scale
    yscale = null # y-axis scale
    pscale = null # pt -> (x,y) in pixels
    points = null # points selection
    indtip = null # tooltip selection
    svg = null    # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = {p, indID, group}
                                 # p = [[p00, p01, p02], [p10, p11, p12], ...]

        # args that are lists: check that they have all the pieces
        margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:60, bottom: 10})

        d3panels.displayError("trichart: data.p is missing") unless data.p?

        # missing values can be any of null, "NA", or ""; replacing with nulls
        p = (d3panels.missing2null(v) for v in data.p)

        # check points
        flag_length_not_3 = false
        flag_sum_not_1 = false
        flag_out_of_range = false
        for v in p
            flag_length_not_3 = true if v.length != 3
            sum = d3panels.sumArray(v)
            flag_sum_not_1 if d3panels.abs(sum - 1) > 1e-6
            flag_out_of_range = true if d3panels.sumArray(vv < 0 or vv > 1 for vv in v) > 0
        d3panels.displayError("trichart: points not all of length 3") if flag_length_not_3
        d3panels.displayError("trichart: points not all summing to 1") if flag_sum_not_1
        d3panels.displayError("trichart: points not all in [0,1]") if flag_out_of_range

        n = p.length
        indID = data?.indID ? (+i + 1 for i of p)
        if(indID.length != n)
            d3panels.displayError("trichart: data.indID.length (#{indID.length}) != data.p.length (#{n})")

        # groups of colors
        group = data?.group ? (1 for i of p)
        ngroup = d3.max(group)
        group = ((if g? then g-1 else g) for g in group) # changed from (1,2,3,...) to (0,1,2,...)
        if d3panels.sumArray(g < 0 or g > ngroup-1 for g in group) > 0
            d3panels.displayError("add_points: group values out of range")
            console.log("ngroup: #{ngroup}")
            console.log("distinct groups: #{d3panels.unique(group)}")
        if(group.length != n)
            d3panels.displayError("trichart: data.group.length (#{group.length}) != data.p.length (#{n})")

        # colors of the points in the different groups
        pointcolor = pointcolor ? d3panels.selectGroupColors(ngroup, "dark")
        pointcolor = d3panels.expand2vector(pointcolor, ngroup)
        if pointcolor.length < ngroup
            d3panels.displayError("add_points: pointcolor.length (#{pointcolor.length}) < ngroup (#{ngroup})")

        xlim = [0, 2/Math.sqrt(3)]
        ylim = [0, 1]

        # calculate height and width to use
        plot_height = height - margin.top - margin.bottom
        plot_width = width - margin.left - margin.right
        if plot_height > plot_width/xlim[1]
            d = plot_height - plot_width/xlim[1]
            margin.top += d/2
            margin.bottom += d/2
            plot_height -= d
        else
            d = plot_width - plot_height * xlim[1]
            margin.left += d/2
            margin.right += d/2
            plot_width -= d

        # calculate scales
        xscale = d3.scaleLinear()
                         .domain(xlim)
                         .range([margin.left, margin.left + plot_width])
        yscale = d3.scaleLinear()
                         .domain(ylim)
                         .range([plot_height + margin.top, margin.top])
        pscale = (p) ->
            sum = d3panels.sumArray(p)
            {x:xscale((p[0]*2.0 + p[1])/Math.sqrt(3.0)/sum), y:yscale(p[1]/sum)}

        # convert points to (x,y)
        xy = ({x:(v[0]*2.0 + v[1])/Math.sqrt(3.0), y:v[1]} for v in p)

        # Create SVG
        svg = selection.append("svg")

        # Update the dimensions
        svg.attr("width", width)
           .attr("height", height)
           .attr("class", "d3panels")

        # draw triangle
        frame = svg.append("g").attr("id", "frame")
        vertices = [{x:xlim[0],   y:ylim[0]},
                    {x:xlim[1]/2, y:ylim[1]},
                    {x:xlim[1],   y:ylim[0]}]
        framefunc = d3.line()
                      .x((d) -> xscale(vertices[d].x))
                      .y((d) -> yscale(vertices[d].y))

        indices = (+i for i of vertices).concat(0)
        frame.append("path")
             .datum(indices)
             .attr("d", framefunc)
             .attr("fill", rectcolor)
             .attr("stroke", boxcolor)
             .attr("stroke-width", boxwidth)

        # add gridlines
        if gridlines > 0
            gr = [1..gridlines].map((i) -> i/(gridlines+1))
            p1 = gr.map( (x) -> [x, 0, 1-x])
            p2 = gr.map( (x) -> [x, 1-x, 0])
            p3 = gr.map( (x) -> [0, 1-x, x])
            p4 = gr.map( (x) -> [1-x, 0, x])
            first = p1.concat(p2).concat(p3)
            second = p2.concat(p3).concat(p4)

            g = frame.append("g").attr("class", "gridlines")
                     .selectAll("empty")
                     .data(first)
                     .enter()
                     .append("line")
                     .attr("x1", (d) -> pscale(d).x)
                     .attr("y1", (d) -> pscale(d).y)
                     .attr("x2", (d,i) -> pscale(second[i]).x)
                     .attr("y2", (d,i) -> pscale(second[i]).y)
                     .attr("stroke", gridcolor)
                     .attr("stroke-width", gridwidth)
                     .attr("shape-rendering", "crispEdges")
                     .style("pointer-events", "none")
                     .attr("fill", "none")

            # draw outer box again
            frame.append("path")
                 .datum(indices)
                 .attr("d", framefunc)
                 .attr("fill", "none")
                 .attr("stroke", boxcolor)
                 .attr("stroke-width", boxwidth)

        # add title
        frame.append("g").attr("class", "title")
             .append("text")
             .text(title)
             .attr("x", plot_width/2 + margin.left)
             .attr("y", margin.top - titlepos)

        # add labels
        frame.append("g").attr("id", "labels")
             .selectAll("empty")
             .data(vertices)
             .enter()
             .append("text")
             .attr("x", (d,i) -> xscale(d.x) + [-1,+1,+1][i]*labelpos)
             .attr("y", (d) -> yscale(d.y))
             .style("dominant-baseline", "middle")
             .style("text-anchor", (d,i) -> ["end", "start", "start"][i])
             .text((d,i) -> labels[i])

        # add points
        points = svg.append("g").attr("id", "points")
                    .selectAll("empty")
                    .data(p)
                    .enter()
                    .append("circle")
                    .attr("r", pointsize)
                    .attr("cx", (d) -> pscale(d).x)
                    .attr("cy", (d) -> pscale(d).y)
                    .attr("fill", (d,i) -> pointcolor[group[i]])
                    .attr("stroke", pointstroke)
                    .attr("stroke-width", 1)

        # individual tooltips
        indtip = d3panels.tooltip_create(d3.select("body"), points,
                                         {tipclass:tipclass},
                                         (d,i) -> indID[i])

    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.pscale = () -> pscale
    chart.points = () -> points
    chart.indtip = () -> indtip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      d3panels.tooltip_destroy(indtip)
                      null

    # return the chart function
    chart
