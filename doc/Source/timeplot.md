## `timeplot`

Scatterplot of one variable against time.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; x variable
- `y` &mdash; y variable
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {x:["2026-05-16T15:59Z","2026-05-16T16:59Z","2026-05-16T17:59Z","2026-05-16T18:59Z","2026-05-16T19:59Z","2026-05-16T20:59Z"],y:[28.6,10.3,22.8,30.9,15.1,22.8]}

mychart = d3panels.timeplot({height:400, width:400})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
