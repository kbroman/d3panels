## d3panels documentation

This subdirectory contains Markdown documents describing each of the
panel functions in [d3panels](https://kbroman.org/d3panels).

All of the functions are called as `d3panels.blah()`. And for each
chart, you first call the chart function with a set of options, like
this:

```coffeescript
mychart = d3panels.lodchart({height:600, width:800})
```

And then you call the function that's created with some selection and
the data:

```coffeescript
mychart(d3.select("div#chart"), mydata)
```

There are three exceptions to this:
[`add_lodcurve`](add_lodcurve.md), [`add_curves`](add_curves.md), and [`add_points`](add_points.md).
For these functions, you first need to call another function that
creates a panel
(for example, [`lodchart`](lodchart.md) or [`chrpanelframe`](chrpanelframe.md) in
the case of [`add_lodcurve`](add_lodcurve.md), or
[`panelframe`](panelframe.md) in the case of
[`add_curves`](add_curves.md) or [`add_points`](add_points.md)).  You
then use the chart function created by
that first call in place of a selection. For example:

```coffeescript
myframe = d3panels.panelframe({xlim:[0,100],ylim:[0,100]})
myframe(d3.select("body"))

addpts = d3panels.add_points()
addpts(myframe, {x:[5,10,25,50,75,90], y:[8,12,50,30,80,90], group:[1,1,1,2,2,3]})
```


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
- [`histchart`](histchart.md)
- [`trichart`](trichart.md)
- [`add_curves`](add_curves.md)
- [`add_points`](add_points.md)

### LOD curve panels

- [`lodchart`](lodchart.md)
- [`lodheatmap`](lodheatmap)
- [`lod2dheatmap`](lod2dheatmap)
- [`add_lodcurve`](add_lodcurve.md)

### Control panels

- [`slider`](slider.md)
- [`double_slider`](double_slider.md)

### Other panels

- [`mapchart`](mapchart.md)
- [`crosstab`](crosstab.md)

### Utility functions

[d3panels](https://kbroman.org/d3panels) also contains some additional
utility functions plus CSS code used by the panels. These are not
documented.

- [`panelutil.coffee`](https://github.com/kbroman/d3panels/blob/master/src/panelutil.coffee)
  contains various utility functions
- [`panelutil.css`](https://github.com/kbroman/d3panels/blob/master/src/panelutil.css)
  contains CSS used by the panels

For snapshots and live tests, see <https://kbroman.org/d3panels>.

### Links

To use the code, you need link to `d3panels.js` and `d3panels.css` (or
to `d3panels.min.js` and `d3panels.min.css`):

```html
<script type="text/javascript" src="https://rawgit.com/kbroman/d3panels/master/d3panels.js"></script>
<link rel=stylesheet type="text/css" href="https://rawgit.com/kbroman/d3panels/master/d3panels.css">
```

You also need to link to [D3.js](https://d3js.org).

```html
<script charset="utf-8" type="text/javascript" src="https://d3js.org/d3.v5.min.js"></script>
```
