QUnit.test "missing2null", (assert) ->

    x = [1, 2, 3, 4, 5]
    assert.deepEqual(d3panels.missing2null(x), x, "no NAs")

    x = [1, 2, null, 4, 5, null, -5.3, "hello"]
    assert.deepEqual(d3panels.missing2null(x), x, "no NAs; some nulls")

    y = [1, 2, null, 4, 5, "NA", -5.3, "hello"]
    assert.deepEqual(d3panels.missing2null(y), x, "one NA")

    z = [1, 2, null, 4, 5, "NA", -5.3, "hello"]
    zout = [1, 2, null, 4, 5, null, -5.3, null]
    assert.deepEqual(d3panels.missing2null(y, ['NA', '', 'hello']), zout, "special missingvalues")
