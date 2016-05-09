## `curvechart`

Plot of a set of curves.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; x variable as a two-dimensional array (potentially
  ragged), indexed like `x[ind][obs]`
- `y` &mdash; y variable as a two-dimensional array (potentially
  ragged), indexed like `y[ind][obs]`
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color)

If `data.x` has length 1, it is then expanded to have the same length
as `data.y`, in which case each row of `data.y` needs to have the same
length. The lengths of `data.indID` and `data.group` should be
the same as the length of `data.y`. Each row of `data.x` should have
the same length as corresponding row of `data.y`.

### Example

```coffeescript
data = {x:[[6,8,9,11,13,16]], y:[[10.3,22.8,22.9,32.1,28.6,30.9]]}

mychart = d3panels.curvechart({height:300, width:500})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `xlim` &mdash; x-axis limits (if null, taken from data) \[default `null`\]
- `ylim` &mdash; y-axis limits (if null, taken from data) \[default `null`\]
- `linecolor` &mdash; color of curves (if null, use pastel colors by group) \[default `null`\]
- `linecolorhilit` &mdash; color of highlighted curve (if null, use dark colors by group) \[default `null`\]
- `linewidth` &mdash; width of curve \[default `2`\]
- `linewidthhilit` &mdash; width of highlighted curve \[default `2`\]
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
- `xNA` &mdash; include box for x=NA values \[default `false`\]
- `yNA` &mdash; include box for y=NA values \[default `false`\]
- `xNA_size` &mdash; width and gap for x=NA box \[default `{width:20, gap:10}`\]
- `yNA_size` &mdash; width and gap for y=NA box \[default `{width:20, gap:10}`\]
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
mychart = d3panels.curvechart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

