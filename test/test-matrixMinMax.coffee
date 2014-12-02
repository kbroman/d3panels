QUnit.test "matrixMin, matrixMax, matrixExtent, matrixMaxAbs", (assert) ->
    x = [[null, null, 1.4], [-1, null, 5], [-8, 2, 4], [1, 2, 3]]

    assert.equal( matrixMin(x), -8 )
    assert.equal( matrixMax(x), 5 )
    assert.deepEqual( matrixExtent(x), [-8, 5] )
    assert.equal( matrixMaxAbs(x), 8 )
