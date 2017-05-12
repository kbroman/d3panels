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

**insert_chartOpts**

**insert_accessors**
