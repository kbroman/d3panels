# tool tips

d3panels.tooltip_create = (selection, objects, options, tooltip_func) ->
    tipclass = options?.tipclass ? "d3panels-tooltip"
    direction = options?.direction ? "east"
    out_duration = options?.out_duration ? 1000
    in_duration = options?.in_duration ? 0
    pad = options?.pad ? 10
    pad = pad * 1.0
    fill = options?.fill
    fontcolor = options?.fontcolor
    fontsize = options?.fontsize

    unless ["east", "west", "north", "south"].includes?(direction)
            d3panels.displayError("tooltip_create: invalid direction (#{direction})")

    tipdiv = selection.append("div")
               .attr("class", "d3panels-tooltip #{tipclass}")
               .style("opacity", 0)

    tipdiv.style("background", fill) if fill?
    tipdiv.style("color", fontcolor) if fontcolor?
    tipdiv.style("font-size", "#{fontsize}px") if fontsize?

    objects.on("mouseover.#{tipclass}", (d,i) ->
          mouseX = d3.event.pageX*1.0
          mouseY = d3.event.pageY*1.0

          tipdiv.html(tooltip_func(d,i))

          tipbox_height = tipdiv.node().getBoundingClientRect().height*1.0
          tipbox_width = tipdiv.node().getBoundingClientRect().width*1.0

          if direction == "east"
              posX = mouseX + pad*1.0
              posY = mouseY - tipbox_height/2.0
          else if direction == "west"
              posX = mouseX - tipbox_width*1.0 - pad
              posY = mouseY - tipbox_height/2.0
          else if direction == "north"
              posX = mouseX - tipbox_width/2.0
              posY = mouseY - tipbox_height - pad
          else if direction == "south"
              posX = mouseX - tipbox_width/2.0
              posY = mouseY + pad

          console.log("#{direction} (#{mouseX},#{mouseY}) (#{posX},#{posY})")

          tipdiv.style("left", "#{posX}px")
                .style("top", "#{posY}px")
                .transition()
                .duration(in_duration)
                .style("opacity", 0.9))

    objects.on("mouseout.#{tipclass}", (d) ->
              tipdiv.transition()
                  .duration(out_duration)
                  .style("opacity", 0))

    tipdiv

d3panels.tooltip_destroy = (tipdiv) ->
    tipdiv.remove()
