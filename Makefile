all: JS tests
JS: src/panelutil.js
tests: test/test-unique.js test/test-stats.js test/test-formatAxis.js test/test-pullVarAsArray.js test/test-expand2vector.js test/test-maxdiff.js test/test-matrixMinMax.js test/test-forceAsArray.js test/test-sumArray.js
.PHONY: JS tests all

COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

src/%.js: src/%.coffee
	coffee -b ${COFFEE_ARGS} $^

test/%.js: test/%.coffee
	coffee ${COFFEE_ARGS} $^
