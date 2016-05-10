## d3panels 1.0.4

- New functions `add_points` and `add_curves`. (`scatterplot`
  and `curveschart` now call these two functions.)

- `panelframe` `scatterplot`, `dotchart` have additional accessors
  `.xNA()` and `.yNA()` that indicate whether missing values on the x
  and y axes are handled in separate boxes.

- Renamed some options for `curvechart`: `linecolor` and `linewidth`
  rather than `strokecolor` and `strokewidth`.


## d3panels 1.0.3

- Fix bug in `mapchart` re `linecolorhilit` option


## d3panels 1.0.2

- Depend on D3 version 3.5.17


## d3panels 1.0.1

- Include dependencies in `bower.json`


## d3panels 1.0.0

- **Completely rewritten**, changing the functions' usage and data
  structures, and encapsulating everything into a `d3panels` object.
  See the [documentation](https://github.com/kbroman/d3panels/tree/master/doc).


## d3panels 0.6.3

- Assign a class to the [d3-tip](https://github.com/Caged/d3-tip) tool tips.


## d3panels 0.6.2

- Implement `chart.remove()` to avoid proliferation of tool tips.


## d3panels 0.5.3

- Deal with changes to [d3-tip](https://github.com/Caged/d3-tip)


## d3panels 0.5.1

- Initial release
