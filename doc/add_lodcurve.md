## `add_lodcurve`

Add a lod curve to a [`chrpanelframe`](chrpanelframe.md) or
[`lodchart`](lodchart.md) chart. You can also use this to just add
some points to the plot.

After setup with chart options, use the *original chart function* (rather than a
selection) as the first argument.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `chr` &mdash; chromosome IDs
- `pos` &mdash; positions
- `lod` &mdash; LOD scores
- `marker` &mdash; marker names (with `""` denoting a pseudomarker that won't have a tool tip)

### Example

```coffeescript
genome_data = {chr:['1', '2', '3', '4', '5'], start:[0,0,0,0,0], end:[100, 80, 65, 50, 50]}

mychart = d3panels.chrpanelframe()
mychart(d3.select('body'), data)

lod_data = {chr:[1,2,5], pos:[52.45, 11.91, 1.56], lod:[3.342, 4.102, 0.420], marker:["p1", "p2", "p3"]}

addpoints = d3panels.add_lodcurve({linewidth:0, pointsize:4, pointcolor:"slateblue"})
addpoints(mychart, lod_data)
```

### Chart options (`chartOpts`)

- `linecolor` &mdash; color for LOD curves \[default `"darkslateblue"`\]
- `linewidth` &mdash; width (pixels) for LOD curves (if 0, no curves plotted) \[default `2`\]
- `linedash` &mdash; 'dash array' to make dotted lines \[default `""`\]
- `pointcolor` &mdash; e9cfec" \[default `"`\]
- `pointsize` &mdash; pointsize at markers (if 0, no points plotted) \[default `0`\]
- `pointstroke` &mdash; color of circle around points at markers \[default `"black"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]
- `horizontal` &mdash; if true, chromosomes on vertical axis (xlab, ylab, etc stay the same) \[default `false`\]


### Accessors

- `markerSelect()` &mdash; points at markers selection
- `markertip()` &mdash; tooltips selection

