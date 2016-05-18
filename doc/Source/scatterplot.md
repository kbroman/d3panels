## `scatterplot`

Scatterplot of one variable against another.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; x variable
- `y` &mdash; y variable
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}

mychart = d3panels.scatterplot({height:400, width:400})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
