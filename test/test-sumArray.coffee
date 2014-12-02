QUnit.test "sumArray, rowSums, colSums, transpose", (assert) ->
    assert.equal( sumArray([null, 5, 6, -2, 3, 8]), 20 )
    assert.equal( sumArray([2]), 2 )
    assert.equal( sumArray([null, 1]), 1 )
    assert.equal( sumArray([1, null]), 1 )
    # if no non-null values, return null
    assert.equal( sumArray([null]), null)
    assert.equal( sumArray([null, null]), null)

    x = [[null, null, 1.4], [-1, null, 5], [-8, 2, 4], [1, 2, 3]]
    xt = [[null, -1, -8, 1], [null, null, 2, 2], [1.4, 5, 4, 3]]

    assert.deepEqual( transpose(x), xt, "transpose (1)")
    assert.deepEqual( transpose(xt), x, "transpose (2)")

    assert.deepEqual( rowSums(x), [1.4, 4, -2, 6])
    assert.deepEqual( colSums(x), [-8, 4, 13.4])

    assert.deepEqual( colSums(xt), [1.4, 4, -2, 6])
    assert.deepEqual( rowSums(xt), [-8, 4, 13.4])
