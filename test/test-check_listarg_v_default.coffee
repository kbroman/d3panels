QUnit.test "check_listarg_v_default", (assert) ->

    assert.deepEqual( d3panels.check_listarg_v_default({left:5}, {left:60, right:40}), {left:5, right:40})
    assert.deepEqual( d3panels.check_listarg_v_default({left:5, right:5}, {left:60, right:40}), {left:5, right:5} )
    assert.deepEqual( d3panels.check_listarg_v_default({left:5, right:5}, {left:60, right:40, inner:0}), {left:5, right:5, inner:0} )
