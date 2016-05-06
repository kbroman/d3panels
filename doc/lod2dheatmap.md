## `lod2dheatmap`

Plot a heatmap of a set of lod scores for a two-dimensional scan. Can
also be used to plot estimated recombination fractions for all marker pairs.

### Data

The data is an associative array containing
- `chr` &mdash; vector of chromosome IDs (length `m`)
- `pos` &mdash; vector of positions (length `m`)
- `lod` &mdash; matrix of LOD scores, indexed as
  `lod[pos_x][pos_y]` with dimension `m` &times; `m`

Optionally, the data can also contain:
- `poslabel` &mdash; Same length as `data.chr`, with labels for the
  positions (length `m`)
- `chrname` &mdash; vector of distinct chromosome IDs
- `chrstart` &mdash; starting positions for the chromosomes
- `chrend` &mdash; ending positions for the chromosomes

### Example

```coffeescript
data = {chr:[1,1,1,1,2,2,2], pos:[0,5,10,20,0,8,12], lod:[[null,11.4,3.1,0.6,0.3,0,0.2],[11.4,null,9.9,0.6,0.1,0,0.1],[3.1,9.9,null,2.9,0,0.2,0],[0.6,0.6,2.9,null,1.8,0.6,0.1],[0.3,0.1,0,1.8,null,10.7,9.2],[0,0,0.2,0.6,10.7,null,14],[0.2,0.1,0,0.1,9.2,14,null]]}

mychart = d3panels.lod2dheatmap({equalCells:true})
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `width` &mdash; overall height of chart in pixels \[default `800`\]
- `height` &mdash; overall width of chart in pixels \[default `800`\]
- `margin` &mdash; margins in pixels (left, top, right, bottom) \[default `{left:60, top:40, right:40, bottom: 60}`\]
- `chrGap` &mdash; gap between chromosomes in pixels \[default `6`\]
- `equalCells` &mdash; if true, make all cells equal-sized; in this case, chartOpts.chrGap is ignored \[default `false`\]
- `oneAtTop` &mdash; if true, put chromosome 1 at the top rather than bottom \[default `false`\]
- `colors` &mdash; vector of three colors for the color scale (negative - zero - positive) \[default `["slateblue", "white", "crimson"]`\]
- `nullcolor` &mdash; e6e6e6" \[default `"`\]
- `zlim` &mdash; z-axis limits (if null take from data, symmetric about 0) \[default `null`\]
- `zthresh` &mdash; z threshold; if |z| < zthresh, not shown \[default `null`\]
- `hilitcolor` &mdash; color of box around highlighted cell \[default `"black"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]

You can also use the chart options for [`chr2dpanelframe`](chr2dpanelframe.md).


### Accessors

- `xscale()` &mdash; x-axis scale (vector by chromosome)
- `yscale()` &mdash; y-axis scale (vector by chromosome)
- `zscale()` &mdash; z-axis scale
- `celltip()` &mdash; cell tooltip selection
- `cellSelect()` &mdash; cell selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.lod2dheatmap()
mychart(d3.select("body"), data)
xscale = mychart.xscale()
```

