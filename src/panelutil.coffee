# A variety of utility functions used by the different panel functions

d3panels =
    version: "1.0.0"

# determine rounding of axis labels
formatAxis = (d, extra_digits=0) ->

    # gap between values
    gap = if d[0]? then d[1]-d[0] else d[2] - d[1] # allow first value to be NULL

    # turn gap into number of digits
    ndig = Math.floor( log10(gap) )
    ndig = 0 if ndig > 0
    ndig = Math.abs(ndig) + extra_digits

    # function to return
    (val) ->
        return d3.format(".#{ndig}f")(val) if val? and val != "NA"
        "NA"

# unique values of array (ignore nulls)
unique = (x) ->
    output = {}
    output[v] = v for v in x when v?
    output[v] for v of output

# Pull out a variable (column) from a two-dimensional array
pullVarAsArray = (data, variable) ->
    (data[i][variable] for i of data)

# reorganize lod/pos by chromosome
#    uniquechr = vector of unique chromosome IDs
#    chr = vector of chromosome IDs
reorgByChr = (uniquechr, chr, vector) ->
    if(chr.length != vector.length)
        displayError("reorgByChr: chr.length (#{chr.length}) != vector.length (#{vector.length})")

    result = {}
    for c,i in uniquechr
        result[c] = (vector[i] for i of vector when chr[i]==c)

    result

# reorganize lod and position by chromosome
# also, add markerinfo object
reorgLodData = (data) ->
    data.posByChr = reorgByChr(data.chrname, data.chr, data.pos)
    data.lodByChr = reorgByChr(data.chrname, data.chr, data.lod)

    if data.marker?
        data.markerinfo = ({name: data.marker[i], chr:data.chr[i], pos:data.pos[i], lod:data.lod[i]} for i of data.marker when data.marker[i] != "")

    data

# calculate chromosome scales for chrpanelframe (and so lodchart)
calc_chrscales = (plot_width, left_margin, gap, chr, start, end, reverse=false) ->
    # calculate chromosome lengths, start and end in pixels
    n_chr = chr.length
    chr_length = (end[i]-start[i] for i of end)
    tot_chr_length = chr_length.reduce (t,s) -> t+s
    tot_pixels = plot_width - gap*n_chr
    chr_start_pixels = [left_margin + gap/2]
    chr_end_pixels = [left_margin + gap/2 + tot_pixels/tot_chr_length * chr_length[0]]
    for i in [1..(n_chr-1)]
        chr_start_pixels.push(chr_end_pixels[i-1] + gap)
        chr_end_pixels.push(chr_start_pixels[i] + tot_pixels/tot_chr_length * chr_length[i])

    xscale = {}
    for i of chr
        xscale[chr[i]] = d3.scale.linear()
                           .domain([start[i], end[i]])
                           .range([chr_start_pixels[i], chr_end_pixels[i]])

    if reverse # reverse the scale (right-to-left rather than left-to-right)
        right = plot_width + left_margin*2
        for i of chr
            xscale[chr[i]].range([right - chr_end_pixels[i], right - chr_start_pixels[i]])

    # return the scale
    xscale


# calculate chromosome start/end + scales, for heat map
chrscales = (data, width, chrGap, leftMargin, pad4heatmap) ->
    # start and end of chromosome positions
    chrStart = []
    chrEnd = []
    chrLength = []
    totalChrLength = 0
    maxd = 0
    for chr in data.chrnames
        d = maxdiff(data.posByChr[chr])
        maxd = d if d > maxd

        rng = d3.extent(data.posByChr[chr])
        chrStart.push(rng[0])
        chrEnd.push(rng[1])
        L = rng[1] - rng[0]
        chrLength.push(L)
        totalChrLength += L

    # adjust lengths for heatmap
    if pad4heatmap
        data.recwidth = maxd
        chrStart = chrStart.map (x) -> x-maxd/2
        chrEnd = chrEnd.map (x) -> x+maxd/2
        chrLength = chrLength.map (x) -> x+maxd
        totalChrLength += (chrLength.length*maxd)

    # break up x axis into chromosomes by length, with gaps
    data.chrStart = []
    data.chrEnd = []
    cur = leftMargin
    cur += chrGap/2 unless pad4heatmap
    data.xscale = {}
    for chr,i in data.chrnames
        data.chrStart.push(cur)
        w = Math.round((width-chrGap*(data.chrnames.length-pad4heatmap))/totalChrLength*chrLength[i])
        data.chrEnd.push(cur + w)
        cur = data.chrEnd[i] + chrGap
        # x-axis scales, by chromosome
        data.xscale[chr] = d3.scale.linear()
                             .domain([chrStart[i], chrEnd[i]])
                             .range([data.chrStart[i], data.chrEnd[i]])

    # return data with new stuff added
    data

# Select a set of categorical colors
# ngroup is positive integer
# palette = "dark" or "pastel"
selectGroupColors = (ngroup, palette) ->
    return [] if ngroup == 0

    if palette == "dark"
        return ["slateblue"] if ngroup == 1
        return ["MediumVioletRed", "slateblue"] if ngroup == 2
        return ["MediumVioletRed", "MediumSeaGreen", "slateblue"] if ngroup == 3
        return colorbrewer.Set1[ngroup] if ngroup <= 9
        return d3.scale.category20().range()[0...ngroup]
    else
        return ["#bebebe"] if ngroup == 1
        return ["lightpink", "lightblue"] if ngroup == 2
        return colorbrewer.Pastel1[ngroup] if ngroup <= 9
        # below is rough attempt to make _big_ pastel palette
        return ["#8fc7f4", "#fed7f8", "#ffbf8e", "#fffbb8",
                "#8ce08c", "#d8ffca", "#f68788", "#ffd8d6",
                "#d4a7fd", "#f5f0f5", "#cc968b", "#f4dcd4",
                "#f3b7f2", "#f7f6f2", "#bfbfbf", "#f7f7f7",
                "#fcfd82", "#fbfbcd", "#87feff", "#defaf5"][0...ngroup]

# expand element/array (e.g., of colors) to a given length
#     single elment -> array, then repeated to length n
expand2vector = (input, n) ->
    return input unless input? # return null if null
    return input if Array.isArray(input) and input.length >= n
    input = [input] unless Array.isArray(input)
    input = (input[i % input.length] for i of d3.range(n)) if input.length > 1 and n > 1
    input = (input[0] for i of d3.range(n)) if input.length == 1 and n > 1
    input

# median of a vector
median = (x) ->
    return null if !x?
    x = (xv for xv in x when xv?)
    n = x.length
    return null unless n>0
    x.sort((a,b) -> a-b)
    if n % 2 == 1
        return x[(n-1)/2]
    (x[n/2] + x[(n/2)-1])/2

# pad a vector to left and right
pad_vector = (x, pad=null) -> # x should be sorted
    return [x[0] - (x[1]-x[0])].concat(x).concat([x[x.length - 1] + (x[x.length-1] - x[x.length-2])]) unless pad?
    [x[0] - pad].concat(x).concat(x[x.length - 1] + pad)

# calculate midpoints
calc_midpoints = (x) -> # x should be sorted
    ((x[i] + x[i+1])/2 for i in [0..(x.length - 2)])

# calc cell rectangles (left, right, top, bottom)
calc_cell_rect = (cells, xmid, ymid) ->
    for cell in cells
        left = xmid[cell.xindex]
        right = xmid[1 + cell.xindex]
        top = ymid[cell.yindex]
        bottom = ymid[1 + cell.yindex]

        cell.left = d3.min([left, right])
        cell.width = Math.abs(right-left)
        cell.top = d3.min([top, bottom])
        cell.height = Math.abs(bottom - top)

# calc chr cell rectangles (left, right, top, bottom)
calc_chrcell_rect = (cells, xmid, ymid) ->
    for cell in cells
        left = xmid[cell.chr][cell.posindex]
        right = xmid[cell.chr][1 + cell.posindex]
        top = ymid[cell.lodindex]
        bottom = ymid[1 + cell.lodindex]

        cell.left = d3.min([left, right])
        cell.width = Math.abs(right-left)
        cell.top = d3.min([top, bottom])
        cell.height = Math.abs(bottom - top)

# hash with values to left and right
getLeftRight = (x) ->
    n = x.length
    x.sort( (a,b) -> a-b )

    xdif = []
    result = {}
    for v in x
        result[v] = {}

    for i in [1...n]
        xdif.push(x[i]-x[i-1])
        result[x[i]].left = x[i-1]
    for i in [0...(n-1)]
        result[x[i]].right = x[i+1]

    xdif = median(xdif)
    result.mediandiff = xdif

    result[x[0]].left = x[0]-xdif
    result[x[n-1]].right = x[n-1]+xdif
    result.extent = [x[0]-xdif/2, x[n-1]+xdif/2]

    result

# maximum difference between adjacent values in a vector
maxdiff = (x) ->
    return null if x.length < 2
    result = x[1] - x[0]
    return result if x.length < 3
    for i in [2...x.length]
        d = x[i] - x[i-1]
        result = d if d > result
    result

# matrix extent, min, max, and max of absolute values
matrixMin = (mat) ->
    result = mat[0][0]
    for i of mat
        for j of mat[i]
            result = mat[i][j] if !(result?) or (result > mat[i][j] and mat[i][j]?)
    result

matrixMax = (mat) ->
    result = mat[0][0]
    for i of mat
        for j of mat[i]
            result = mat[i][j] if !(result?) or (result < mat[i][j] and mat[i][j]?)
    result

matrixMaxAbs = (mat) ->
    result = Math.abs(mat[0][0])
    for i of mat
        for j of mat[i]
            result = Math.abs(mat[i][j]) if !(result?) or (result < Math.abs(mat[i][j]) and mat[i][j]?)
    result

matrixExtent = (mat) -> [matrixMin(mat), matrixMax(mat)]

# move an object to front or back
d3.selection.prototype.moveToFront = () ->
    this.each () -> this.parentNode.appendChild(this)

d3.selection.prototype.moveToBack = () ->
    this.each () ->
        firstChild = this.parentNode.firstchild
        this.parentNode.insertBefore(this, firstChild) if firstChild

# force an object to be an array (rather than a scalar)
forceAsArray = (x) ->
    return x unless x? # if null, return null
    return x if Array.isArray(x)
    [x]

# any values in vec that appear in missing are made null
missing2null = (vec, missingvalues=['NA', '']) ->
    vec.map (value) -> if missingvalues.indexOf(value) > -1 then null else value

# display error at top of page
displayError = (message, divid=null) ->
    div = "div.error"
    div += "##{divid}" if divid?
    if d3.select(div).empty() # no errors yet
        d3.select("body")
          .insert("div", ":first-child")
          .attr("class", "error")
    d3.select(div)
      .append("p")
      .text(message)

# sum values in an array
sumArray = (vec) ->
    vec = (x for x in vec when x?)
    return null unless vec.length > 0
    (vec.reduce (a,b) -> (a*1)+(b*1))

# calculate cross-tabulation
calc_crosstab = (data) ->
    nrow = data.ycat.length
    ncol = data.xcat.length

    result = ((0 for col in [0..ncol]) for row in [0..nrow]) # matrix of 0's

    # count things up
    for i of data.x
        result[data.y[i]][data.x[i]] += 1

    # row and column sums
    rs = rowSums(result)
    cs = colSums(result)

    # fill in column sums
    for i in [0...ncol]
        result[nrow][i] = cs[i]

    # fill in row sums
    for i in [0...nrow]
        result[i][ncol] = rs[i]

    # fill in total
    result[nrow][ncol] = sumArray(rs)

    result

# rowSums: the sums for each row
rowSums = (mat) -> (sumArray(x) for x in mat)

# transpose: matrix transpose
transpose = (mat) -> ((mat[i][j] for i in [0...mat.length]) for j in [0...mat[0].length])

# colSums = the sums for each column
colSums = (mat) -> rowSums(transpose(mat))

# log base 2
log2 = (x) ->
    return(x) unless x?
    Math.log(x)/Math.log(2.0)

# log base 10
log10 = (x) ->
    return(x) unless x?
    Math.log(x)/Math.log(10.0)

# absolute value, preserving nulls
abs = (x) ->
    return(x) unless x?
    Math.abs(x)

# mean of y for each possible value of g
mean_by_group = (g, y) ->
    means = {}
    n = {}
    for i of g
        if n[g[i]]?
            means[g[i]] += y[i] if y[i]?
            n[g[i]] += 1 if y[i]?
        else
            means[g[i]] = y[i] if y[i]?
            n[g[i]] = 1 if y[i]?
    for i of means
        means[i] /= n[i]
    means

# SD of y for each possible value of g
sd_by_group = (g, y) ->
    means = mean_by_group(g, y)
    sds = {}
    n = {}
    for i of g
        dev = (y[i] - means[g[i]])
        if n[g[i]]?
            sds[g[i]] += (dev*dev) if y[i]?
            n[g[i]] += 1 if y[i]?
        else
            sds[g[i]] = (dev*dev) if y[i]?
            n[g[i]] = 1 if y[i]?

    for i of sds
        sds[i] = if n[i] < 2 then null else Math.sqrt(sds[i]/(n[i]-1))

    sds

# count groups
count_groups = (g, y) ->
    n = {}
    for i of g
        if n[g[i]]?
            n[g[i]] += 1 if y[i]?
        else
            n[g[i]] = 1 if y[i]?
    n

# CI for mean(y) for each possible value of g
#  (as mean +/- m*SD)
ci_by_group = (g, y, m=2) ->
    means = mean_by_group(g, y)

    # repeat the code for the SD, so I do two passes but not three
    sds = {}
    n = {}
    for i of g
        dev = (y[i] - means[g[i]])
        if n[g[i]]?
            sds[g[i]] += (dev*dev) if y[i]?
            n[g[i]] += 1 if y[i]?
        else
            sds[g[i]] = (dev*dev) if y[i]?
            n[g[i]] = 1 if y[i]?

    for i of sds
        sds[i] = if n[i] < 2 then null else Math.sqrt(sds[i]/(n[i]-1))

    ci = {}
    for i of means
        ci[i] =
            mean: means[i]
            low: if n[i]>0 then means[i] - m*sds[i]/Math.sqrt(n[i]) else means[i]
            high: if n[i]>0 then means[i] + m*sds[i]/Math.sqrt(n[i]) else means[i]

    ci
