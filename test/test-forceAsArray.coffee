QUnit.test "forceAsArray", (assert) ->
    assert.equal( d3panels.forceAsArray(null), null)
    assert.deepEqual( d3panels.forceAsArray(5), [5])
    assert.deepEqual( d3panels.forceAsArray([null]), [null])
    assert.deepEqual( d3panels.forceAsArray([5, 6, 7]), [5, 6, 7])
    assert.deepEqual( d3panels.forceAsArray("5"), ["5"])
    assert.deepEqual( d3panels.forceAsArray(["5"]), ["5"])
