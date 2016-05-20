## `heatmap`

Plot colored rectangles corresponding to the _z_ values for
points (_x_,_y_) on a grid.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; vector of x values
- `y` &mdash; vector of y values
- `z` &mdash; 2d-array of z values, indexed as `z[x][y]`

Optionally, in place of `data.x` and `data.y`, include `data.xcat` and
`data.ycat` which are character string categories, in which case the
x and y axes will have evenly-spaced grids and the values in
`data.xcat` and `data.ycat` will be used as labels.

### Example

```coffeescript
data = {x:[1,2,3], y:[1,2,3], z:[[1.38,0.43,-0.15],[1.45,0.49,-0.08],[0.68,-0.28,-0.85]]}

mychart = d3panels.heatmap({height:400, width:400,nxticks:3,nyticks:3})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:0}`\]
- `xlim` &mdash; x-axis limits (if null take from data) \[default `null`\]
- `ylim` &mdash; y-axis limits (if null take from data) \[default `null`\]
- `nullcolor` &mdash; color for empty cells \[default `"#e6e6e6"`\]
- `colors` &mdash; vector of three colors for the color scale (negative - zero - positive) \[default `["slateblue", "white", "crimson"]`\]
- `zlim` &mdash; z-axis limits (if null take from data, symmetric about 0) \[default `null`\]
- `zthresh` &mdash; z threshold; if |z| < zthresh, not shown \[default `null`\]
- `hilitcolor` &mdash; color of box around highlighted cell \[default `"black"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md):

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
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
- `zscale()` &mdash; z-axis scale
- `cells()` &mdash; cell selection
- `celltip()` &mdash; cell tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.heatmap()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

