# illustration of use of the lodheatmap panel

h = 700
w = 1000

# Example: simplest use
d3.json "data.json", (data) ->
    mychart = lodheatmap({height:h, width:w, zthresh:1})

    data.ycat = data.time
    mychart(d3.select("div#chart1"), data)

# Example with use of quantitative y-axis scale
d3.json "data.json", (data) ->
    mychart = lodheatmap({height:h, width:w, zthresh:1})

    data.y = data.time
    mychart(d3.select("div#chart2"), data)

# Horizontal
d3.json "data.json", (data) ->
    mychart = lodheatmap({height:w, width:h, zthresh:1, horizontal:true})

    data.ycat = data.time
    mychart(d3.select("div#chart3"), data)

# Horizontal, with use of quantitative y-axis scale
d3.json "data.json", (data) ->
    mychart = lodheatmap({height:w, width:h, zthresh:1, horizontal:true})

    data.y = data.time
    mychart(d3.select("div#chart4"), data)
