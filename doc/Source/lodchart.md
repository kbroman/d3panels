## `lodchart`

Plot a lod curve.

### Data

The data is a hash with a set of vectors, all of the same length:
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

**insert_chartOpts**

**insert_accessors**
