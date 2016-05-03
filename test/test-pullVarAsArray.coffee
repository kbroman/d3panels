QUnit.test "pullVarAsArray", (assert) ->
    data = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    assert.deepEqual( d3panels.pullVarAsArray(data, 0), [1, 4, 7, 10] )
    assert.deepEqual( d3panels.pullVarAsArray(data, 1), [2, 5, 8, 11] )
    assert.deepEqual( d3panels.pullVarAsArray(data, 2), [3, 6, 9, 12] )

    data = [{"x":1, "y":2, "z":3}, {"x":4, "y":5, "z":6}, {"x":7, "y":8,"z":9}, {"x":10, "y":11, "z":12}]
    assert.deepEqual( d3panels.pullVarAsArray(data, "x"), [1, 4, 7, 10] )
    assert.deepEqual( d3panels.pullVarAsArray(data, "y"), [2, 5, 8, 11] )
    assert.deepEqual( d3panels.pullVarAsArray(data, "z"), [3, 6, 9, 12] )
