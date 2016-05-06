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
- `pointcolor` &mdash; e9cfec" \[default `"`\]
- `pointsize` &mdash; pointsize at markers (if 0, no points plotted) \[default `0`\]
- `pointstroke` &mdash; color of circle around points at markers \[default `"black"`\]
- `ylim` &mdash; y-axis limits; if null, use range of data \[default `null`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`chrpanelframe`](chrpanelframe.md).


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

