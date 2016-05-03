QUnit.test "pad_vector", (assert) ->

    x = [1, 2, 3, 4, 5]
    assert.deepEqual(d3panels.pad_vector(x), [0,1,2,3,4,5,6], "simplest use")
    assert.deepEqual(d3panels.pad_vector(x, 0.5), [0.5, 1, 2, 3, 4, 5, 5.5], "include pad value")

    x = [1, 2.5, 3.3, 4.7, 5.1]

    # screw around due to round-off error
    obs = d3panels.pad_vector(x)
    exp = [-0.5,1,2.5,3.3,4.7,5.1,5.5]
    maxd = d3.max(Math.abs(exp[i] - obs[i]) for i of obs)
    assert.equal(maxd < 1e-15, true, "unequal spacing")

    assert.deepEqual(d3panels.pad_vector(x, 0.5), [0.5, 1, 2.5, 3.3, 4.7, 5.1, 5.6], "unequal spacing, pad value")
