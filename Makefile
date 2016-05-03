all: js tests testdata d3panels.js d3panels.css d3panels.min.js d3panels.min.css
.PHONY: all js tests testdata

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
	src/lodheatmap.js \
	src/mapchart.js \
	src/scatterplot.js \
	src/d3panels_bottom.js
js: $(JS)

tests: test/test-unique.js test/test-stats.js \
	   test/test-formatAxis.js test/test-pullVarAsArray.js \
	   test/test-expand2vector.js test/test-maxdiff.js \
	   test/test-matrixMinMax.js test/test-forceAsArray.js \
	   test/test-sumArray.js \
	   test/lod2dheatmap/test_lod2dheatmap.js \
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
	   test/chr2dpanelframe/test_chr2dpanelframe.js

testdata: test/lod2dheatmap/data.json \
		  test/cichart/data.json \
		  test/crosstab/data.json \
		  test/curvechart/data.json \
		  test/dotchart/data.json \
		  test/heatmap/data.json \
		  test/lodchart/data.json \
		  test/lodheatmap/data.json \
		  test/mapchart/data.json \
		  test/scatterplot/data.json


COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

src/%.js: src/%.coffee
	coffee -b ${COFFEE_ARGS} $^

test/%.js: test/%.coffee
	coffee ${COFFEE_ARGS} $^

test/%/%.js: test/%/%.coffee
	coffee ${COFFEE_ARGS} $^

test/%/data.json: test/%/create_test_data.R
	cd $(@D);R CMD BATCH --no-save $(<F)

d3panels.js: $(JS)
	cat $(JS) > $@

d3panels.css: src/panelutil.css
	cp $< $@

d3panels.min.js: $(JS)
	uglifyjs d3panels.js -o $@

d3panels.min.css: src/panelutil.css
	uglifycss $< > $@
