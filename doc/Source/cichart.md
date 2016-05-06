## `cichart`

Plot estimates and confidence intervals for a set of categories.

### Data

The data is a hash with a set of vectors, all of the same length:
- `mean` &mdash; Main estimate
- `low` &mdash; Lower limit of confidence interval
- `high` &mdash; Upper limit of confidence interval

### Example

```coffeescript
data = {mean:[1,1.5,1.75], low:[0.9,1.4,1.6], high:[1.1,1.6,1.9]}

mychart = d3panels.cichart({height:300, width:300})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
