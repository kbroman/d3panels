## `histchart`

Chart of histograms (as curves)

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; a 2-d ragged array of data indexed as x[subject][response_index]
- `breaks` &mdash; number of breakpoints, or a vector of breakspoints (optional)
- `indID` &mdash; individual IDs (optional)

### Example

```coffeescript
data = {x: [[3.6, 5.5, 6.3, 3.0, 9.8, 3.6, 1.9, 3.9, 4.5, 4.6, 5.9, 6.1, 1.9, 6.2, 7.8, 6.2, 4.7, 5.2]], breaks:11}

mychart = d3panels.histchart({height:400, width:400})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `xlim` &mdash; x-axis limits (if null, taken from data) \[default `null`\]
- `ylim` &mdash; y-axis limits (if null, taken from data) \[default `null`\]
- `xlab` &mdash; x-axis label \[default `""`\]
- `ylab` &mdash; y-axis label \[default `""`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `linecolor` &mdash; color of curves (if null, use pastel colors by group) \[default `null`\]
- `linecolorhilit` &mdash; color of highlighted curve (if null, use dark colors by group) \[default `null`\]
- `linewidth` &mdash; width of curve \[default `2`\]
- `linewidthhilit` &mdash; width of highlighted curve \[default `2`\]
- `density` &mdash; density scale (vs counts) \[default `true`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md):

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:3}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
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
- `curves()` &mdash; curves selection
- `indtip()` &mdash; tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.histchart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

