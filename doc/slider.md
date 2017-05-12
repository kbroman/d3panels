## `slider`

A slider.

### Inputs

As with the other functions in
[d3panels](http://kbroman.org/d3panels), the first argument is a
selection in which the slider will be inserted.

The next arguments
is callback function that is called when the button is slid.

Then two pieces of data: `range` is an interval over which the slider
can take values, and an optional array `stops` is a set of discrete values in
the range that the slider can take.

### Example

```coffeescript
data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}

svg = d3.select("body").insert("svg")
        .attr("height", 500).attr("width", 400)

mychart = d3panels.scatterplot({height:400, width:400})
mychart(svg, data)

g = svg.insert("g").attr("transform", "translate(0,400)")

my_slider = d3panels.slider({height:100, width:400})

callback = (sl) -> mychart.points().attr("opacity", sl.value())

my_slider(g, callback, [0,1])
```

### Chart options (`chartOpts`)

- `width` &mdash; total width of svg for slider \[default `800`\]
- `height` &mdash; total height of svg for slider \[default `80`\]
- `margin` &mdash; margin on left and right of slider \[default `25`\]
- `rectheight` &mdash; height of slider scale \[default `10`\]
- `rectcolor` &mdash; color of slider scale \[default `"#ccc"`\]
- `buttonsize` &mdash; size of button \[default `rectheight*2`\]
- `buttoncolor` &mdash; color of button \[default `"#eee"`\]
- `buttonstroke` &mdash; color of button border \[default `"black"`\]
- `buttonround` &mdash; how much to round the button corners \[default `buttonsize*0.2`\]
- `buttondotcolor` &mdash; color of dot on button \[default `"slateblue"`\]
- `buttondotsize` &mdash; radius of dot on button \[default `buttonsize/4`\]
- `tickheight` &mdash; height of ticks \[default `10`\]
- `tickgap` &mdash; gap below ticks \[default `tickheight/2`\]
- `textsize` &mdash; font size for axis labels \[default `14`\]
- `nticks` &mdash; number of ticks \[default `5`\]
- `ticks` &mdash; vector of ticks \[default `null`\]


### Accessors

- `value()` &mdash; current value of slider
- `stopindex()` &mdash; index of currently selected stop value

Use these like this:

```coffeescript
mychart = d3panels.slider()
mychart(d3.select("body"), data)
value = mychart.value()
```

