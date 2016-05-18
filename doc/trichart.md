## `trichart`

Scatterplot of trinomial probabilities

### Data

The data is an associative array with a set of vectors, all of the same length:
- `p` &mdash; an array of length-3 arrays
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {p:[[1, 0, 0], [0,1,0], [0,0,1], [0.25, 0.5, 0.25], [0.5, 0.5, 0], [0.5, 0, 0.5], [0, 0.5, 0.5]]}

mychart = d3panels.trichart({height:400, width:400})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `width` &mdash; overall width of chart in pixels \[default `600`\]
- `height` &mdash; overall height of chart in pixels \[default `520`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom) \[default `{left:60, top:40, right:60, bottom: 10}`\]
- `labelpos` &mdash; pixels between vertex and vertex label (horizontally) \[default `10`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `labels` &mdash; labels on the corners \[default `["(1,0,0)", "(0,1,0)", "(0,0,1)"]`\]
- `rectcolor` &mdash; color of background rectangle \[default `"#e6e6e6"`\]
- `boxcolor` &mdash; color of outer rectangle box \[default `"black"`\]
- `boxwidth` &mdash; width of outer box in pixels \[default `2`\]
- `pointcolor` &mdash; fill color of points \[default `null`\]
- `pointstroke` &mdash; color of points' outer circle \[default `"black"`\]
- `pointsize` &mdash; color of points \[default `3`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `pscale()` &mdash; pt -> (x,y) in pixels
- `points()` &mdash; points selection
- `indtip()` &mdash; tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.trichart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

