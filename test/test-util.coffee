QUnit.test "test unique", (assert) ->
    input = [5, 6, 7, 5, 5, 6, 7]
    output = unique(input)
    expected = [5, 6, 7]

    assert.ok( _.isEqual( output , expected), "unique() passed")
