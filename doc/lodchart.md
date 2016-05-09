## `lodchart`

Plot a lod curve.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `chr` &mdash; chromosome IDs
- `pos` &mdash; positions
- `lod` &mdash; LOD scores
- `marker` &mdash; marker names (with `""` denoting a pseudomarker that won't have a tool tip)

Optionally, the data can also contain:
- `chrname` &mdash; vector of distinct chromosome IDs
- `chrstart` &mdash; starting positions for the chromosomes
- `chrend` &mdash; ending positions for the chromosomes

### Example

```coffeescript
data = {chr:[1,1,1,1,2,2,2], pos:[0,5,10,20,0,8,12], lod:[0.42,1.69,1.65,2.94,0.17,0.15,0.07], marker:["1-1","1-2","","1-3","2-1","","2-2"]}

mychart = d3panels.lodchart({height:300, width:600})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `linecolor` &mdash; color for LOD curves \[default `"darkslateblue"`\]
- `linewidth` &mdash; width (pixels) for LOD curves \[default `2`\]
- `pointcolor` &mdash; color of points at markers \[default `"#e9cfec"`\]
- `pointsize` &mdash; pointsize at markers (if 0, no points plotted) \[default `0`\]
- `pointstroke` &mdash; color of circle around points at markers \[default `"black"`\]
- `ylim` &mdash; y-axis limits; if null, use range of data \[default `null`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`chrpanelframe`](chrpanelframe.md):

- `width` &mdash; overall height of chart in pixels \[default `800`\]
- `height` &mdash; overall width of chart in pixels \[default `500`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom) \[default `{left:60, top:40, right:40, bottom: 40}`\]
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) \[default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`\]
- `titlepos` &mdash; position of chart title in pixels \[default `20`\]
- `title` &mdash; chart title \[default `""`\]
- `xlab` &mdash; x-axis label \[default `"Chromosome"`\]
- `ylab` &mdash; y-axis label \[default `"LOD score"`\]
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
- `chrGap` &mdash; gap between chromosomes in pixels \[default `6`\]
- `horizontal` &mdash; if true, chromosomes on vertical axis (xlab, ylab, etc stay the same) \[default `false`\]



### Accessors

- `xscale()` &mdash; x-axis scale (vector by chromosome)
- `yscale()` &mdash; y-axis scale
- `chrSelect()` &mdash; chromosome rectangle selection
- `markerSelect()` &mdash; points at markers selection
- `markertip()` &mdash; tooltips selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.lodchart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

