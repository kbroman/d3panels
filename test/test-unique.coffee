QUnit.test "unique", (assert) ->
    input = [5, 6, 7, 5, 5, 6, 7]
    output = d3panels.unique(input)
    expected = [5, 6, 7]

    assert.deepEqual(output , expected, "plain")

    input = [5, 6, null, 7, 5, 5, 6, 7]
    output = d3panels.unique(input)
    assert.deepEqual(output, expected, "with null")

    input = [5]
    output = d3panels.unique(input)
    expected = [5]
    assert.deepEqual(output, expected, "one value")

    input = [null, null, null]
    output = d3panels.unique(input)
    expected = []
    assert.deepEqual(output, expected, "only nulls")

    input = [5, 6, 5, 6, 5, 6, "a"]
    output = d3panels.unique(input)
    expected = [5, 6, "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (1)")

    input = [5, 6, 5, 6, 5, "6", "a"]
    output = d3panels.unique(input)
    expected = [5, "6", "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (2)")

    input = ["5", 6, 5, 6, 5, "6", "a"]
    output = d3panels.unique(input)
    expected = [5, "6", "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (3)")

    input = ["5", "5",  6, "5", "6", "5", "6", "a"]
    output = d3panels.unique(input)
    expected = ["5", "6", "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (4)")
