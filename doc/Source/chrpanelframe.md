## `chrpanelframe`

Creates a blank frame for a chart, with the x-axis split by
chromosome.

### Example

```coffeescript
data = {chr:['1', '2', '3', '4', '5'], start:[0,0,0,0,0], end:[100, 80, 65, 50, 50]}

mychart = d3panels.chrpanelframe()
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
