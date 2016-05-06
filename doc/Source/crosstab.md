## `crosstab`

Display a cross-tabulation (in other words, a two-way table)

### Data

The data is a hash with two vectors of the same length:
- `x` &mdash; vector of x values in 1,2,... (rows in the table)
- `y` &mdash; vector of y values in 1,2,... (columns in the table)

For each of `data.x` and `data.y`, the largest value is presumed to
correspond to the missing values (N/A).

Optionally, include
- `xcat` &mdash; Vector of labels for the _x_ categories
- `ycat` &mdash; Vector of labels for the _y_ categories
- `xlabel` &mdash; Label (name) for the _x_ variable
- `ylabel` &mdash; Label (name) for the _y_ variable

### Example

```coffeescript
data = {x:[1,3,1,1,3,1,1,3,1,3], y:[1,3,1,3,2,1,1,2,2,2]}

mychart = d3panels.crosstab()
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
