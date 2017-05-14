# a d3-based double-slider (or range slider)

d3panels.double_slider = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 800                                          # total width of svg for slider
    height = chartOpts?.height ? 80                                         # total height of svg for slider
    margin = chartOpts?.margin ? {left:25, right:25, inner:0, top:40, bottom:40} # margins
    rectheight = chartOpts?.rectheight ? 10                                 # height of slider scale
    rectcolor = chartOpts?.rectcolor ? "#ccc"                               # color of slider scale
    buttonsize = chartOpts?.buttonsize ? rectheight*2                       # size of buttons
    buttoncolor = chartOpts?.buttoncolor ? "#eee"                           # color of buttons (can be vector of length 2)
    buttonstroke = chartOpts?.buttonstroke ? "black"                        # color of button borders (can be vector of length 2)
    buttonround = chartOpts?.buttonround ? buttonsize*0.2                   # how much to round the button corners
    buttondotcolor = chartOpts?.buttondotcolor ? ["slateblue", "orchid"]    # color of dot on buttons (can be vector of length 2)
    buttondotsize = chartOpts?.buttondotsize ? buttonsize/4                 # radius of dot on button
    tickheight = chartOpts?.tickheight ? 10                                 # height of ticks
    tickgap = chartOpts?.tickgap ? tickheight/2                             # gap below ticks
    textsize = chartOpts?.textsize ? 14                                     # font size for axis labels
    nticks = chartOpts?.nticks ? 5                                          # number of ticks
    ticks = chartOpts?.ticks ? null                                         # vector of ticks
    # chartOpts end
    # accessors start
    value = [0,0] # current values of slider buttons
    stopindex = [0,0] # indexes of currently selected stop values for buttons
    # accessors end
    slider_svg = null


    buttoncolor = [buttoncolor, buttoncolor] unless Array.isArray(buttoncolor)
    buttonstroke = [buttonstroke, buttonstroke] unless Array.isArray(buttonstroke)
    buttondotcolor = [buttondotcolor, buttondotcolor] unless Array.isArray(buttondotcolor)

    chart = (selection, callback1, callback2, range, stops, initial_value) ->

        callbacks = [callback1, callback2]

        margin.left += margin.inner
        margin.right += margin.inner

        range = [margin.left, width-margin.right] unless range?

        if margin.top? and margin.top+margin.bottom>0
            margin.top = height * margin.top / (margin.top+margin.bottom)
        else
            margin.top = height/2

        if initial_value? # initial value provided
            value = initial_value.map((d) ->
                return range[0] if d < range[0]
                return range[1] if d > range[1]
                d)
            stopindex = value.map((d) -> d3panels.index_of_nearest(d, stops)) if stops?
            value = stopindex.map((i) -> stops[i]) if stops?
        else # pick random values
            if stops? # stops included; pick random stop index
                stopindex = [0,1].map((i) -> Math.floor( Math.random() * stops.length ))
                value = stopindex.map((i) -> stops[i])
            else
                value = [0,1].map((i) -> (range[1]-range[0])*Math.random() + range[0])

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


        # add buttons
        buttons = [0,1].map( (i) ->
                                slider_svg.insert("g").attr("id", "button" + (i+1))
                                          .attr("transform", (d) -> "translate(" + xscale(value[i]) + ",0)"))

        [0,1].map( (i) ->
            buttons[i].insert("rect")
               .attr("x", -buttonsize/2)
               .attr("y", margin.top - buttonsize/2)
               .attr("height", buttonsize)
               .attr("width", buttonsize)
               .attr("rx", buttonround)
               .attr("ry", buttonround)
               .attr("stroke", buttonstroke[i])
               .attr("stroke-width", 2)
               .attr("fill", buttoncolor[i])

            buttons[i].insert("circle")
               .attr("cx", 0)
               .attr("cy", margin.top)
               .attr("r", buttondotsize)
               .attr("fill", buttondotcolor[i]))


        # at click, move to front
        start_drag = (i) ->
            (d) ->
                buttons[i].raise()

        # function to deal with dragging
        dragged = (i) ->
            (d) ->
                pixel_value = d3.event.x
                clamped_pixels = clamp_pixels(pixel_value, [margin.left, width-margin.right])
                value[i] = xcscale.invert(clamped_pixels)
                d3.select(this).attr("transform", "translate(" + xcscale(value[i]) + ",0)")
                if stops?
                    stopindex[i] = d3panels.index_of_nearest(value[i], stops)
                    value[i] = stops[stopindex[i]]
                callbacks[i](chart) if callbacks[i]?

        # function at end of dragging:
        end_drag = (i) ->
            (d) ->
                pixel_value = d3.event.x
                clamped_pixels = clamp_pixels(pixel_value, [margin.left, width-margin.right])
                value[i] = xcscale.invert(clamped_pixels)
                if stops?
                    stopindex[i] = d3panels.index_of_nearest(value[i], stops)
                    value[i] = stops[stopindex[i]]
                callbacks[i](chart) if callbacks[i]?
                d3.select(this).attr("transform", "translate(" + xcscale(value[i]) + ",0)")

        # start the dragging
        [0,1].map( (i) ->
            buttons[i].call(d3.drag().on("start", start_drag(i)).on("drag", dragged(i)).on("end", end_drag(i)))

            # run the callback at the beginning
            callbacks[i](chart) if callbacks[i]? )

    # functions to grab stuff
    chart.value = () -> value
    chart.stopindex = () -> stopindex

    # function to remove the slider
    chart.remove = () ->
        slider_svg.remove()

    # return the chart function
    chart
