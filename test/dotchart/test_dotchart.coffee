# illustration of use of the dotchart function

h = 300
w = 400
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json "data.json", (data) ->
    mychart = dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Jittered (default)"
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart1"), these_data)

    # animate points
    mychart.points()
           .on "mouseover", (d) ->
                                d3.select(this).attr("r", 6)
           .on "click", (d) ->
                                d3.select(this).attr("fill", "Orchid")
           .on "mouseout", (d) ->
                                d3.select(this).attr("fill", "slateblue").attr("r", 3)

# Example 2: no horizontal jittering
d3.json "data.json", (data) ->
    mychart = dotchart({
        xlab:"X"
        ylab:"Y"
        title:"No jittering"
        height:h
        width:w
        margin:margin
        xjitter:"none"})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart2"), these_data)

    # animate points
    mychart.points()
           .on "mouseover", (d) ->
                                d3.select(this).attr("r", 6)
            .on "click", (d) ->
                                d3.select(this).attr("fill", "Orchid")
           .on "mouseout", (d) ->
                                d3.select(this).attr("fill", "slateblue").attr("r", 3)


# Example 3: horizontal
d3.json "data.json", (data) ->
    mychart = dotchart({
        height:h
        width:w
        margin:margin
        horizontal:true})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart3"), these_data)

    # animate points
    mychart.points()
           .on "mouseover", (d) ->
                                d3.select(this).attr("r", 6)
            .on "click", (d) ->
                                d3.select(this).attr("fill", "Orchid")
           .on "mouseout", (d) ->
                                d3.select(this).attr("fill", "slateblue").attr("r", 3)

# Example 4: deterministic jitter
d3.json "data.json", (data) ->

    mychart = dotchart({
        title:"Deterministic jitter"
        height:h
        width:w
        margin:margin
        xjitter:"deterministic"})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart4"), these_data)

    # animate points
    mychart.points()
           .on "mouseover", (d) ->
                                d3.select(this).attr("r", 6)
           .on "click", (d) ->
                                d3.select(this).attr("fill", "Orchid")
           .on "mouseout", (d) ->
                                d3.select(this).attr("fill", "slateblue").attr("r", 3)

# Example 5: deterministic jitter, horizontal
d3.json "data.json", (data) ->

    mychart = dotchart({
        title:"Deterministic jitter, horizontal"
        height:h
        width:w
        margin:margin
        xjitter:"deterministic",
        horizontal:true})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart5"), these_data)

    # animate points
    mychart.points()
           .on "mouseover", (d) ->
                                d3.select(this).attr("r", 6)
           .on "click", (d) ->
                                d3.select(this).attr("fill", "Orchid")
           .on "mouseout", (d) ->
                                d3.select(this).attr("fill", "slateblue").attr("r", 3)
