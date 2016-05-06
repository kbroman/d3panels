## `panelframe`

Creates a blank frame for a chart; used by [`dotchart`](dotchart.md),
[`scatterplot`](scatterplot.md), [`curvechart`](curvechart.md),
[`cichart`](cichart.md), and [`heatmap`](heatmap.md).

### Data

This function takes no data.

### Example

```coffeescript
mychart = d3panels.panelframe({xlim:[0,100], ylim:[0,5]})
mychart(d3.select('body'))
```

**insert_chartOpts**

**insert_accessors**
