# tool tips

d3panels.tooltip_create = (selection, options) ->
    selection.append("div")
             .attr("class", "d3panels-tooltip")
             .style("opacity", 0)


d3panels.tooltip_activate = (objects, tipdiv, options) ->
    objects.on("mouseover", (d) ->
          tipdiv.html(d.tooltip)

          h = tipdiv.node().getBoundingClientRect().height

          tipdiv.style("left", (d3.event.pageX + d.r*3)+"px")
                .style("top", (d3.event.pageY - h/2)+"px")
                .transition()
                .duration(0)
                .style("opacity", 0.9))

    objects.on("mouseout", (d) ->
              tipdiv.transition()
                  .duration(1000)
                  .style("opacity", 0))

d3panels.tooltip_destroy = (tipdiv) ->
    tipdiv.remove()
