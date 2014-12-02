QUnit.test "formatAxis", (assert) ->
    x = [1.2, 1.3, 1.4]
    assert.equal( formatAxis(x)(4), "4.0")
    assert.equal( formatAxis(x)(4.34), "4.3")

    x = [1, 2, 3]
    assert.equal( formatAxis(x)(4), "4")
    assert.equal( formatAxis(x)(4.34), "4")

    x = [1, 2, 3]
    assert.equal( formatAxis(x, 1)(4), "4.0")
    assert.equal( formatAxis(x, 1)(4.34), "4.3")

    x = [10, 20, 30]
    assert.equal( formatAxis(x)(4), "4")
    assert.equal( formatAxis(x)(4.34), "4")
