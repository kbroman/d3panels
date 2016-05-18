## `dotchart`

Scatter plot where one dimension is categorial (sometimes called a
strip chart).

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; categories (as values 1, 2, 3, ...)
- `y` &mdash; responses
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {x:[1,2,3,1,2,3,1,2,3], y:[32, 36, 75, 28, 52, 44, 44, 24, 63]}

mychart = d3panels.dotchart({height:300, width:400})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
