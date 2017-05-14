## d3panels 1.3.3 (2017-05-13)

- Added functions `slider()` and `double_slider()`.


## d3panels 1.2.3 (2017-05-11)

- Updated for D3 version 4.


## d3panels 1.1.4 (2016-05-18)

- Add functions `trichart()`, for plotting trinomial probabilities in an
  equilateral triangle, and `histchart()`, for plotting histograms (as
  curves).

- `dotchart` can take `group` vector in data, to color points by category.

- Handle missing values in `group` in `add_curves`, `add_points`, and
  `curvechart`.

- In `add_points`, allow `pointcolor` to be longer than the number of
  groups.

- Reduce digits in example data files.

- Add more information to error messages.

- Remove a big chunk of extraneous code from `curvechart`.

- Add points() accessor to `add_curves` and `curvechart`.


## d3panels 1.0.7 (2016-05-12)

- Change accessors in `heatmap`, `lodheatmap`, and `lod2dheatmap`
  (`.cellSelect()` to `.cells()`)

- Clean up chartOpts comments

- Fix a bunch of bugs


## d3panels 1.0.4 (2016-05-09)

- New functions `add_points` and `add_curves`. (`scatterplot`
  and `curvechart` now call these two functions.)

- `panelframe` `scatterplot`, `dotchart` have additional accessors
  `.xNA()` and `.yNA()` that indicate whether missing values on the x
  and y axes are handled in separate boxes.

- Renamed some options for `curvechart`: `linecolor` and `linewidth`
  rather than `strokecolor` and `strokewidth`.

- Fix bug in `mapchart` re `linecolorhilit` option

- Depend on D3 version 3.5.17

- Include dependencies in `bower.json`


## d3panels 1.0.0 (2016-05-07)

- **Completely rewritten**, changing the functions' usage and data
  structures, and encapsulating everything into a `d3panels` object.
  See the [documentation](https://github.com/kbroman/d3panels/tree/master/doc).


## d3panels 0.6.3 (2015-11-11)

- Assign a class to the [d3-tip](https://github.com/Caged/d3-tip) tool tips.


## d3panels 0.6.2 (2015-11-10)

- Implement `chart.remove()` to avoid proliferation of tool tips.


## d3panels 0.5.3 (2015-06-24)

- Deal with changes to [d3-tip](https://github.com/Caged/d3-tip)


## d3panels 0.5.1 (2015-03-05)

- Initial release
