# illustration of use of the mapchart function

d3.json "data.json", (data) ->
    mychart = mapchart()

    mychart(d3.select("div#chart1"), data)

d3.json "data.json", (data) ->
    mychart = mapchart({horizontal:true, height:600})

    mychart(d3.select("div#chart2"), data)

d3.json "data.json", (data) ->
    mychart = mapchart({title:"Shifted start", shiftStart:true})

    mychart(d3.select("div#chart3"), data)

d3.json "data.json", (data) ->
    mychart = mapchart({title:"Backwards order"})

    data.chrname = unique(data.chr).reverse()
    mychart(d3.select("div#chart4"), data)
