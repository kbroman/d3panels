# illustration of use of the cichart function

height = 400
width = 300
margin = {left:80, top:40, right:40, bottom: 40, inner:5}
axispos = {xtitle:25, ytitle:50, xlabel:5, ylabel:5}

# Example 1: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.cichart({height:height, width:width, margin:margin, axispos:axispos, xcatlabels:["A","B","C"]})
    mychart(d3.select("div#chart1"), data)

# Example 2: horizontal
d3.json("data.json").then (data) ->
    mychart = d3panels.cichart({height:width, width:height, margin:margin, axispos:axispos, horizontal:true, xcatlabels:["A","B","C"]})
    mychart(d3.select("div#chart2"), data)

# Example 3: missing an interval
d3.json("data.json").then (data) ->
    data.low[1] = data.high[1] = null
    mychart = d3panels.cichart({height:height, width:width, margin:margin, axispos:axispos, xcatlabels:["A","B","C"]})
    mychart(d3.select("div#chart3"), data)

# Example 4:
d3.json("data.json").then (data) ->
    data.mean = [data.mean[0], null, null, data.mean[2]]
    data.low  = [data.low[0], data.low[1], null, data.low[2]]
    data.high  = [data.high[0], data.high[1], null, data.high[2]]
    mychart = d3panels.cichart({height:height, width:width, margin:margin, axispos:axispos, xcatlabels:["A","B","C","D"]})
    mychart(d3.select("div#chart4"), data)
