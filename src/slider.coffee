# d3-based slider
d3panels.slider = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800                                          # total width of svg for slider
    height = chartOpts?.height ? 80                                         # total height of svg for slider
    margin = chartOpts?.margin ? {left:25, right:25, inner:0, top:40, bottom:40} # margins
    rectheight = chartOpts?.rectheight ? 10                                 # height of slider scale
    rectcolor = chartOpts?.rectcolor ? "#ccc"                               # color of slider scale
    buttonsize = chartOpts?.buttonsize ? rectheight*2                       # size of button
    buttoncolor = chartOpts?.buttoncolor ? "#eee"                           # color of button
    buttonstroke = chartOpts?.buttonstroke ? "black"                        # color of button border
    buttonround = chartOpts?.buttonround ? buttonsize*0.2                   # how much to round the button corners
    buttondotcolor = chartOpts?.buttondotcolor ? "slateblue"                # color of dot on button
    buttondotsize = chartOpts?.buttondotsize ? buttonsize/4                 # radius of dot on button
    tickheight = chartOpts?.tickheight ? 10                                 # height of ticks
    tickgap = chartOpts?.tickgap ? tickheight/2                             # gap below ticks
    textsize = chartOpts?.textsize ? 14                                     # font size for axis labels
    nticks = chartOpts?.nticks ? 5                                          # number of ticks
    ticks = chartOpts?.ticks ? null                                         # vector of ticks
    # chartOpts end
    # accessors start
    value = 0 # current value of slider
    stopindex = 0 # index of currently selected stop value
    # accessors end
    slider_svg = null

    chart = (selection, callback, range, stops, initial_value) ->

        margin.left += margin.inner
        margin.right += margin.inner

        range = [margin.left, width-margin.right] unless range?

        if margin.top? and margin.top+margin.bottom>0
            margin.top = height * margin.top / (margin.top+margin.bottom)
        else
            margin.top = height/2

        if initial_value? # initial value provided
            value = initial_value
            value = range[0] if value < range[0]
            value = range[1] if value > range[1]
            stopindex = d3panels.index_of_nearest(value, stops) if stops?
            value = stops[stopindex] if stops?
        else # choose random values
            if stops? # stops included; pick random stop index
                stopindex = Math.floor( Math.random() * stops.length )
                value = stops[stopindex]
            else
                value = (range[1]-range[0])*Math.random() + range[0]

        slider_svg = selection.insert("svg")
                              .attr("height", height)
                              .attr("width", width)

        # fully continuous x scale
        xcscale = d3.scaleLinear()
                    .range([margin.left, width-margin.right])
                    .domain(range)
                    .clamp(true)

        # xscale that handles stop positions
        xscale = (d) ->
            return xcscale(stops[d3panels.index_of_nearest(d, stops)]) if stops?
            xcscale(d)

        # clamp pixels values to range of slider
        clamp_pixels = (pixels, interval) ->
            return interval[0] if pixels < interval[0]
            return interval[1] if pixels > interval[1]
            pixels

        # insert bar
        slider_svg.insert("rect")
                  .attr("x", margin.left)
                  .attr("y", margin.top - rectheight/2)
                  .attr("rx", rectheight*0.3)
                  .attr("ry", rectheight*0.3)
                  .attr("width", width-margin.left-margin.right)
                  .attr("height", rectheight)
                  .attr("fill", rectcolor)

        # add scale
        ticks = xcscale.ticks(nticks) unless ticks?
        slider_svg.selectAll("empty")
                  .data(ticks)
                  .enter()
                  .insert("line")
                  .attr("x1", (d) -> xcscale(d))
                  .attr("x2", (d) -> xcscale(d))
                  .attr("y1", margin.top + rectheight/2 + tickgap)
                  .attr("y2", margin.top + rectheight/2 + tickgap + tickheight)
                  .attr("stroke", "black")
                  .attr("shape-rendering", "crispEdges")
        slider_svg.selectAll("empty")
                  .data(ticks)
                  .enter()
                  .insert("text")
                  .attr("x", (d) -> xcscale(d))
                  .attr("y", margin.top + rectheight/2 + tickgap*2+tickheight)
                  .text((d) -> d)
                  .style("font-size", textsize)
                  .style("dominant-baseline", "hanging")
                  .style("text-anchor", "middle")
                  .style("pointer-events", "none")
                  .style("-webkit-user-select", "none")
                  .style("-moz-user-select", "none")
                  .style("-ms-user-select", "none")


        # add button
        button = slider_svg.insert("g").attr("id", "button")
                           .attr("transform", "translate(" + xscale(value) + ",0)")
        button.insert("rect")
              .attr("x", -buttonsize/2)
              .attr("y", margin.top - buttonsize/2)
              .attr("height", buttonsize)
              .attr("width", buttonsize)
              .attr("rx", buttonround)
              .attr("ry", buttonround)
              .attr("stroke", buttonstroke)
              .attr("stroke-width", 2)
              .attr("fill", buttoncolor)

        button.insert("circle")
              .attr("cx", 0)
              .attr("cy", margin.top)
              .attr("r", buttondotsize)
              .attr("fill", buttondotcolor)


        # function to deal with dragging
        dragged = (d) ->
            pixel_value = d3.event.x
            clamped_pixels = clamp_pixels(pixel_value, [margin.left, width-margin.right])
            value = xcscale.invert(clamped_pixels)
            d3.select(this).attr("transform", "translate(" + xcscale(value) + ",0)")
            if stops?
                stopindex = d3panels.index_of_nearest(value, stops)
                value = stops[stopindex]
            callback(chart) if callback?

        # function at end of dragging:
        end_drag = (d) ->
            pixel_value = d3.event.x
            clamped_pixels = clamp_pixels(pixel_value, [margin.left, width-margin.right])
            value = xcscale.invert(clamped_pixels)
            if stops?
                stopindex = d3panels.index_of_nearest(value, stops)
                value = stops[stopindex]
            callback(chart) if callback?
            d3.select(this).attr("transform", "translate(" + xcscale(value) + ",0)")

        # start the dragging
        button.call(d3.drag().on("drag", dragged).on("end", end_drag))

        # run the callback at the beginning
        callback(chart) if callback?

    # functions to grab stuff
    chart.value = () -> value
    chart.stopindex = () -> stopindex

    # function to remove the slider
    chart.remove = () ->
        slider_svg.remove()

    # return the chart function
    chart
