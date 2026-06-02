QUnit.test "padzeros", (assert) ->

    x = [5, 1, 10, 190]

    result2 = (d3panels.padzeros(v) for v in x)
    result3 = (d3panels.padzeros(v, 3) for v in x)

    assert.equal( result2.join(":"), "05:01:10:190")
    assert.equal( result3.join(":"), "005:001:010:190")
