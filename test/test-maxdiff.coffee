QUnit.test "maxdiff", (assert) ->
    x = [1.2, 1.3, 1.5, 2.0, 1.9, 2.3]
    assert.equal( maxdiff(x), 0.5 )

    x = [1, 2, 3]
    assert.equal( maxdiff(x), 1.0 )

    x = [10, 25, 30]
    assert.equal( maxdiff(x), 15 )

    x = [5]
    assert.equal( maxdiff(x), null )
