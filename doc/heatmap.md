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
- `nullcolor` &mdash; e6e6e6" \[default `"`\]
- `colors` &mdash; vector of three colors for the color scale (negative - zero - positive) \[default `["slateblue", "white", "crimson"]`\]
- `zlim` &mdash; z-axis limits (if null take from data, symmetric about 0) \[default `null`\]
- `zthresh` &mdash; z threshold; if |z| < zthresh, not shown \[default `null`\]
- `hilitcolor` &mdash; color of box around highlighted cell \[default `"black"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md).


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `zscale()` &mdash; z-axis scale
- `cellSelect()` &mdash; cell selection
- `celltip()` &mdash; cell tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.heatmap()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

