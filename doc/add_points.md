## `add_points`

Add points to a [`panelframe`](panelframe.md) or
[`scatterplot`](scatterplot.md) chart.

After setup with chart options, use the *original chart function* (rather than a
selection) as the first argument.

### Data

The data is an associative array with a set of vectors, all of the same length:
- `x` &mdash; x variable
- `y` &mdash; y variable
- `indID` &mdash; individual IDs (optional)
- `group` &mdash; category in 1,2,3,... (for determining point color, optional)

### Example

```coffeescript
data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}

myframe = d3panels.panelframe({height:300, width:500, xlim:[5,17], ylim:[8.3,32.9]})
myframe(d3.select('body'))

add_points = d3panels.add_points({pointsize:4})
add_points(myframe, data)
```

### Chart options (`chartOpts`)

- `pointcolor` &mdash; fill color of points \[default `null`\]
- `pointsize` &mdash; size of points \[default `3`\]
- `pointstroke` &mdash; color of points' outer circle \[default `"black"`\]
- `jitter` &mdash; method for jittering NA points (beeswarm|random|none) \[default `"beeswarm"`\]
- `tipclass` &mdash; class name for tool tips \[default `"tooltip"`\]


### Accessors

- `points()` &mdash; points selection
- `indtip()` &mdash; tooltip selection

