## `add_lodcurve`

Add a lod curve to a [`chrpanelframe`](chrpanelframe.md) or
[`lodchart`](lodchart.md) chart. You can also use this to just add
some points to the plot.

After setup with chart options, use the *original chart function* (rather than a
selection) as the first argument.

### Example

```coffeescript
genome_data = {chr:['1', '2', '3', '4', '5'], start:[0,0,0,0,0], end:[100, 80, 65, 50, 50]}

mychart = d3panels.chrpanelframe()
mychart(d3.select('body'), data)

lod_data = {chr:[1,2,2,4,5],
    pos:[52.45, 11.91, 55.93, 1.56, 38.84],
    lod:[3.342, 4.102, 3.002, 0.420, 2.654, 1.731, 2.246],
    marker:["1", "2", "3", "4", "5"]}

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

- `linecolor()` &mdash; color for LOD curves
- `linewidth()` &mdash; width (pixels) for LOD curves (if 0, no curves plotted)
- `linedash()` &mdash; 'dash array' to make dotted lines
- `pointcolor()` &mdash; e9cfec"
- `pointsize()` &mdash; pointsize at markers (if 0, no points plotted)
- `pointstroke()` &mdash; color of circle around points at markers
- `tipclass()` &mdash; class name for tool tips
- `horizontal()` &mdash; if true, chromosomes on vertical axis (xlab, ylab, etc stay the same)

