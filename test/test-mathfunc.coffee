QUnit.test "mathfunc: log2, log10, abs", (assert) ->

    assert.equal(d3panels.log2(null), null, "log2 null")
    assert.equal(d3panels.log2(1.0), 0.0, "log2(1)")
    assert.equal(d3panels.log2(2.0), 1.0, "log2(2)")
    assert.equal(d3panels.log2(4.0), 2.0, "log2(4)")
    assert.equal(d3panels.log2(0.5), -1.0, "log2(0.5)")

    assert.equal(d3panels.log10(null), null, "log10 null")
    assert.equal(d3panels.log10(1.0), 0.0, "log10(1)")
    assert.equal(d3panels.log10(10.0), 1.0, "log10(10)")
    assert.equal(d3panels.log10(100.0), 2.0, "log10(100)")
    # deal with round-off error in this one
    assert.equal(d3panels.log10(0.1) + 1.0 < 1e-12, true, "log10(0.1)")


    assert.equal(d3panels.abs(null), null, "abs null")
    assert.equal(d3panels.abs(1.0), 1.0, "abs(1)")
    assert.equal(d3panels.abs(-1.0), 1.0, "abs(-1)")
    assert.equal(d3panels.abs(10.5), 10.5, "abs(10.5)")
    assert.equal(d3panels.abs(-10.5), 10.5, "abs(-10.5)")
    assert.equal(d3panels.abs(0.0), 0.0, "abs(-10.5)")
