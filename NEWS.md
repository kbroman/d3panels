## d3panels 1.8.5 (2025-05-09)

- Now using D3 7.9.0


## d3panels 1.8.4 (2022-01-07)

- Further tweaks to `formatAxis()` to avoid an Infinity error.


## d3panels 1.8.2 (2022-01-07)

- Remove some debug code


## d3panels 1.8.1 (2022-01-07)

- Revised `formatAxis()` to consider all gaps rather than just the gap
  between the first two values.


## d3panels 1.8.0 (2021-08-04)

- Revised to use D3 v7. Main changes concern `d3.event` and `.on()`,
  particularly `.on("mouseover", (d,i) -> )`
  See the [D3 6.0 migration
  guide](https://observablehq.com/@d3/d3v6-migration-guide).


## d3panels 1.7.1 (2021-07-20)

- Handle a single data point in trichart; try to do the same thing in
  add_points, add_curves, dotchart


## d3panels 1.6.4 (2020-06-08)

- Implemented custom tool tips in order to drop the
  [d3-tip]http://labratrevenge.com/d3-tip) library, which is no longer
  being maintained.

- Revised to use D3 v5; only real change was in the test code which
  uses `d3.json()` to load data.

- Dropped the dependency on
  [colorbrewer](https://github.com/jeanlauliac/colorbrewer).
  This is now built into D3 v5, but I ended up just hard-coding the
  palettes I wanted, so that the library still works with D3 v4.


## d3panels 1.5.0 (2020-06-05)

- Added option for grid lines in `trichart()`


## d3panels 1.4.9 (2019-02-04)

- Fixed bug in `dotchart()` re having a single group.

- Compiling coffeescript to ES5

- Using [yarn](https://yarnpkg.com) rather than [bower](https://bower.io)


## d3panels 1.3.7 (2017-05-18)

- Added functions `slider()` and `double_slider()`.

- `chrpanelframe` (and so also `lodchart` and `lodheatmap`) adds
  quantitative scale for position on the x-axis (plus grid lines) if
  there is just one chromosome.

- Ensure that list arguments have all the necessary bits
  (e.g. `margin.inner` in `plotframe`),
  with new utility function `check_listarg_v_default`

- In `dotchart` and `add_points`, just run 30 steps of the force
  simulation.


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
  See the [documentation](https://github.com/kbroman/d3panels/tree/main/doc).


## d3panels 0.6.3 (2015-11-11)

- Assign a class to the [d3-tip](https://github.com/Caged/d3-tip) tool tips.


## d3panels 0.6.2 (2015-11-10)

- Implement `chart.remove()` to avoid proliferation of tool tips.


## d3panels 0.5.3 (2015-06-24)

- Deal with changes to [d3-tip](https://github.com/Caged/d3-tip)


## d3panels 0.5.1 (2015-03-05)

- Initial release
