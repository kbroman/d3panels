all: d3panels d3 d3-tip colorbrewer testdata testjs testindex

# Source for d3panels

d3panels: assets/src/chrheatmap.js \
		  assets/src/cichart.js \
		  assets/src/crosstab.js \
		  assets/src/curvechart.js \
		  assets/src/dotchart.js \
		  assets/src/heatmap.js \
		  assets/src/lodchart.js \
		  assets/src/lodheatmap.js \
		  assets/src/mapchart.js \
		  assets/src/scatterplot.js \
		  assets/src/panelutil.js \
		  assets/src/panelutil.css

assets/src/%.js: ../src/%.js
	cp $< $(@D)/

assets/src/%.css: ../src/%.css
	cp $< $(@D)/

# d3 library

d3: assets/libs/d3/d3.min.js \
	assets/libs/d3/README.md \
	assets/libs/d3/LICENSE

assets/libs/d3/%: ../libs/d3/%
	cp $< $(@D)/

# d3-tip

d3-tip: assets/libs/d3-tip/LICENSE \
		assets/libs/d3-tip/README.md \
		assets/libs/d3-tip/index.js

assets/libs/d3-tip/%: ../libs/d3-tip/%
	cp $< $(@D)/

# colorbrewer

colorbrewer: assets/libs/colorbrewer/LICENSE \
			 assets/libs/colorbrewer/README.md \
			 assets/libs/colorbrewer/colorbrewer.js \
			 assets/libs/colorbrewer/colorbrewer.css

assets/libs/colorbrewer/%: ../libs/colorbrewer/%
	cp $< $(@D)/

# test data
testdata: assets/test/chrheatmap/data.json \
		  assets/test/cichart/data.json \
		  assets/test/crosstab/data.json \
		  assets/test/curvechart/data.json \
		  assets/test/dotchart/data.json \
		  assets/test/heatmap/data.json \
		  assets/test/lodchart/data.json \
		  assets/test/lodheatmap/data.json \
		  assets/test/mapchart/data.json \
		  assets/test/scatterplot/data.json

assets/test/%/data.json: ../test/%/data.json
	cp $< $(@D)/

# test js code
testjs: assets/test/chrheatmap/test_chrheatmap.js \
		assets/test/cichart/test_cichart.js \
		assets/test/crosstab/test_crosstab.js \
		assets/test/curvechart/test_curvechart.js \
		assets/test/dotchart/test_dotchart.js \
		assets/test/heatmap/test_heatmap.js \
		assets/test/lodchart/test_lodchart.js \
		assets/test/lodheatmap/test_lodheatmap.js \
		assets/test/mapchart/test_mapchart.js \
		assets/test/scatterplot/test_scatterplot.js

assets/test/chrheatmap/%.js: ../test/chrheatmap/%.js
	cp $< $(@D)/

assets/test/cichart/%.js: ../test/cichart/%.js
	cp $< $(@D)/

assets/test/crosstab/%.js: ../test/crosstab/%.js
	cp $< $(@D)/

assets/test/curvechart/%.js: ../test/curvechart/%.js
	cp $< $(@D)/

assets/test/dotchart/%.js: ../test/dotchart/%.js
	cp $< $(@D)/

assets/test/heatmap/%.js: ../test/heatmap/%.js
	cp $< $(@D)/

assets/test/lodchart/%.js: ../test/lodchart/%.js
	cp $< $(@D)/

assets/test/lodheatmap/%.js: ../test/lodheatmap/%.js
	cp $< $(@D)/

assets/test/mapchart/%.js: ../test/mapchart/%.js
	cp $< $(@D)/

assets/test/scatterplot/%.js: ../test/scatterplot/%.js
	cp $< $(@D)/

# test index.html
testindex: assets/test/chrheatmap/index.html \
		   assets/test/cichart/index.html \
		   assets/test/crosstab/index.html \
		   assets/test/curvechart/index.html \
		   assets/test/dotchart/index.html \
		   assets/test/heatmap/index.html \
		   assets/test/lodchart/index.html \
		   assets/test/lodheatmap/index.html \
		   assets/test/mapchart/index.html \
		   assets/test/scatterplot/index.html

assets/test/%/index.html: ../test/%/index.html
	cp $< $(@D)/
