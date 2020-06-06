# tool tips

d3panels.tooltip_create = (selection, options) ->
    d3.select("body").append("div")
             .attr("class", "d3panels-tooltip #{options.tipclass}")
             .style("opacity", 1)


d3panels.tooltip_activate = (objects, tipdiv, options, tooltip_func) ->
    objects.on("mouseover.d3panels-tooltip", (d,i) ->
          mouseX = d3.event.pageX
          mouseY = d3.event.pageY

          tipdiv.html(tooltip_func(d,i))

          tipbox_height = tipdiv.node().getBoundingClientRect().height

          tipdiv.style("left", "#{(mouseX + 10)}px")
                .style("top", "#{(mouseY - tipbox_height/2)}px")
                .transition()
                .duration(0)
                .style("opacity", 0.9))

    objects.on("mouseout.d3panels-tooltip", (d) ->
              tipdiv.transition()
                  .duration(1000)
                  .style("opacity", 0))

d3panels.tooltip_destroy = (tipdiv) ->
    tipdiv.remove()
