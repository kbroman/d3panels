# illustration of use of the scatterplot function

h = 380
w = 500
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.scatterplot({
        xlab:"X1"
        ylab:"X2"
        height:h
        width:w
        pointsize: 3
        margin:margin})

    # reorg data
    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}

    # make plot
    mychart(d3.select("div#chart1"), these_data)

    # animate points
    mychart.points()
              .on "mouseover", () ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", () ->
                                   d3.select(this).attr("r", 3)




# Example 2: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.scatterplot({
        xlab:"X1"
        ylab:"X2"
        height:h
        width:w
        pointsize: 3
        margin:margin})

    # reorg data
    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}

    # make plot
    mychart(d3.select("div#chart2"), these_data)

    # animate points
    mychart.points()
              .on "mouseover", () ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", () ->
                                   d3.select(this).attr("r", 3)



# Example 3: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.scatterplot({
        xlab:"X1"
        ylab:"X2"
        height:h
        width:w
        pointsize: 3
        margin:margin})

    # reorg data
    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}

    # make plot
    mychart(d3.select("div#chart3"), these_data)

    # animate points
    mychart.points()
              .on "mouseover", () ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", () ->
                                   d3.select(this).attr("r", 3)



# Example 4: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.scatterplot({
        xlab:"X1"
        ylab:"X2"
        height:h
        width:w
        pointsize: 3
        margin:margin})

    # reorg data
    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}

    # make plot
    mychart(d3.select("div#chart4"), these_data)

    # animate points
    mychart.points()
              .on "mouseover", () ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", () ->
                                   d3.select(this).attr("r", 3)
