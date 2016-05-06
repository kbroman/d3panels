## `chrpanelframe`

Creates a blank frame for a chart, with the x-axis split by
chromosome.  (Used by [`lodchart`](lodchart.md) and
[`lodheadmap`](lodheatmap.md).)

### Data

The data is a hash with a set of vectors, all of the same length:
- `chrname` &mdash; vector of chromosome IDs
- `chrstart` &mdash; starting positions for the chromosomes
- `chrend` &mdash; ending positions for the chromosomes

### Example

```coffeescript
data = {chr:['1', '2', '3', '4', '5'], start:[0,0,0,0,0], end:[100, 80, 65, 50, 50]}

mychart = d3panels.chrpanelframe()
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
