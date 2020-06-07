# tool tips

d3panels.tooltip_create = (selection, objects, options, tooltip_func) ->
    tipclass = options?.tipclass ? "d3panels-tooltip"
    direction = options?.direction ? "east"
    out_duration = options?.out_duration ? 1000
    in_duration = options?.in_duration ? 0
    pad = options?.pad ? 16
    fill = options?.fill
    fontcolor = options?.fontcolor
    fontsize = options?.fontsize

    pad = pad * 1.0

    unless ["east", "west", "north", "south"].includes?(direction)
            d3panels.displayError("tooltip_create: invalid direction (#{direction})")

    tipdiv = selection.append("div")
               .attr("class", "d3panels-tooltip #{tipclass}")
               .style("opacity", 0)

    if direction == "east"
        triChar = '\u25C0'
    else if direction == "west"
        triChar = '\u25B6'
    else if direction == "north"
        triChar = '\u25BC'
    else if direction == "south"
        triChar = '\u25B2'

    tridiv = selection.append("div")
                      .attr("class", "d3panels-tooltip-tri #{tipclass}")
                      .style("opacity", 0)
                      .html(triChar)

    tipdiv.style("background", fill) if fill?
    tipdiv.style("color", fontcolor) if fontcolor?
    tipdiv.style("font-size", "#{fontsize}px") if fontsize?
    tridiv.style("color", fill) if fill?
    tridiv.style("font-size", "#{fontsize}px") if fontsize?

    tripad = tridiv.style("font-size").replace("px", "")*1.0

    objects.on("mouseover.#{tipclass}", (d,i) ->
          mouseX = d3.event.pageX*1.0
          mouseY = d3.event.pageY*1.0

          tipdiv.html(tooltip_func(d,i))

          tipbox_height = tipdiv.node().getBoundingClientRect().height*1.0
          tipbox_width = tipdiv.node().getBoundingClientRect().width*1.0

          shiftX = shiftY = 0
          if direction == "east"
              posX = mouseX + pad
              posY = mouseY - tipbox_height/2.0
              triChar = '\u25C0'
              shiftX = -tripad
              shiftY = tripad/4
          else if direction == "west"
              posX = mouseX - tipbox_width*1.0 - pad
              posY = mouseY - tipbox_height/2.0
              triChar = '\u25B6'
              shiftX = -tripad + tipbox_width
              shiftY = tripad/4
          else if direction == "north"
              posX = mouseX - tipbox_width/2.0
              posY = mouseY - tipbox_height - pad
              triChar = '\u25BC'
              shiftX = tipbox_width/2.0-tripad
              shiftY = pad+tripad
          else if direction == "south"
              posX = mouseX - tipbox_width/2.0
              posY = mouseY + pad
              triChar = '\u25B2'
              shiftX = tipbox_width/2.0-tripad
              shiftY = -pad+tripad



          tipdiv.style("left", "#{posX}px")
                .style("top", "#{posY}px")
                .transition()
                .duration(in_duration)
                .style("opacity", 1.0)

          triX = posX + shiftX
          triY = posY + shiftY

          tridiv.style("left", "#{triX}px")
                .style("top",  "#{triY}px")
                .style("width", tipbox_width)
                .style("height", tipbox_height)
                .transition()
                .duration(in_duration/1.2)
                .style("opacity", 1.0))

    objects.on("mouseout.#{tipclass}", (d) ->
              tipdiv.transition()
                  .duration(out_duration)
                  .style("opacity", 0)
              tridiv.transition()
                  .duration(out_duration/1.2)
                  .style("opacity", 0))

    tipdiv

d3panels.tooltip_destroy = (tipdiv) ->
    tipdiv.remove()
