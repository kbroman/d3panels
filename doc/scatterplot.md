## `scatterplot`

Scatterplot of one variable against another.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; x variable
- `y` &mdash; y variable
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}

mychart = d3panels.scatterplot({height:400, width:400})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `xNA` &mdash; handle: include separate boxes for NAs; force: include whether or not NAs in data \[default `{handle:true, force:false}`\]
- `yNA` &mdash; handle: include separate boxes for NAs; force: include whether or not NAs in data \[default `{handle:true, force:false}`\]
- `xNA_size` &mdash; width and gap for x=NA box \[default `{width:20, gap:10}`\]
- `yNA_size` &mdash; width and gap for y=NA box \[default `{width:20, gap:10}`\]
- `xlim` &mdash; x-axis limits \[default `null`\]
- `ylim` &mdash; y-axis limits \[default `null`\]
- `pointcolor` &mdash; fill color of points \[default `null`\]
- `pointstroke` &mdash; color of points' outer circle \[default `"black"`\]
- `pointsize` &mdash; color of points \[default `3`\]
- `jitter` &mdash; method for jittering NA points (beeswarm|random|none) \[default `"beeswarm"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md):

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:3}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `xlab` &mdash; x-axis label \[default `"X"`\]
- `ylab` &mdash; y-axis label \[default `"Y"`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `nxticks` &mdash; no. ticks on x-axis \[default `5`\]
- `xticks` &mdash; vector of tick positions on x-axis \[default `null`\]
- `xticklab` &mdash; vector of x-axis tick labels \[default `null`\]
- `nyticks` &mdash; no. ticks on y-axis \[default `5`\]
- `yticks` &mdash; vector of tick positions on y-axis \[default `null`\]
- `yticklab` &mdash; vector of y-axis tick labels \[default `null`\]
- `rectcolor` &mdash; color of background rectangle \[default `"#e6e6e6"`\]
- `boxcolor` &mdash; color of outer rectangle box \[default `"black"`\]
- `boxwidth` &mdash; width of outer box in pixels \[default `2`\]
- `xlineOpts` &mdash; color and width of vertical lines \[default `{color:"white", width:2}`\]
- `ylineOpts` &mdash; color and width of horizontal lines \[default `{color:"white", width:2}`\]
- `v_over_h` &mdash; whether the vertical grid lines should be on top of the horizontal lines \[default `false`\]



### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `xNA()` &mdash; true if x-axis NAs are handled in a separate box
- `yNA()` &mdash; true if y-axis NAs are handled in a separate box
- `points()` &mdash; points selection
- `indtip()` &mdash; tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.scatterplot()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

