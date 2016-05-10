## `dotchart`

Scatter plot where one dimension is categorial (sometimes called a
strip chart).

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; categories (as values 1, 2, 3, ...)
- `y` &mdash; responses
- `indID` &mdash; individual IDs (optional)

### Example

```coffeescript
data = {x:[1,2,3,1,2,3,1,2,3], y:[32, 36, 75, 28, 52, 44, 44, 24, 63]}

mychart = d3panels.dotchart({height:300, width:400})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `xcategories` &mdash; group categories \[default `null`\]
- `xcatlabels` &mdash; labels for group categories \[default `null`\]
- `xNA` &mdash; handle: include separate boxes for NAs; force: include whether or not NAs in data \[default `{handle:true, force:false}`\]
- `yNA` &mdash; handle: include separate boxes for NAs; force: include whether or not NAs in data \[default `{handle:true, force:false}`\]
- `xNA_size` &mdash; width and gap for x=NA box \[default `{width:20, gap:10}`\]
- `yNA_size` &mdash; width and gap for y=NA box \[default `{width:20, gap:10}`\]
- `ylim` &mdash; y-axis limits \[default `null`\]
- `xlab` &mdash; x-axis title \[default `"Group"`\]
- `ylab` &mdash; y-axis title \[default `"Response"`\]
- `xlineOpts` &mdash; color and width of vertical lines \[default `{color:"#cdcdcd", width:5}`\]
- `pointcolor` &mdash; fill color of points \[default `"slateblue"`\]
- `pointstroke` &mdash; color of points' outer circle \[default `"black"`\]
- `pointsize` &mdash; color of points \[default `3`\]
- `jitter` &mdash; method for jittering points (beeswarm|random|none) \[default `"beeswarm"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]
- `horizontal` &mdash; whether to interchange x and y-axes \[default `false`\]
- `v_over_h` &mdash; whether vertical lines should be on top of horizontal lines \[default `horizontal`\]

You can also use the chart options for [`panelframe`](panelframe.md):

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:3}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `xlim` &mdash; x-axis limits \[default `[0,1]`\]
- `nxticks` &mdash; no. ticks on x-axis \[default `5`\]
- `xticks` &mdash; vector of tick positions on x-axis \[default `null`\]
- `xticklab` &mdash; vector of x-axis tick labels \[default `null`\]
- `nyticks` &mdash; no. ticks on y-axis \[default `5`\]
- `yticks` &mdash; vector of tick positions on y-axis \[default `null`\]
- `yticklab` &mdash; vector of y-axis tick labels \[default `null`\]
- `rectcolor` &mdash; color of background rectangle \[default `"#e6e6e6"`\]
- `boxcolor` &mdash; color of outer rectangle box \[default `"black"`\]
- `boxwidth` &mdash; width of outer box in pixels \[default `2`\]
- `ylineOpts` &mdash; color and width of horizontal lines \[default `{color:"white", width:2}`\]



### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `xNA()` &mdash; true if x-axis NAs are handled in a separate box
- `yNA()` &mdash; true if y-axis NAs are handled in a separate box
- `points()` &mdash; point selection
- `indtip()` &mdash; tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.dotchart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

