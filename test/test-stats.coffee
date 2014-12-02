QUnit.test "stats", (assert) ->
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

    assert.equal( median(null), null, "median of null")
    assert.equal( median([null]), null, "median of null")
    assert.equal( median([null, null]), null, "median of null")
    assert.equal( median([]), null, "median of null")

    assert.equal( median([1, 2, 1.5, 88, 2.5]), 2, "median (1)")
    assert.equal( median([1, 2, 1.5, 2.5]), 1.75, "median (2)")
    assert.equal( median([1, null, 2, 1.5, 88, 2.5, null]), 2, "median w/ nulls (1)")
    assert.equal( median([1, null, 2, 1.5, 2.5, null]), 1.75, "median w/ nulls (2)")
