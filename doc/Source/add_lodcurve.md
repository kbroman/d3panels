## `add_lodcurve`

Add a lod curve to a [`chrpanelframe`](chrpanelframe.md) or
[`lodchart`](lodchart.md) chart. You can also use this to just add
some points to the plot.

After setup with chart options, use the *original chart function* (rather than a
selection) as the first argument.

### Data

The data is a hash with a set of vectors, all of the same length:
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

**insert_chartOpts**

**insert_accessors**
