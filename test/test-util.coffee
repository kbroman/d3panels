QUnit.test "test unique", (assert) ->
    input = [5, 6, 7, 5, 5, 6, 7]
    output = unique(input)
    expected = [5, 6, 7]

    assert.deepEqual( output , expected)
