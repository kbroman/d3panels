# trichart: plot scatter of points, y versus x

# (x,y,z) -> ((x*2+y)/sqrt(3), y)
# xlim: [0, 2/sqrt(3)]
# ylim: [0, 1]


d3panels.trichart = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800                      # overall width of chart in pixels
    height = chartOpts?.height ? 800                    # overall height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:3} # margins in pixels (left, top, right, bottom, inner)
    labelpos = chartOpts?.labelpos ? 5                  # pixels between vertex and vertex label
    titlepos = chartOpts?.titlepos ? 20                 # position of chart title in pixels
    title = chartOpts?.title ? ""                       # chart title
    labels = chartOpts?.labels ? ["(1,0,0)", "(0,1,0)", "(0,0,1)"] # labels on the corners
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"        # color of background rectangle
    boxcolor = chartOpts?.boxcolor ? "black"            # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 2                  # width of outer box in pixels
    pointcolor = chartOpts?.pointcolor ? null           # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black"      # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3                # color of points
    tipclass = chartOpts?.tipclass ? "tooltip"          # class name for tool tips
    # chartOpts end
    # further chartOpts: panelframe
    # accessors start
    xscale = null # x-axis scale
    yscale = null # y-axis scale
    points = null # points selection
    indtip = null # tooltip selection
    svg = null    # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # data = {p, indID, group}
                                 # p = [[p00, p01, p02], [p10, p11, p12], ...]

        d3panels.displayError("trichart: data.p is missing") unless data.p?

        # missing values can be any of null, "NA", or ""; replacing with nulls
        p = (d3panels.missing2null(v) for v in data.p)

        # convert points to (x,y)
        flag_length_not_3 = false
        flag_sum_not_1 = false
        flag_out_of_range = false
        for v in p
            flag_length_not_3 = true if v.length != 3
            sum = d3panels.sumArray(v)
            v /= sum
            flag_sum_not_1 if d3panels.abs(sum - 1) > 1e-6
            for val in v
                val /= sum
                flag_out_of_range = true if val < 0 or val > 1

        d3panels.displayError("trichart: points not all of length 3") if flag_length_not_3
        d3panels.displayError("trichart: points not all summing to 1") if flag_sum_not_1
        d3panels.displayError("trichart: points not all in [0,1]") if flag_out_of_range



        n = p.length
        indID = data?.indID ? (i+1 for i of p)
        group = data?.group ? (1 for i of p)
        if(indID.length != n)
            d3panels.displayError("trichart: data.indID.length (#{indID.length}) != data.p.length (#{n})")
        if(group.length != n)
            d3panels.displayError("trichart: data.group.length (#{group.length}) != data.p.length (#{n})")

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
        xscale = d3.scale.linear()
                         .domain(xlim)
                         .range([margin.left, margin.left + plot_width])
        yscale = d3.scale.linear()
                         .domain(ylim)
                         .range([plot_height + margin.top, margin.top])

        # convert points to (x,y)
        xy = ({x:(v[0]*2.0 + v[1])/Math.sqrt(3.0), y:v[1]} for v in p)

        # Create SVG
        svg = selection.append("svg")

        # Update the dimensions
        svg.attr("width", width)
           .attr("height", height)
           .attr("class", "d3panels")

        # draw triangle
        svg.append("g").attr("id", "frame")
        vertices = [{x:xlim[0],   y:ylim[0]},
                    {x:xlim[1]/2, y:ylim[1]},
                    {x:xlim[1],   y:ylim[0]}]
        path = [0,1,2,0]

        # add title


        # add labels

        # add points


    # functions to grab stuff
    chart.xscale = () -> xscale
    chart.yscale = () -> yscale
    chart.points = () -> points
    chart.indtip = () -> indtip
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      indtip.destroy()
                      null

    # return the chart function
    chart
