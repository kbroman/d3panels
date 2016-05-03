QUnit.test "matrixMin, matrixMax, matrixExtent, matrixMaxAbs", (assert) ->
    x = [[null, null, 1.4], [-1, null, 5], [-8, 2, 4], [1, 2, 3]]

    assert.equal( d3panels.matrixMin(x), -8 )
    assert.equal( d3panels.matrixMax(x), 5 )
    assert.deepEqual( d3panels.matrixExtent(x), [-8, 5] )
    assert.equal( d3panels.matrixMaxAbs(x), 8 )
