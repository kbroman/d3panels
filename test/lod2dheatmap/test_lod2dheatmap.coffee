# illustration of use of the lod2dheatmap function

# Example: chr 1 at bottom (default)
d3.json "data.json", (data) ->
    n = unique(data.chr).length
    N = data.chr.length
    chrGap = (700 - 2*n)/N + 2
    mychart = lod2dheatmap({
        altrectcolor:""
        chrlinecolor:"black"
        chrGap:chrGap})
    mychart(d3.select("div#chart1"), data)

# Example: chr 1 at top
d3.json "data.json", (data) ->
    n = unique(data.chr).length
    N = data.chr.length
    chrGap = (700 - 2*n)/N + 2
    mychart = lod2dheatmap({
        oneAtTop:true
        altrectcolor:""
        chrlinecolor:"black"
        colors:["crimson", "white", "slateblue"]
        chrGap:chrGap})
    mychart(d3.select("div#chart2"), data)
