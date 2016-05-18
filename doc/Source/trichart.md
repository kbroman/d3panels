## `trichart`

Scatterplot of trinomial probabilities

### Data

The data is an associative array with a set of vectors, all of the same length:
- `p` &mdash; an array of length-3 arrays
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {p:[[1, 0, 0], [0,1,0], [0,0,1], [0.25, 0.5, 0.25], [0.5, 0.5, 0], [0.5, 0, 0.5], [0, 0.5, 0.5]]}

mychart = d3panels.trichart({height:400, width:400})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
