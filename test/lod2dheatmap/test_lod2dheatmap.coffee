# illustration of use of the lod2dheatmap function

# Example: chr 1 at bottom (default)
d3.json "data.json", (data) ->
    mychart = lod2dheatmap({
        altrectcolor:""
        chrlinecolor:"black"
        equalCells:true})
    mychart(d3.select("div#chart1"), data)

# Example: chr 1 at top
d3.json "data.json", (data) ->
    mychart = lod2dheatmap({
        oneAtTop:true
        altrectcolor:""
        chrlinecolor:"black"
        colors:["crimson", "white", "slateblue"]
        equalCells:true})
    data.poslabel = data.marker # use marker names as labels
    mychart(d3.select("div#chart2"), data)
