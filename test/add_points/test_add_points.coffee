# illustration of use of the scatterplot function

h = 380
w = 500
margin = {left:60, top:40, right:40, bottom: 40, inner:5}

# Example 1: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.panelframe({
        xlab:"x"
        ylab:"y"
        height:h
        width:w
        pointsize: 3
        margin:margin
        xlim:d3.extent(data.x)
        ylim:d3.extent(data.y)})

    # make frame
    mychart(d3.select("div#chart1"))

    add_points = d3panels.add_points({pointcolor:["Orchid", "slateblue", "#8c8"]})
    add_points(mychart, data)

# Example 2: missing data
d3.json("data.json").then (data) ->
    mychart = d3panels.panelframe({
        xlab:"x"
        ylab:"y"
        height:h
        width:w
        pointsize: 3
        margin:margin
        xNA: true
        yNA: true
        xlim:d3.extent(data.x)
        ylim:d3.extent(data.y)})

    # make frame
    mychart(d3.select("div#chart2"))

    data.x[0] = 'NA'
    data.x[1] = 'NA'
    data.y[0] = 'NA'
    data.y[1] = 'NA'

    for i of data.x
        data.x[i] = 'NA' if Math.random()<0.2
        data.y[i] = 'NA' if Math.random()<0.2

    addpts = d3panels.add_points({pointcolor:["Orchid", "slateblue", "#8c8"]})
    addpts(mychart, data)

    addpts.points().on("mouseover", (d,i) ->
                          d3.select(this).attr("r", 6))
                   .on("mouseout", (d,i) ->
                          d3.select(this).attr("r", 3))
