QUnit.test "calc_midpoints", (assert) ->

    x = [1, 2, 3, 4, 5]
    out = [1.5, 2.5, 3.5, 4.5]
    assert.deepEqual(d3panels.calc_midpoints(x), out, "simplest use")

    x = [-2.5, 1.0, 3.6, 4.9, 8.2, 11.2, 12.0, 13.4]
    out = [-0.75, 2.30, 4.25, 6.55, 9.70, 11.60, 12.70]
    assert.deepEqual(d3panels.calc_midpoints(x), out, "floats")

    x = [-2.5, 1.0]
    out = [-0.75]
    assert.deepEqual(d3panels.calc_midpoints(x), out, "two values")
