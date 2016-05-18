## `histchart`

Chart of histograms (as curves)

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; a 2-d ragged array of data indexed as x[subject][response_index]
- `breaks` &mdash; number of breakpoints, or a vector of breakspoints (optional)
- `indID` &mdash; individual IDs (optional)

### Example

```coffeescript
data = {x: [[3.6, 5.5, 6.3, 3.0, 9.8, 3.6, 1.9, 3.9, 4.5, 4.6, 5.9, 6.1, 1.9, 6.2, 7.8, 6.2, 4.7, 5.2]], breaks:11}

mychart = d3panels.histchart({height:400, width:400})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
