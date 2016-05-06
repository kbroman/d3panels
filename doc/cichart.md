## `cichart`

Plot estimates and confidence intervals for a set of categories.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `mean` &mdash; Main estimate
- `low` &mdash; Lower limit of confidence interval
- `high` &mdash; Upper limit of confidence interval

### Example

```coffeescript
data = {mean:[1,1.5,1.75], low:[0.9,1.4,1.6], high:[1.1,1.6,1.9]}

mychart = d3panels.cichart({height:300, width:300})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `xcatlabels` &mdash; category labels \[default `null`\]
- `segwidth` &mdash; segment width as proportion of distance between categories \[default `0.4`\]
- `segcolor` &mdash; color for segments \[default `"slateblue"`\]
- `segstrokewidth` &mdash; stroke width for segments \[default `"3"`\]
- `vertsegcolor` &mdash; color for vertical segments \[default `"slateblue"`\]
- `xlab` &mdash; x-axis label \[default `"Group"`\]
- `ylab` &mdash; y-axis label \[default `"Response"`\]
- `ylim` &mdash; y-axis limits \[default `null`\]
- `xlineOpts` &mdash; CDCDCD", width:5} \[default `{color:"`\]
- `horizontal` &mdash; whether to interchange x and y-axes \[default `false`\]
- `v_over_h` &mdash; whether vertical lines should be on top of horizontal lines \[default `horizontal`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md).


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `segments()` &mdash; segments selection
- `tip()` &mdash; tool tip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.cichart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

