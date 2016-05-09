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
- `xlineOpts` &mdash; color and width of vertical lines \[default `{color:"#CDCDCD", width:5}`\]
- `horizontal` &mdash; whether to interchange x and y-axes \[default `false`\]
- `v_over_h` &mdash; whether vertical lines should be on top of horizontal lines \[default `horizontal`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md):

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:3}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `xNA` &mdash; include box for x=NA values \[default `false`\]
- `yNA` &mdash; include box for y=NA values \[default `false`\]
- `xNA_size` &mdash; width and gap for x=NA box \[default `{width:20, gap:10}`\]
- `yNA_size` &mdash; width and gap for y=NA box \[default `{width:20, gap:10}`\]
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
- `segments()` &mdash; segments selection
- `tip()` &mdash; tool tip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.cichart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

