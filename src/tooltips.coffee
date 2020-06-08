# tool tips

d3panels.tooltip_create = (selection, objects, options, tooltip_func) ->
    tipclass = options?.tipclass ? "d3panels-tooltip"
    direction = options?.direction ? "east"
    out_duration = options?.out_duration ? 1000
    in_duration = options?.in_duration ? 0
    pad = options?.pad ? 8
    fill = options?.fill
    fontcolor = options?.fontcolor
    fontsize = options?.fontsize

    tipgroup = selection.append("g")
                        .attr("class", "d3panels-tooltip #{tipclass}")
                        .style("opacity",0)
                        .datum({direction:direction, pad:pad})
    tipdiv = tipgroup.append("div")
                     .attr("class", "d3panels-tooltip #{tipclass}")

    if direction == "east"
        triChar = '\u25C0'        # triangle pointing left
    else if direction == "west"
        triChar = '\u25B6'        # triangle pointing right
    else if direction == "north"
        triChar = '\u25BC'        # triangle pointing down
    else if direction == "south"
        triChar = '\u25B2'        # triangle pointing up
    else
        d3panels.displayError("tooltip_create: invalid direction (#{direction})")

    tridiv = tipgroup.append("div")
                     .attr("class", "d3panels-tooltip-tri #{tipclass}")
                     .html(triChar)

    tipdiv.style("background", fill) if fill?
    tipdiv.style("color", fontcolor) if fontcolor?
    tipdiv.style("font-size", "#{fontsize}px") if fontsize?
    tridiv.style("color", fill) if fill?
    tridiv.style("font-size", "#{fontsize}px") if fontsize?

    objects.on("mouseover.#{tipclass}", (d,i) ->
          # mouse position; make sure these are numbers
          mouseX = d3.event.pageX*1.0
          mouseY = d3.event.pageY*1.0

          tipdiv.html(tooltip_func(d,i))

          d3panels.tooltip_move(tipgroup, mouseX, mouseY)
          d3panels.tooltip_show(tipgroup, in_duration))

    objects.on("mouseout.#{tipclass}", (d) ->
              d3panels.tooltip_hide(tipgroup, out_duration))

    tipgroup

d3panels.tooltip_move = (tipgroup, x, y) ->
    tipdiv = tipgroup.select("div.d3panels-tooltip")
    tridiv = tipgroup.select("div.d3panels-tooltip-tri")

    tipbox_height = tipdiv.node().getBoundingClientRect().height*1.0
    tipbox_width = tipdiv.node().getBoundingClientRect().width*1.0

    # make sure we have the font size
    fontsize = tridiv.style("font-size").replace("px", "")*1.0
    pad = tipgroup.datum().pad * 1.0 + fontsize
    direction = tipgroup.datum().direction

    shiftX = shiftY = 0 # <- for triangle, relative to tool tip box
    if direction == "east"
        posX = x + pad
        posY = y - tipbox_height/2.0

        divpad = tipdiv.style("padding-left").replace("px", "")*1.0

        shiftX = -fontsize - divpad
        shiftY = tipbox_height/2.0 - fontsize/2.0
    else if direction == "west"
        posX = x - tipbox_width*1.0 - pad
        posY = y - tipbox_height/2.0

        divpad = tipdiv.style("padding-right").replace("px", "")*1.0

        shiftX = tipbox_width - fontsize + divpad
        shiftY = tipbox_height/2.0-fontsize/2.0
    else if direction == "north"
        posX = x - tipbox_width/2.0
        posY = y - tipbox_height - pad

        divpad = tipdiv.style("padding-bottom").replace("px", "")*1.0

        shiftX = tipbox_width/2.0-fontsize
        shiftY = tipbox_height+divpad/2.0-fontsize/2.0
    else if direction == "south"
        posX = x - tipbox_width/2.0
        posY = y + pad

        divpad = tipdiv.style("padding-top").replace("px", "")*1.0

        shiftX = +tipbox_width/2.0-fontsize
        shiftY = -fontsize

    tipdiv.style("left", "#{posX}px")
          .style("top", "#{posY}px")

    triX = posX + shiftX
    triY = posY + shiftY

    tridiv.style("left", "#{triX}px")
          .style("top",  "#{triY}px")
          .style("width", tipbox_width)
          .style("height", tipbox_height)


d3panels.tooltip_text = (tipgroup, text) ->
    tipgroup.select("div.d3panels-tooltip").html(text)

d3panels.tooltip_show = (tipgroup, duration) ->
    tipgroup.transition()
            .duration(duration)
            .style("opacity", 1)

d3panels.tooltip_hide = (tipgroup, duration) ->
    tipgroup.transition()
            .duration(duration)
            .style("opacity", 0)

d3panels.tooltip_destroy = (tipgroup) ->
    tipgroup.remove()
