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

**insert_chartOpts**

**insert_accessors**
