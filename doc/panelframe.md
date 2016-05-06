## `panelframe`

Creates a blank frame for a chart; used by [`dotchart`](dotchart.md),
[`scatterplot`](scatterplot.md), [`curvechart`](curvechart.md),
[`cichart`](cichart.md), and [`heatmap`](heatmap.md).

### Data

This function takes no data.

### Example

```coffeescript
mychart = d3panels.panelframe({xlim:[0,100], ylim:[0,5]})
mychart(d3.select('body'))
```

### Chart options (`chartOpts`)

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:3}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `xlab` &mdash; x-axis label \[default `"X"`\]
- `ylab` &mdash; y-axis label \[default `"Y"`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `xNA` &mdash; include box for x=NA values \[default `false`\]
- `yNA` &mdash; include box for y=NA values \[default `false`\]
- `xNA_size` &mdash; width and gap for x=NA box \[default `{width:20, gap:10}`\]
- `yNA_size` &mdash; width and gap for y=NA box \[default `{width:20, gap:10}`\]
- `xlim` &mdash; x-axis limits \[default `[0,1]`\]
- `ylim` &mdash; y-axis limits \[default `[0,1]`\]
- `nxticks` &mdash; no. ticks on x-axis \[default `5`\]
- `xticks` &mdash; vector of tick positions on x-axis \[default `null`\]
- `xticklab` &mdash; vector of x-axis tick labels \[default `null`\]
- `nyticks` &mdash; no. ticks on y-axis \[default `5`\]
- `yticks` &mdash; vector of tick positions on y-axis \[default `null`\]
- `yticklab` &mdash; vector of y-axis tick labels \[default `null`\]
- `rectcolor` &mdash; e6e6e6" \[default `"`\]
- `boxcolor` &mdash; color of outer rectangle box \[default `"black"`\]
- `boxwidth` &mdash; width of outer box in pixels \[default `2`\]
- `xlineOpts` &mdash; color and width of vertical lines \[default `{color:"white", width:2}`\]
- `ylineOpts` &mdash; color and width of horizontal lines \[default `{color:"white", width:2}`\]
- `v_over_h` &mdash; whether the vertical grid lines should be on top of the horizontal lines \[default `false`\]


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `xscale_wnull()` &mdash; x-axis scale, with treatment of null values
- `yscale_wnull()` &mdash; y-axis scale, with treatment of null values
- `xlines()` &mdash; xlines selection
- `ylines()` &mdash; ylines selection
- `xlabels()` &mdash; x-axis labels selection
- `ylabels()` &mdash; y-axis labels selection
- `plot_width()` &mdash; plot width (in pixels)
- `plot_height()` &mdash; plot height (in pixels)
- `box()` &mdash; outer box selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.panelframe()
mychart(d3.select("body"))
xscale = mychart.xscale()
```

