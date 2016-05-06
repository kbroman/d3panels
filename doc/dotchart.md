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
- `xlineOpts` &mdash; cdcdcd", width:5} \[default `{color:"`\]
- `pointcolor` &mdash; fill color of points \[default `"slateblue"`\]
- `pointstroke` &mdash; color of points' outer circle \[default `"black"`\]
- `pointsize` &mdash; color of points \[default `3`\]
- `jitter` &mdash; method for jittering points (beeswarm|random|none) \[default `"beeswarm"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]
- `horizontal` &mdash; whether to interchange x and y-axes \[default `false`\]
- `v_over_h` &mdash; whether vertical lines should be on top of horizontal lines \[default `horizontal`\]

You can also use the chart options for [`panelframe`](panelframe.md).


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `points()` &mdash; point selection
- `indtip()` &mdash; tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.dotchart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

