## `crosstab`

Display a cross-tabulation (in other words, a two-way table)

### Data

The data is a hash with two vectors of the same length:
- `x` &mdash; vector of x values in 1,2,... (rows in the table)
- `y` &mdash; vector of y values in 1,2,... (columns in the table)

For each of `data.x` and `data.y`, the largest value is presumed to
correspond to the missing values (N/A).

Optionally, include
- `xcat` &mdash; Vector of labels for the _x_ categories
- `ycat` &mdash; Vector of labels for the _y_ categories
- `xlabel` &mdash; Label (name) for the _x_ variable
- `ylabel` &mdash; Label (name) for the _y_ variable

### Example

```coffeescript
data = {x:[1,3,1,1,3,1,1,3,1,3], y:[1,3,1,3,2,1,1,2,2,2]}

mychart = d3panels.crosstab()
mychart(d3.select('body'), data)
```

### Chart options (`chartOpts`)

- `width` &mdash; overall width of chart in pixels \[default `600`\]
- `height` &mdash; overall height of chart in pixels \[default `300`\]
- `margin` &mdash; margins in pixels \[default `{left:60, top:80, right:40, bottom: 20}`\]
- `cellPad` &mdash; padding of cells (if null, we take cell width * 0.1 \[default `null`\]
- `titlepos` &mdash; position of title in pixels \[default `50`\]
- `title` &mdash; chart title \[default `""`\]
- `fontsize` &mdash; font size (if null, we take cell height * 0.5) \[default `null`\]
- `rectcolor` &mdash; e6e6e6" \[default `"`\]
- `hilitcolor` &mdash; e9cfec" \[default `"`\]
- `bordercolor` &mdash; color of borders \[default `"black"`\]


### Accessors

- `rowrect()` &mdash; row header rectangle selection
- `colrect()` &mdash; col header rectangle selection
- `svg()` &mdash; SVG selection

Use these like this:

```coffeescript
mychart = d3panels.crosstab()
mychart(d3.select("body"), data)
rowrect = mychart.rowrect()
```

