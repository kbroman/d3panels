## `mapchart`

Plot a genetic marker map.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `chr` &mdash; chromosome IDs
- `pos` &mdash; marker positions
- `marker` &mdash; marker names

Optionally, you can also include `data.chrname`, a vector of distinct
chromosome IDs.

### Example

```coffeescript
data = {chr:['1','1','1','1','2','2','2'],pos:[0,5,15,20,0,10,30],marker:['m1','m2','m3','m4','m5','m6','m7']}

mychart = d3panels.mapchart({height:300,width:250})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `tickwidth` &mdash; width of ticks at markers \[default `10`\]
- `linecolor` &mdash; line color \[default `"slateblue"`\]
- `linecolorhilit` &mdash; line color when highlighted \[default `"Orchid"`\]
- `linewidth` &mdash; line width (pixels) \[default `3`\]
- `xlab` &mdash; x-axis label \[default `"Chromosome"`\]
- `ylab` &mdash; y-axis label \[default `"Position (cM)"`\]
- `xlineOpts` &mdash; cdcdcd", width:5} \[default `{color:"`\]
- `horizontal` &mdash; whether chromosomes should be laid at horizontally \[default `false`\]
- `v_over_h` &mdash; whether vertical lines should be on top of horizontal lines \[default `horizontal`\]
- `shiftStart` &mdash; if true, shift start of chromosomes to 0 \[default `false`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`panelframe`](panelframe.md).


### Accessors

- `xscale()` &mdash; x-axis scale
- `yscale()` &mdash; y-axis scale
- `markerSelect()` &mdash; marker segment selection
- `martip()` &mdash; marker tool tip selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.mapchart()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

