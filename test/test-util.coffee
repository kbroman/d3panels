QUnit.test "test unique", (assert) ->
    input = [5, 6, 7, 5, 5, 6, 7]
    output = unique(input)
    expected = [5, 6, 7]

    assert.deepEqual(output , expected, "plain")

    input = [5, 6, null, 7, 5, 5, 6, 7]
    output = unique(input)
    assert.deepEqual(output, expected, "with null")

    input = [5]
    output = unique(input)
    expected = [5]
    assert.deepEqual(output, expected, "one value")

    input = [null, null, null]
    output = unique(input)
    expected = []
    assert.deepEqual(output, expected, "only nulls")

    input = [5, 6, 5, 6, 5, 6, "a"]
    output = unique(input)
    expected = [5, 6, "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (1)")

    input = [5, 6, 5, 6, 5, "6", "a"]
    output = unique(input)
    expected = [5, "6", "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (2)")

    input = ["5", 6, 5, 6, 5, "6", "a"]
    output = unique(input)
    expected = [5, "6", "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (3)")

    input = ["5", "5",  6, "5", "6", "5", "6", "a"]
    output = unique(input)
    expected = ["5", "6", "a"]
    assert.deepEqual(output, expected, "mixed strings/integers can give weird results (4)")

QUnit.test "test stats", (assert) ->
    val = [1.0, 2.0, 3.0, -Math.sqrt(2), Math.sqrt(2)]
    grp = [1,   1,   1,   2,   2]
    exp_mean = {"1":2.0, "2":0.0}
    exp_sd = {"1":1.0, "2":2.0}
    exp_count = {"1":3, "2":2}
    exp_se = {"1":1.0/Math.sqrt(exp_count["1"]), "2":2.0/Math.sqrt(exp_count["2"])}
    exp_ci = {"1":{mean:2.0, low:2-2*exp_se["1"], high:2+2*exp_se["1"]}, "2":{mean:0.0, low:-2*exp_se["2"], high:2*exp_se["2"]}}
    assert.deepEqual( mean_by_group(grp, val), exp_mean, "means")
    assert.deepEqual( sd_by_group(grp, val), exp_sd, "SDs")
    assert.deepEqual( count_groups(grp, val), exp_count, "counts")
    assert.deepEqual( ci_by_group(grp, val), exp_ci, "CIs")

    val = [1.0, -Math.sqrt(2), 3, Math.sqrt(2), 2]
    grp = [1,   2,   1,   2,   1]
    assert.deepEqual( mean_by_group(grp, val), exp_mean, "means")
    assert.deepEqual( sd_by_group(grp, val), exp_sd, "SDs")
    assert.deepEqual( count_groups(grp, val), exp_count, "counts")
    assert.deepEqual( ci_by_group(grp, val), exp_ci, "CIs")

    val = [1.0, null, -Math.sqrt(2), 3, Math.sqrt(2), 2, null]
    grp = [1,   1, 2,   1,   2,   1, 2]
    assert.deepEqual( mean_by_group(grp, val), exp_mean, "means")
    assert.deepEqual( sd_by_group(grp, val), exp_sd, "SDs")
    assert.deepEqual( count_groups(grp, val), exp_count, "counts")
    assert.deepEqual( ci_by_group(grp, val), exp_ci, "CIs")
