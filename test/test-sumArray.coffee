QUnit.test "sumArray, rowSums, colSums, transpose", (assert) ->
    assert.equal( d3panels.sumArray([null, 5, 6, -2, 3, 8]), 20 )
    assert.equal( d3panels.sumArray([2]), 2 )
    assert.equal( d3panels.sumArray([null, 1]), 1 )
    assert.equal( d3panels.sumArray([1, null]), 1 )
    # if no non-null values, return null
    assert.equal( d3panels.sumArray([null]), null)
    assert.equal( d3panels.sumArray([null, null]), null)

    x = [[null, null, 1.4], [-1, null, 5], [-8, 2, 4], [1, 2, 3]]
    xt = [[null, -1, -8, 1], [null, null, 2, 2], [1.4, 5, 4, 3]]

    assert.deepEqual( d3panels.transpose(x), xt, "transpose (1)")
    assert.deepEqual( d3panels.transpose(xt), x, "transpose (2)")

    assert.deepEqual( d3panels.rowSums(x), [1.4, 4, -2, 6])
    assert.deepEqual( d3panels.colSums(x), [-8, 4, 13.4])

    assert.deepEqual( d3panels.colSums(xt), [1.4, 4, -2, 6])
    assert.deepEqual( d3panels.rowSums(xt), [-8, 4, 13.4])
