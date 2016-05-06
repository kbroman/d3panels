## d3panels documentation

This subdirectory contains Markdown documents describing each of the
panel functions in [d3panels](http://kbroman.org/d3panels).

All of the functions work are called as `d3panels.blah()`. And for each
chart, you first call the chart function with a set of options, like
this:

```coffeescript
mychart = d3panels.lodchart({height:600, width:800, ylab="LOD score"})
```

And then you call the function that's created with some selection and
the data:

```coffeescript
mychart(d3.select("div#chart"), mydata)
```

(The one exception is [`add_lodcurve`](add_lodcurve.md); for that
function, you need to have first called [`lodchart`](lodchart.md) or
[`chrpanelframe`](chrpanelframe.md), and then you use the chart
function created by that call in place of a selection. See the
[documentation for `add_lodcurve`](add_lodcurve.md).)


### Blank panels (used by other panel functions)

- [`panelframe`](panelframe.md)
- [`chrpanelframe`](chrpanelframe.md)
- [`chr2dpanelframe`](chr2dpanelframe.md)

### Basic panels

- [`dotchart`](dotchart.md)
- [`scatterplot`](scatterplot.md)
- [`cichart`](cichart.md)
- [`heatmap`](heatmap.md)
- [`curvechart`](curvechart.md)

### LOD curve panels

- [`lodchart`](lodchart.md)
- [`add_lodcurve`](add_lodcurve.md)
- [`lodheatmap`](lodheatmap)
- [`lod2dheatmap`](lod2dheatmap)

### Other panels

- [`mapchart`](mapchart.md)
- [`crosstab`](crosstab.md)

### Utility functions

[d3panels](http://kbroman.org/d3panels) also contains some additional
utility functions plus CSS code used by the panels. These are not
documented.

- [`panelutil.coffee`](https://github.com/kbroman/d3panels/blob/master/src/panelutil.coffee)
  contains various utility functions
- [`panelutil.css`](https://github.com/kbroman/d3panels/blob/master/src/panelutil.css)
  contains CSS used by the panels

For snapshots and live tests, see <http://kbroman.org/d3panels>.
