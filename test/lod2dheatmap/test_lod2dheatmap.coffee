# illustration of use of the lod2dheatmap function

# Example: chr 1 at bottom (default)
d3.json("data.json").then (data) ->
    mychart = d3panels.lod2dheatmap({
        altrectcolor:""
        chrlinecolor:"black"
        equalCells:true})
    mychart(d3.select("div#chart1"), data)

# Example: chr 1 at top
d3.json("data.json").then (data) ->
    mychart = d3panels.lod2dheatmap({
        oneAtTop:true
        altrectcolor:""
        chrlinecolor:"black"
        colors:["crimson", "white", "slateblue"]
        equalCells:true})
    data.poslabel = data.marker # use marker names as labels
    mychart(d3.select("div#chart2"), data)

# Example 3: super simple, from the doc for the function
data = {
    chr:[1,1,1,1,2,2,2]
    pos:[0,5,10,20,0,8,12]
    lod:[
        [null,11.4,3.1,0.6,0.3,0,0.2],
        [11.4,null,9.9,0.6,0.1,0,0.1],
        [3.1,9.9,null,2.9,0,0.2,0],
        [0.6,0.6,2.9,null,1.8,0.6,0.1],
        [0.3,0.1,0,1.8,null,10.7,9.2],
        [0,0,0.2,0.6,10.7,null,14],
        [0.2,0.1,0,0.1,9.2,14,null]]}

mychart = d3panels.lod2dheatmap({equalCells:true})
mychart(d3.select('div#chart3'), data)
