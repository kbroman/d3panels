## `scatterplot`

Scatterplot of one variable against another.

### Data

The data is a hash with a set of vectors, all of the same length:
- `x` &mdash; x variable
- `y` &mdash; y variable
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color)

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

You can also use the chart options for [`panelframe`](panelframe.md).


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `points()` &mdash; points selection
- `indtip()` &mdash; tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.scatterplot()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

