# illustration of use of the scatterplot function

h = 380
w = 500
margin = {left:60, top:40, right:40, bottom: 40, inner:5}

# Example 1: simplest use
d3.json "data.json", (data) ->
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
