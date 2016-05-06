## `lod2dheatmap`

Plot a heatmap of a set of lod scores for a two-dimensional scan. Can
also be used to plot estimated recombination fractions for all marker pairs.

### Data

The data is an associative array containing
- `chr` &mdash; vector of chromosome IDs (length `m`)
- `pos` &mdash; vector of positions (length `m`)
- `lod` &mdash; matrix of LOD scores, indexed as
  `lod[pos_x][pos_y]` with dimension `m` &times; `m`

Optionally, the data can also contain:
- `poslabel` &mdash; Same length as `data.chr`, with labels for the
  positions (length `m`)
- `chrname` &mdash; vector of distinct chromosome IDs
- `chrstart` &mdash; starting positions for the chromosomes
- `chrend` &mdash; ending positions for the chromosomes

### Example

```coffeescript
data = {chr:[1,1,1,1,2,2,2], pos:[0,5,10,20,0,8,12], lod:[[null,11.4,3.1,0.6,0.3,0,0.2],[11.4,null,9.9,0.6,0.1,0,0.1],[3.1,9.9,null,2.9,0,0.2,0],[0.6,0.6,2.9,null,1.8,0.6,0.1],[0.3,0.1,0,1.8,null,10.7,9.2],[0,0,0.2,0.6,10.7,null,14],[0.2,0.1,0,0.1,9.2,14,null]]}

mychart = d3panels.lod2dheatmap({equalCells:true})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
