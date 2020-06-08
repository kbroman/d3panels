all: d3panels d3 testdata testjs testindex
.PHONY: all d3panels d3 testdata testjs testindex

# Source for d3panels
d3panels: assets/d3panels.js \
		  assets/d3panels.css \
		  assets/d3panels.min.js \
		  assets/d3panels.min.css

assets/%.js: ../%.js
	cp $< $(@D)/

assets/%.css: ../%.css
	cp $< $(@D)/

# d3 library
d3: assets/bower_components/d3/d3.min.js \
	assets/bower_components/d3/README.md \
	assets/bower_components/d3/LICENSE

assets/bower_components/d3/%: ../bower_components/d3/%
	cp $< $(@D)/

# test data
TESTDATA = assets/test/cichart/data.json \
		   assets/test/crosstab/data.json \
		   assets/test/curvechart/data.json \
		   assets/test/dotchart/data.json \
		   assets/test/heatmap/data.json \
		   assets/test/heatmap/data_categorical.json \
		   assets/test/heatmap/data_unequal.json \
		   assets/test/lod2dheatmap/data.json \
		   assets/test/lodchart/data.json \
		   assets/test/lodheatmap/data.json \
		   assets/test/mapchart/data.json \
		   assets/test/scatterplot/data.json
testdata: $(TESTDATA)

assets/test/%/data.json: ../test/%/data.json
	cp $< $(@D)/

assets/test/heatmap/data_%.json: ../test/heatmap/data_%.json
	cp $< $(@D)/

# test js code
TESTJS = assets/test/chr2dpanelframe/test_chr2dpanelframe.js \
		 assets/test/chrpanelframe/test_chrpanelframe.js \
		 assets/test/cichart/test_cichart.js \
		 assets/test/crosstab/test_crosstab.js \
		 assets/test/curvechart/test_curvechart.js \
		 assets/test/dotchart/test_dotchart.js \
		 assets/test/heatmap/test_heatmap.js \
		 assets/test/lod2dheatmap/test_lod2dheatmap.js \
		 assets/test/lodchart/test_lodchart.js \
		 assets/test/lodheatmap/test_lodheatmap.js \
		 assets/test/mapchart/test_mapchart.js \
		 assets/test/panelframe/test_panelframe.js \
		 assets/test/scatterplot/test_scatterplot.js \
		 assets/test/trichart/test_trichart.js \
		 assets/test/histchart/test_histchart.js \
		 assets/test/slider/test_slider.js \
		 assets/test/double_slider/test_double_slider.js
testjs: $(TESTJS)

assets/test/%/%.js: ../test/%/%.js
	cp $< $(@D)/

# test index.html
TESTINDEX = assets/test/chr2dpanelframe/index.html \
			assets/test/chrpanelframe/index.html \
			assets/test/cichart/index.html \
			assets/test/crosstab/index.html \
			assets/test/curvechart/index.html \
			assets/test/dotchart/index.html \
			assets/test/heatmap/index.html \
			assets/test/lod2dheatmap/index.html \
			assets/test/lodchart/index.html \
			assets/test/lodheatmap/index.html \
			assets/test/mapchart/index.html \
			assets/test/panelframe/index.html \
			assets/test/scatterplot/index.html \
			assets/test/trichart/index.html \
			assets/test/histchart/index.html \
			assets/test/slider/index.html \
			assets/test/double_slider/index.html
testindex: $(TESTINDEX)

assets/test/%/index.html: ../test/%/index.html
	cp $< $(@D)/
