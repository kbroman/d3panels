### Reusable crosstab panel

A reusable chart (a table, really) for making a cross-tabulation for
two variables,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

The source code is in [`crosstab.coffee`](https://github.com/kbroman/d3panels/blob/master/src/crosstab.coffee).

For an illustration of its use, see [`test_crosstab.coffee`](https://github.com/kbroman/d3panels/blob/master/test/crosstab/test_crosstab.coffee).

And see it in action
[here](http://kbroman.org/d3panels/assets/crosstab/test).

Here are all of the options:

```coffeescript
mychart = crosstab().cellHeight(30)                                            # number of pixels for height of each cell
                    .cellWidth(100)                                            # number of pixels for width of each cell
                    .margin({left:60, top:80, right:40, bottom:20})            # margins
                    .titlepos(50)                                              # spacing for panel title
                    .title("")                                                 # panel title
                    .fontsize(cellHeight*0.7)                                  # font size for values and headings
                    .rectcolor("#e6e6e6")                                      # color of shaded cells
                    .hilitcolor("#e9cfec")                                     # color of highlighted cells
                    .bordercolor("black")                                      # color of borders around main table and overall total cell
```

#### Organization of data

The data should be of the form `{x: [x1, x2, ..., xn], y:
[y1, y2, ..., yn], xcat: [xcat1, ..., xcatp], ycat:
[ycat1, ..., ycatq], xlabel: "column heading", ylabel: "row heading"}`
where the `x`'s take values in {0, 1, ..., p-1} and the
`y`'s take values in {0, 1, ..., q-1}, and `xcat` and `ycat` are
each vectors of character strings.  We assume that the last element
of each of `xcat` and `ycat` corresponds to missing values.
`xlabel` and `ylabel` are character strings for the column and row
headings, respectively.

Here's an example dataset: [`data.json`](http://kbroman.org/d3panels/assets/crosstab/test/data.json).


#### Additional accessors

There are no additional accessors at this point.