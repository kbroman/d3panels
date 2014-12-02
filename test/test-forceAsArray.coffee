QUnit.test "forceAsArray", (assert) ->
    assert.equal( forceAsArray(null), null)
    assert.deepEqual( forceAsArray(5), [5])
    assert.deepEqual( forceAsArray([null]), [null])
    assert.deepEqual( forceAsArray([5, 6, 7]), [5, 6, 7])
    assert.deepEqual( forceAsArray("5"), ["5"])
    assert.deepEqual( forceAsArray(["5"]), ["5"])
