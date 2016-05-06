## `heatmap`

Plot colored rectangles corresponding to the _z_ values for
points (_x_,_y_) on a grid.

### Data

The data is a hash with a set of vectors, all of the same length:
- `x` &mdash; vector of x values
- `y` &mdash; vector of y values
- `z` &mdash; 2d-array of z values, indexed as `z[x][y]`

Optionally, in place of `data.x` and `data.y`, include `data.xcat` and
`data.ycat` which are character string categories, in which case the
x and y axes will have evenly-spaced grids and the values in
`data.xcat` and `data.ycat` will be used as labels.

### Example

```coffeescript
data = {x:[1,2,3], y:[1,2,3], z:[[1.38,0.43,-0.15],[1.45,0.49,-0.08],[0.68,-0.28,-0.85]]}

mychart = d3panels.heatmap({height:400, width:400,nxticks:3,nyticks:3})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
