## `mapchart`

Plot a genetic marker map.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `chr` &mdash; chromosome IDs
- `pos` &mdash; marker positions
- `marker` &mdash; marker names

Optionally, you can also include `data.chrname`, a vector of distinct
chromosome IDs.

### Example

```coffeescript
data = {chr:['1','1','1','1','2','2','2'],pos:[0,5,15,20,0,10,30],marker:['m1','m2','m3','m4','m5','m6','m7']}

mychart = d3panels.mapchart({height:300,width:250})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
