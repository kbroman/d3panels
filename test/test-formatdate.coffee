QUnit.test "dateformat", (assert) ->

    x = new Date("2026-06-02T16:01:30+00:00")

    assert.equal( d3panels.formatdate(x), "2026-06-02")
    assert.equal( d3panels.formattime(x), "16:01")
    assert.equal( d3panels.formatdatetime(x), "16:01 2026-06-02")
