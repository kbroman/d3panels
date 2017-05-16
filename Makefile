all: js tests testdata d3panels.js d3panels.css d3panels.min.js d3panels.min.css docs
.PHONY: all js tests testdata docs

# javascript files
JS= src/d3panels_top.js \
	src/panelutil.js \
	src/lod2dheatmap.js \
	src/panelframe.js \
	src/chrpanelframe.js \
	src/chr2dpanelframe.js \
	src/cichart.js \
	src/crosstab.js \
	src/curvechart.js \
	src/dotchart.js \
	src/heatmap.js \
	src/lodchart.js \
	src/add_lodcurve.js \
	src/add_curves.js \
	src/add_points.js \
	src/lodheatmap.js \
	src/mapchart.js \
	src/scatterplot.js \
	src/trichart.js \
	src/histchart.js \
	src/slider.js \
	src/double_slider.js \
	src/d3panels_bottom.js
js: $(JS)

# javascript files for the tests
TESTS = test/test-unique.js test/test-stats.js \
		test/test-formatAxis.js test/test-pullVarAsArray.js \
		test/test-expand2vector.js test/test-maxdiff.js \
		test/test-matrixMinMax.js test/test-forceAsArray.js \
		test/test-sumArray.js test/test-pad_vector.js \
		test/test-missing2null.js test/test-calc_midpoints.js \
		test/test-mathfunc.js test/test-reorgByChr.js \
		test/test-reorgLodData.js test/test-calc_freq.js \
		test/test-index_of_nearest.js \
		test/lod2dheatmap/test_lod2dheatmap.js \
		test/add_curves/test_add_curves.js \
		test/add_points/test_add_points.js \
		test/cichart/test_cichart.js \
		test/crosstab/test_crosstab.js \
		test/curvechart/test_curvechart.js \
		test/dotchart/test_dotchart.js \
		test/heatmap/test_heatmap.js \
		test/lodchart/test_lodchart.js \
		test/lodheatmap/test_lodheatmap.js \
		test/mapchart/test_mapchart.js \
		test/scatterplot/test_scatterplot.js \
		test/panelframe/test_panelframe.js \
		test/chrpanelframe/test_chrpanelframe.js \
		test/chr2dpanelframe/test_chr2dpanelframe.js \
		test/trichart/test_trichart.js \
		test/histchart/test_histchart.js \
		test/slider/test_slider.js \
		test/double_slider/test_double_slider.js
tests: $(TESTS)

# data files for the tests
TESTDATA = test/lod2dheatmap/data.json \
		   test/cichart/data.json \
		   test/crosstab/data.json \
		   test/curvechart/data.json \
		   test/add_curves/data.json \
		   test/add_points/data.json \
		   test/dotchart/data.json \
		   test/heatmap/data.json \
		   test/lodchart/data.json \
		   test/lodheatmap/data.json \
		   test/mapchart/data.json \
		   test/scatterplot/data.json
testdata: $(TESTDATA)

# documentation
DOCS = doc/add_lodcurve.md \
	   doc/add_curves.md \
	   doc/add_points.md \
	   doc/chrpanelframe.md \
	   doc/chr2dpanelframe.md \
	   doc/cichart.md \
	   doc/crosstab.md \
	   doc/curvechart.md \
	   doc/dotchart.md \
	   doc/heatmap.md \
	   doc/lodchart.md \
	   doc/lodheatmap.md \
	   doc/lod2dheatmap.md \
	   doc/mapchart.md \
	   doc/panelframe.md \
	   doc/scatterplot.md \
	   doc/trichart.md \
	   doc/histchart.md \
	   doc/slider.md \
	   doc/double_slider.md
docs: $(DOCS)

# arguments to use when compiling coffeescript -> javascript
COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

# compiling main javascript files
src/%.js: src/%.coffee
	coffee -b ${COFFEE_ARGS} $^

# compiling javascript files for tests
test/%.js: test/%.coffee
	coffee ${COFFEE_ARGS} $^

# compiling the javascript files for tests of the panels
test/%/%.js: test/%/%.coffee
	coffee ${COFFEE_ARGS} $^

# creating the test data
test/%/data.json: test/%/create_test_data.R
	cd $(@D);R CMD BATCH --no-save $(<F)

# adding chartOpts and accessors to documentation files
doc/%.md: doc/Source/add_opts_to_doc.rb doc/Source/%.md src/%.coffee
	cd $(<D);$(<F) $*

# combining the javascript files
d3panels.js: $(JS)
	cat $(JS) > $@

# renaming and moving the CSS file
d3panels.css: src/panelutil.css
	cp $< $@

# minimizing the main javascript file
d3panels.min.js: d3panels.js
	uglifyjs $< -o $@

# minimizing the CSS file
d3panels.min.css: d3panels.css
	uglifycss $< > $@

clean:
	rm d3panels.js d3panels.css d3panels.min.js src/[a-c]*.js arc/[d-z]*.js test/*.js test/*/*.js doc/[a-z]*.md
