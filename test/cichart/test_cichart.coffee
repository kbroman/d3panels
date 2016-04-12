# illustration of use of the cichart function

margin = {left:80, top:40, right:40, bottom: 40, inner:5}
axispos = {xtitle:25, ytitle:50, xlabel:5, ylabel:5}

# Example 1: simplest use
d3.json "data.json", (data) ->
    mychart = cichart({margin:margin, axispos:axispos, xcatlabels:["A","B","C"]})
    mychart(d3.select("div#chart1"), data)

# Example 2: horizontal
d3.json "data.json", (data) ->
    mychart = cichart({margin:margin, axispos:axispos, horizontal:true, xcatlabels:["A","B","C"]})
    mychart(d3.select("div#chart2"), data)
