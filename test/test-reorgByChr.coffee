QUnit.test "reorgByChr", (assert) ->

    uchr = ['1', '2', 'X']
    chr = ['1', '1', '1', '1', '2', '2', '2', 'X', 'X', 'X']
    pos = [0, 10.5, 20.5, 30, 3.2, 4.2, 5.2, -10, 11, 100.2]
    out = {
        '1':[0, 10.5, 20.5, 30]
        '2':[3.2, 4.2, 5.2]
        'X':[-10, 11, 100.2]}

    assert.deepEqual(d3panels.reorgByChr(uchr, chr, pos), out, 'simplest use')


    uchr = ['1']
    chr = ['1', '1', '1', '1']
    pos = [0, 10.5, 20.5, 30]
    out = {
        '1':[0, 10.5, 20.5, 30]}

    assert.deepEqual(d3panels.reorgByChr(uchr, chr, pos), out, 'one group')

    uchr = ['1','2','3','4','5']
    chr = ['1', '2', '3', '5']
    pos = [0, 10.5, 20.5, 30]
    out = {
        '1':[0],
        '2':[10.5],
        '3':[20.5],
        '4':[],
        '5':[30]}

    assert.deepEqual(d3panels.reorgByChr(uchr, chr, pos), out, 'one group missing')
