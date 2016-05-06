## `chrpanelframe`

Creates a blank frame for a chart, with the x-axis split by
chromosome.

### Example

```coffeescript
data = {chr:['1', '2', '3', '4', '5'], start:[0,0,0,0,0], end:[100, 80, 65, 50, 50]}

mychart = d3panels.chrpanelframe()
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `width` &mdash; overall height of chart in pixels (default `800`)
- `height` &mdash; overall width of chart in pixels (default `500`)
- `margin` &mdash; margins in pixels (left, top, right, bottom) (default `{left:60, top:40, right:40, bottom: 40}`)
- `axispos` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) (default `{xtitle:25, ytitle:45, xlabel:5, ylabel:5}`)
- `titlepos` &mdash; position of chart title in pixels (default `20`)
- `title` &mdash; chart title (default `""`)
- `xlab` &mdash; x-axis label (default `"Chromosome"`)
- `ylab` &mdash; y-axis label (default `"LOD score"`)
- `rotate_ylab` &mdash; whether to rotate the y-axis label (default `null`)
- `ylim` &mdash; y-axis limits (default `[0,1]`)
- `nyticks` &mdash; no. ticks on y-axis (default `5`)
- `yticks` &mdash; vector of tick positions on y-axis (default `null`)
- `yticklab` &mdash; vector of y-axis tick labels (default `null`)
- `rectcolor` &mdash; e6e6e6" (default `"`)
- `altrectcolor` &mdash; d4d4d4" (default `"`)
- `chrlinecolor` &mdash; color of lines between chromosomes (if "", leave off) (default `""`)
- `chrlinewidth` &mdash; width of lines between chromosomes (default `2`)
- `boxcolor` &mdash; color of outer rectangle box (default `"black"`)
- `boxwidth` &mdash; width of outer box in pixels (default `2`)
- `ylineOpts` &mdash; color and width of horizontal lines (default `{color:"white", width:2}`)
- `chrGap` &mdash; gap between chromosomes in pixels (default `6`)
- `horizontal` &mdash; if true, chromosomes on vertical axis (xlab, ylab, etc stay the same) (default `false`)


### Accessors

- `width()` &mdash; overall height of chart in pixels
- `height()` &mdash; overall width of chart in pixels
- `margin()` &mdash; margins in pixels (left, top, right, bottom)
- `axispos()` &mdash; position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
- `titlepos()` &mdash; position of chart title in pixels
- `title()` &mdash; chart title
- `xlab()` &mdash; x-axis label
- `ylab()` &mdash; y-axis label
- `rotate_ylab()` &mdash; whether to rotate the y-axis label
- `ylim()` &mdash; y-axis limits
- `nyticks()` &mdash; no. ticks on y-axis
- `yticks()` &mdash; vector of tick positions on y-axis
- `yticklab()` &mdash; vector of y-axis tick labels
- `rectcolor()` &mdash; e6e6e6"
- `altrectcolor()` &mdash; d4d4d4"
- `chrlinecolor()` &mdash; color of lines between chromosomes (if "", leave off)
- `chrlinewidth()` &mdash; width of lines between chromosomes
- `boxcolor()` &mdash; color of outer rectangle box
- `boxwidth()` &mdash; width of outer box in pixels
- `ylineOpts()` &mdash; color and width of horizontal lines
- `chrGap()` &mdash; gap between chromosomes in pixels
- `horizontal()` &mdash; if true, chromosomes on vertical axis (xlab, ylab, etc stay the same)

Use these like:

```coffeescript
mychart = d3panels.chrpanelframe()
mychart(d3.select("body"), data)
width = mychart.width()
```

