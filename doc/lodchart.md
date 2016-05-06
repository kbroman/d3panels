## `lodchart`

Plot a lod curve.

### Example

```coffeescript
data = {chr:[1,1,1,1,2,2,2], pos:[0,5,10,20,0,8,12],lod:[0.42,1.69,1.65,2.94,0.17,0.15,0.07], marker:["1-1","1-2","","1-3","2-1","","2-2"]}

mychart = d3panels.lodchart({height:300, width:600})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `linecolor` &mdash; color for LOD curves \[default `"darkslateblue"`\]
- `linewidth` &mdash; width (pixels) for LOD curves \[default `2`\]
- `pointcolor` &mdash; e9cfec" \[default `"`\]
- `pointsize` &mdash; pointsize at markers (if 0, no points plotted) \[default `0`\]
- `pointstroke` &mdash; color of circle around points at markers \[default `"black"`\]
- `ylim` &mdash; y-axis limits; if null, use range of data \[default `null`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`chrpanelframe`](chrpanelframe.md).


### Accessors

- `linecolor()` &mdash; color for LOD curves
- `linewidth()` &mdash; width (pixels) for LOD curves
- `pointcolor()` &mdash; e9cfec"
- `pointsize()` &mdash; pointsize at markers (if 0, no points plotted)
- `pointstroke()` &mdash; color of circle around points at markers
- `ylim()` &mdash; y-axis limits; if null, use range of data
- `tipclass()` &mdash; class name for tool tips

Use these like:

```coffeescript
mychart = d3panels.lodchart()
mychart(d3.select("body"), data)
linecolor = mychart.linecolor()
```

