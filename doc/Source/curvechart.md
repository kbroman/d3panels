## `curvechart`

Plot of a set of curves.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; x variable as a two-dimensional array (potentially
  ragged), indexed like `x[ind][obs]`
- `y` &mdash; y variable as a two-dimensional array (potentially
  ragged), indexed like `y[ind][obs]`
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

If `data.x` has length 1, it is then expanded to have the same length
as `data.y`, in which case each row of `data.y` needs to have the same
length. The lengths of `data.indID` and `data.group` should be
the same as the length of `data.y`. Each row of `data.x` should have
the same length as corresponding row of `data.y`.

### Example

```coffeescript
data = {x:[[6,8,9,11,13,16]], y:[[10.3,22.8,22.9,32.1,28.6,30.9]]}

mychart = d3panels.curvechart({height:300, width:500})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
