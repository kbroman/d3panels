QUnit.test "expand2vector", (assert) ->

    assert.equal(d3panels.expand2vector(null, 5), null, "null -> null")

    assert.deepEqual(d3panels.expand2vector([8, 2, 3, 4], 3), [8, 2, 3, 4], "longer vector unchanged")

    assert.deepEqual(d3panels.expand2vector(8, 5), [8, 8, 8, 8, 8], "scalar to repeated vector")
    assert.deepEqual(d3panels.expand2vector([8], 5), [8, 8, 8, 8, 8], "vec of length 1 to repeated vector")

    assert.deepEqual(d3panels.expand2vector([8, 2], 5), [8, 2, 8, 2, 8], "longer vector repeated (1)")
    assert.deepEqual(d3panels.expand2vector([8, 2, 3], 5), [8, 2, 3, 8, 2], "longer vector repeated (2)")
    assert.deepEqual(d3panels.expand2vector([8, 2, 3], 6), [8, 2, 3, 8, 2, 3], "longer vector repeated (3)")
