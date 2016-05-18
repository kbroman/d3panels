QUnit.test "calc_freq", (assert) ->

    x = [13.782, 13.147, 11.643, 10.79, 11.796, 8.801, 12.222, 10.456, 14.459, 7.0689]

    br = [5.23, 5.83, 6.44, 7.04, 7.65, 8.25, 8.86, 9.46, 10.06, 10.67, 11.27, 11.88,
    12.48, 13.09, 13.69, 14.29, 14.89, 15.05, 16.10, 16.71, 17.32]

    count = [0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 2, 1, 0, 1, 1, 1, 0, 0, 0, 0]

    freq = [0, 0, 0, 1/10/(7.65-7.04), 0, 1/10/(8.86-8.25), 0, 0, 1/10/(10.67-10.06), 1/10/(11.27-10.67),
    2/10/(11.88-11.27), 1/10/(12.48-11.88), 0, 1/10/(13.69-13.09), 1/10/(14.29-13.69), 1/10/(14.89-14.29),
    0, 0, 0, 0]

    assert.deepEqual( d3panels.calc_freq(x, br, true), count)

    # compare frequencies
    result = d3panels.calc_freq(x, br, false)
    d = (d3panels.abs(result[i] - freq[i]) for i in d3.range(result.length))
    maxabsdiff = d3.max(d)
    assert.equal( maxabsdiff < 1e-14, true )
