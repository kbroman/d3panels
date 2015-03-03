all: d3panels d3 d3-tip colorbrewer

# Source for d3panels

d3panels: assets/chrheatmap.js \
		  assets/cichart.js \
		  assets/crosstab.js \
		  assets/curvechart.js \
		  assets/dotchart.js \
		  assets/heatmap.js \
		  assets/lodchart.js \
		  assets/lodheatmap.js \
		  assets/mapchart.js \
		  assets/scatterplot.js \
		  assets/panelutil.js \
		  assets/panelutil.css

assets/%.js: ../src/%.js
	cp $< $(@D)/

assets/%.css: ../src/%.css
	cp $< $(@D)/

# d3 library

d3: assets/d3/d3.min.js \
	assets/d3/README.md \
	assets/d3/LICENSE

assets/d3/%: ../libs/d3/%
	cp $< $(@D)/

# d3-tip

d3-tip: assets/d3-tip/LICENSE \
		assets/d3-tip/README.md \
		assets/d3-tip/d3-tip.min.css \
		assets/d3-tip/d3-tip.min.js

assets/d3-tip/%: ../libs/d3-tip/%
	cp $< $(@D)/

# colorbrewer

colorbrewer: assets/colorbrewer/LICENSE \
			 assets/colorbrewer/README.md \
			 assets/colorbrewer/colorbrewer.js \
			 assets/colorbrewer/colorbrewer.css

assets/colorbrewer/%: ../libs/colorbrewer/%
	cp $< $(@D)/
