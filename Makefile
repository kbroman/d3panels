all: assets/chrheatmap.js \
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
