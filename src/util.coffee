# A variety of utility functions used by the different panel functions

# determine rounding of axis labels
formatAxis = (d, extra_digits=0) ->
    d = d[1] - d[0]
    ndig = Math.floor( log10(d) )
    ndig = 0 if ndig > 0
    ndig = Math.abs(ndig) + extra_digits
    d3.format(".#{ndig}f")

# unique values of array (ignore nulls)
unique = (x) ->
    output = {}
    output[v] = v for v in x when v
    output[v] for v of output

# Pull out a variable (column) from a two-dimensional array
pullVarAsArray = (data, variable) ->
    (data[i][variable] for i of data)

# Select a set of categorical colors
# ngroup is positive integer
# palette = "dark" or "pastel"
selectGroupColors = (ngroup, palette) ->
    return [] if ngroup == 0

    if palette == "dark"
        return ["slateblue"] if ngroup == 1
        return ["MediumVioletRed", "slateblue"] if ngroup == 2
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
            result = mat[i][j] if mat[i][j]? and result > mat[i][j]
    result

matrixMax = (mat) ->
    result = mat[0][0]
    for i of mat
        for j of mat[i]
            result = mat[i][j] if mat[i][j]? and result < mat[i][j]
    result

matrixMaxAbs = (mat) ->
    result = Math.abs(mat[0][0])
    for i of mat
        for j of mat[i]
            result = Math.abs(mat[i][j]) if mat[i][j]? and result < Math.abs(mat[i][j])
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
sumArray = (vec) -> (vec.reduce (a,b) -> (a*1)+(b*1))

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
