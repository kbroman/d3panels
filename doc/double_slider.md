## `double_slider`

A slider with two controls.

### Inputs

As with the other functions in
[d3panels](http://kbroman.org/d3panels), the first argument is a
selection in which the slider will be inserted.

The next two arguments
are callback functions, one for the first button and one for the
second.

Then two pieces of data: `range` is an interval over which the slider
can take values, and an optional array `stops` is a set of discrete values in
the range that the slider can take.

Finally, you can give an `initial_value` for the slider (a vector of
two values). Otherwise, the initial value is set randomly.

### Example

```coffeescript
data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}

svg = d3.select("body").insert("svg")
        .attr("height", 500).attr("width", 400)

pointsize = 10
mychart = d3panels.scatterplot({height:400, width:400, pointsize:pointsize})
mychart(svg, data)

g = svg.insert("g").attr("transform", "translate(0,400)")

my_slider = d3panels.slider({height:100, width:400})

callback = (sl) ->
    value = sl.value()
    mychart.points().attr("opacity", value[0])
                    .attr("r", value[1]*pointsize)

my_slider(g, callback, [0,1])
```

### Chart options (`chartOpts`)

- `width` &mdash; total width of svg for slider \[default `800`\]
- `height` &mdash; total height of svg for slider \[default `80`\]
- `margin` &mdash; margins \[default `{left:25, right:25, inner:0, top:40, bottom:40}`\]
- `rectheight` &mdash; height of slider scale \[default `10`\]
- `rectcolor` &mdash; color of slider scale \[default `"#ccc"`\]
- `buttonsize` &mdash; size of buttons \[default `rectheight*2`\]
- `buttoncolor` &mdash; color of buttons (can be vector of length 2) \[default `"#eee"`\]
- `buttonstroke` &mdash; color of button borders (can be vector of length 2) \[default `"black"`\]
- `buttonround` &mdash; how much to round the button corners \[default `buttonsize*0.2`\]
- `buttondotcolor` &mdash; color of dot on buttons (can be vector of length 2) \[default `["slateblue", "orchid"]`\]
- `buttondotsize` &mdash; radius of dot on button \[default `buttonsize/4`\]
- `tickheight` &mdash; height of ticks \[default `10`\]
- `tickgap` &mdash; gap below ticks \[default `tickheight/2`\]
- `textsize` &mdash; font size for axis labels \[default `14`\]
- `nticks` &mdash; number of ticks \[default `5`\]
- `ticks` &mdash; vector of ticks \[default `null`\]
- `ticks_at_stops` &mdash; if true, include scale (above slider) showing stops \[default `true`\]


### Accessors

- `value()` &mdash; current values of slider buttons
- `stopindex()` &mdash; indexes of currently selected stop values for buttons

Use these like this:

```coffeescript
mychart = d3panels.double_slider()
mychart(d3.select("body"), callback1, callback2, range)
value = mychart.value()
```

