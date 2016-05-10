## `lodheatmap`

Plot a heatmap of a set of lod curves.

### Data

The data is an associative array containing
- `chr` &mdash; vector of chromosome IDs (length `m`)
- `pos` &mdash; vector of positions (length `m`)
- `lod` &mdash; matrix of LOD scores, indexed as
  `lod[position][phenotype]` with dimension `m` &times; `p`
- `y` or `ycat` &mdash; vector of numeric values (if `y`) or phenotype
  labels (if `ycat`), of length `p`.

Optionally, the data can also contain:
- `poslabel` &mdash; Same length as `data.chr`, with labels for the
  positions (length `m`)
- `chrname` &mdash; vector of distinct chromosome IDs
- `chrstart` &mdash; starting positions for the chromosomes
- `chrend` &mdash; ending positions for the chromosomes

### Example

```coffeescript
data = {chr:[1,1,1,1,2,2,2], pos:[0,5,10,20,0,8,12], lod:[[0.42,0.22],[1.69,1.73],[1.65,1.53],[2.94,2.21],[0.17,1.34],[0.15,1.85],[0.07,1.92]], ycat:["phe1","phe2"]}

mychart = d3panels.lodheatmap({height:150, width:600, colors:['crimson','white','slateblue']})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `width` &mdash; overall height of chart in pixels \[default `800`\]
- `height` &mdash; overall width of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom) \[default `{left:60, top:40, right:40, bottom: 40}`\]
- `colors` &mdash; vector of three colors for the color scale (negative - zero - positive) \[default `["slateblue", "white", "crimson"]`\]
- `nullcolor` &mdash; color for empty cells \[default `"#e6e6e6"`\]
- `xlab` &mdash; x-axis label \[default `"Chromosome"`\]
- `ylab` &mdash; y-axis label \[default `""`\]
- `ylim` &mdash; y-axis limits (if null take from data) \[default `null`\]
- `zlim` &mdash; z-axis limits (if null take from data, symmetric about 0) \[default `null`\]
- `zthresh` &mdash; z threshold; if |z| < zthresh, not shown \[default `null`\]
- `horizontal` &mdash; if true, have chromosomes arranged vertically \[default `false`\]
- `hilitcolor` &mdash; color of box around highlighted cell \[default `"black"`\]
- `chrGap` &mdash; gap between chromosomes (in pixels) \[default `6`\]
- `equalCells` &mdash; if true, make all cells equal-sized; in this case, chartOpts.chrGap is ignored \[default `false`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`chrpanelframe`](chrpanelframe.md):

- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `rotate_ylab` &mdash; whether to rotate the y-axis label \[default `null`\]
- `nyticks` &mdash; no. ticks on y-axis \[default `5`\]
- `yticks` &mdash; vector of tick positions on y-axis \[default `null`\]
- `yticklab` &mdash; vector of y-axis tick labels \[default `null`\]
- `rectcolor` &mdash; color of background rectangle \[default `"#e6e6e6"`\]
- `altrectcolor` &mdash; color of background rectangle for alternate chromosomes (if "", not created) \[default `"#d4d4d4"`\]
- `chrlinecolor` &mdash; color of lines between chromosomes (if "", leave off) \[default `""`\]
- `chrlinewidth` &mdash; width of lines between chromosomes \[default `2`\]
- `boxcolor` &mdash; color of outer rectangle box \[default `"black"`\]
- `boxwidth` &mdash; width of outer box in pixels \[default `2`\]
- `ylineOpts` &mdash; color and width of horizontal lines \[default `{color:"white", width:2}`\]



### Accessors

- `xscale()` &mdash; x-axis scale (vector by chromosome)
- `yscale()` &mdash; y-axis scale
- `zscale()` &mdash; z-axis scale
- `cells()` &mdash; cell selection
- `celltip()` &mdash; cell tooltip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.lodheatmap()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

