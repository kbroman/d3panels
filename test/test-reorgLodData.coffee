QUnit.test "reorgLodData", (assert) ->

    uchr = ['1', '2', 'X']
    chr = ['1', '1', '1', '1', '2', '2', '2', 'X', 'X', 'X']
    pos = [0, 10.5, 20.5, 30, 3.2, 4.2, 5.2, -10, 11, 100.2]
    lod = [1.60, 4.53, 1.81, 3.24, 1.45, 3.39, 0.42, 3.34, 4.10, 3.00]
    data = {
        chrname: uchr
        chr: chr
        pos: pos
        lod: lod}

    out = {
        chrname: uchr
        chr: chr
        pos: pos
        lod: lod
        posByChr:{
            '1':[0, 10.5, 20.5, 30]
            '2':[3.2, 4.2, 5.2]
            'X':[-10, 11, 100.2]}
        lodByChr:{
            '1':[1.60, 4.53, 1.81, 3.24]
            '2':[1.45, 3.39, 0.42]
            'X':[3.34, 4.10, 3.00]}}

    assert.deepEqual(d3panels.reorgLodData(data), out, 'simplest use')

    # add marker
    data.marker = ['m1', '', '', '', 'm6', 'm2', '', 'm10', '', 'm9']
    out.marker = data.marker
    out.markerinfo = [{name:'m1',  chr:'1', pos:0,   lod:1.60},
                      {name:'m6',  chr:'2', pos:3.2, lod:1.45},
                      {name:'m2',  chr:'2', pos:4.2, lod:3.39},
                      {name:'m10', chr:'X', pos:-10, lod:3.34},
                      {name:'m9',  chr:'X', pos:100.2,  lod:3.00}]

    assert.deepEqual(d3panels.reorgLodData(data), out, 'with marker info')

    # add poslabelByChr
    data.poslabel = ['1@0', '1@10.5', '1@20.5', '1@30',
                     '2@3.2', '2@4.2', '2@5.2',
                     'X@-10', 'X@11', 'X@100.2']
    out.poslabel = data.poslabel
    out.poslabelByChr = {
        '1':['1@0', '1@10.5', '1@20.5', '1@30']
        '2':['2@3.2', '2@4.2', '2@5.2']
        'X':['X@-10', 'X@11', 'X@100.2']}

    assert.deepEqual(d3panels.reorgLodData(data), out, 'with poslabel')

    uchr = ['1']
    chr = ['1', '1', '1', '1']
    pos = [0, 10.5, 20.5, 30]
    lod = [1.60, 4.53, 1.81, 3.24]
    data = {
        chrname: uchr
        chr: chr
        pos: pos
        lod: lod}

    out = {
        chrname: uchr
        chr: chr
        pos: pos
        lod: lod
        posByChr:{
            '1':[0, 10.5, 20.5, 30]}
        lodByChr:{
            '1':[1.60, 4.53, 1.81, 3.24]}}

    assert.deepEqual(d3panels.reorgLodData(data), out, 'one group')

    uchr = ['1','2','3','4','5']
    chr = ['1', '2', '3', '5']
    pos = [0, 10.5, 20.5, 30]
    lod = [1.60, 4.53, 1.81, 3.24]
    data = {
        chrname: uchr
        chr: chr
        pos: pos
        lod: lod}

    out = {
        chrname: uchr
        chr: chr
        pos: pos
        lod: lod
        posByChr:{
            '1':[0]
            '2':[10.5]
            '3':[20.5]
            '4':[]
            '5':[30]}
        lodByChr:{
            '1':[1.60]
            '2':[4.53]
            '3':[1.81]
            '4':[]
            '5':[3.24]}}

    assert.deepEqual(d3panels.reorgLodData(data), out, 'one group missing')
