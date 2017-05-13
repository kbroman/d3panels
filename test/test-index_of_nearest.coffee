QUnit.test "index_of_nearest", (assert) ->

    v = [4.03076842613518, 0.182010451331735, 4.24113002372906, 3.92248374922201,
         0.381017767824233, 3.51148912170902, 4.35181264439598, 1.07710046740249,
         5.51803077897057, 2.91548915114254]

    assert.deepEqual( d3panels.index_of_nearest(4.0, v), 0 )
    assert.deepEqual( d3panels.index_of_nearest(3.2, v), 9 )
    assert.deepEqual( d3panels.index_of_nearest(1000, v), 8 )
    assert.deepEqual( d3panels.index_of_nearest(-1000, v), 1 )
    assert.deepEqual( d3panels.index_of_nearest(3.92, v), 3 )
    assert.deepEqual( d3panels.index_of_nearest(1.1, v), 7 )

    v = [1]

    assert.deepEqual( d3panels.index_of_nearest(0, v), 0 )
    assert.deepEqual( d3panels.index_of_nearest(1000, v), 0 )
    assert.deepEqual( d3panels.index_of_nearest(-1000, v), 0 )
