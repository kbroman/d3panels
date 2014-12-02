JS: src/util.js test/test-util.js
.PHONY: JS

COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

src/%.js: src/%.coffee
	coffee -b ${COFFEE_ARGS} $^

test/%.js: test/%.coffee
	coffee ${COFFEE_ARGS} $^
