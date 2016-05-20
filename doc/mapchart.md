## `mapchart`

Plot a genetic marker map.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `chr` &mdash; chromosome IDs
- `pos` &mdash; marker positions
- `marker` &mdash; marker names

Optionally, you can also include `data.chrname`, a vector of distinct
chromosome IDs.

### Example

```coffeescript
data = {chr:['1','1','1','1','2','2','2'],pos:[0,5,15,20,0,10,30],marker:['m1','m2','m3','m4','m5','m6','m7']}

mychart = d3panels.mapchart({height:300,width:250})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `tickwidth` &mdash; width of ticks at markers \[default `10`\]
- `linecolor` &mdash; line color \[default `"slateblue"`\]
- `linecolorhilit` &mdash; line color when highlighted \[default `"Orchid"`\]
- `linewidth` &mdash; line width (pixels) \[default `3`\]
- `xlab` &mdash; x-axis label \[default `"Chromosome"`\]
- `ylab` &mdash; y-axis label \[default `"Position (cM)"`\]
- `xlineOpts` &mdash; color and width of vertical lines \[default `{color:"#cdcdcd", width:5}`\]
- `horizontal` &mdash; whether chromosomes should be laid at horizontally \[default `false`\]
- `v_over_h` &mdash; whether vertical lines should be on top of horizontal lines \[default `horizontal`\]
- `shiftStart` &mdash; if true, shift start of chromosomes to 0 \[default `false`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md):

- `width` &mdash; overall width of chart in pixels \[default `800`\]
- `height` &mdash; overall height of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom, inner) \[default `{left:60, top:40, right:40, bottom: 40, inner:3}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `xlim` &mdash; x-axis limits \[default `[0,1]`\]
- `ylim` &mdash; y-axis limits \[default `[0,1]`\]
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
- `markerSelect()` &mdash; marker segment selection
- `martip()` &mdash; marker tool tip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.mapchart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

