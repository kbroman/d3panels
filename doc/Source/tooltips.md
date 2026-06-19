## `tooltips`

### Inputs

The key functions are `d3panels.tooltip_create()`,
`d3panels.tooltip_move()`, `d3panels.tooltip_text()`,
`d3panels.tooltip_show()`, `d3panels.tooltip_hide()`,
and `d3panels.tooltip_destroy()`.

The key function is `tooltip_create()`. As with the other functions in
[d3panels](https://kbroman.org/d3panels/), the first argument is a
selection in which the tooltips will be inserted. The next argument is
a set of objects that the tooltip will be bound to. Then a set of
options, including `direction`, `fill`, and `fontcolor`. See below.
Finally, a function that is used to define the text/label within the
tool tip.

Here are the other tooltip functions:

- `tooltip_move()` takes the output of `tooltip_create()` plus new
  functions for the x and y coordinates.

- `tooltip_test()` takes the output of `tooltip_create()` plus
  a function to define the tool tip text.

- `tooltip_show()` takes the output of `tooltip_create()` and a
  transition in milliseconds, to make the tool tip opaque.

- `tooltip_hide()` takes the output of `tooltip_create()` and a
  transition in milliseconds, to make the tool tip transparent.

- `tooltip_destroy()` takes the output of `tooltip_create()` and a
  removes the element.


### Example

```coffeescript
data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}
data = ({x:data.x[i], y:data.y[i]} for i of data.x)

svg = d3.select("body").insert("svg")
        .attr("height", 500).attr("width", 400)

points = svg.selectAll("circle")
            .data(data)
            .enter()
            .append("circle")
            .attr("r", 6)
            .attr("cx", (d) -> d.x*20)
            .attr("cy", (d) -> d.y*8)
            .attr("fill", "slateblue")

points.on "mouseover", () -> d3.select(this).attr("fill", "violetred")
      .on "mouseout", () -> d3.select(this).attr("fill", "slateblue")

indtip = d3panels.tooltip_create(d3.select("div#chart"), points,
                                 {direction:"north"}, (d) -> "(#{d.x},#{d.y})")
```

### `options`

- `tipclass` &mdash; CSS class for tooltips
- `direction` &mdash; direction (north/south/east/west) where the
  tooltip will show up
- `out_duration` &mdash; time (ms) for tooltip to disappear
- `in_duration` &mbdash; time (ms) for tooltip to appear
- `pad` &mdash; padding around text
- `fill` &mdash; background color of tooltip
- `fontcolor` &mdash; color of text
- `fontsize` &mdash; size of font
