# illustration of use of the heatmap function

h = 600
w = 600

# Example: simplest use
d3.json "data.json", (data) ->
    mychart = d3panels.heatmap({height:h, width:w, zthresh:0.5})
    mychart(d3.select("div#chart1"), data)

# Example: unequal bins
d3.json "data_unequal.json", (data) ->
    mychart2 = d3panels.heatmap({height:h/2, width:w, zthresh:0.5})
    mychart2(d3.select("div#chart2"), data)

# Example: categorical scales
d3.json "data_categorical.json", (data) ->
    mychart3 = d3panels.heatmap({height:h, width:w})
    mychart3(d3.select("div#chart3"), data)
