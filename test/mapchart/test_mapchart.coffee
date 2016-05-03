# illustration of use of the mapchart function

d3.json "data.json", (data) ->
    mychart = d3panels.mapchart()

    mychart(d3.select("div#chart1"), data)

d3.json "data.json", (data) ->
    mychart = d3panels.mapchart({horizontal:true, height:600})

    mychart(d3.select("div#chart2"), data)

d3.json "data.json", (data) ->
    mychart = d3panels.mapchart({title:"Shifted start", shiftStart:true})

    mychart(d3.select("div#chart3"), data)

d3.json "data.json", (data) ->
    mychart = d3panels.mapchart({title:"Backwards order"})

    data.chrname = d3panels.unique(data.chr).reverse()
    mychart(d3.select("div#chart4"), data)
