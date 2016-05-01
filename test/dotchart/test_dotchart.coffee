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
        title:"Default"
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



# Example 2: horizontal
d3.json "data.json", (data) ->
    mychart = dotchart({
        height:h
        width:w
        margin:margin
        horizontal:true})

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


# Example 3: More data
mychart3 = dotchart({
    title:"More data"
    height:h
    width:w
    margin:margin})

ng = 4
n = 75*ng
x = (Math.ceil(Math.random()*ng) for i in [1..n])
y = (Math.random()*4+20+xv for xv in x)
these_data = {x:x, y:y}
mychart3(d3.select("div#chart3"), these_data)

# animate points
mychart3.points()
        .on "mouseover", (d) ->
                             d3.select(this).attr("r", 6)
        .on "click", (d) ->
                             d3.select(this).attr("fill", "Orchid")
        .on "mouseout", (d) ->
                             d3.select(this).attr("fill", "slateblue").attr("r", 3)

# Example 4: More data, horizontal
mychart4 = dotchart({
    title:"More data, horizontal"
    height:h
    width:w
    margin:margin
    horizontal:true})

mychart4(d3.select("div#chart4"), these_data)

# animate points
mychart4.points()
        .on "mouseover", (d) ->
                             d3.select(this).attr("r", 6)
        .on "click", (d) ->
                             d3.select(this).attr("fill", "Orchid")
        .on "mouseout", (d) ->
                             d3.select(this).attr("fill", "slateblue").attr("r", 3)

# Example 5: random jitter
d3.json "data.json", (data) ->
    mychart = dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Random jitter"
        jitter:'random'
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart5"), these_data)

# Example 6: random jitter, horizontal
d3.json "data.json", (data) ->
    mychart = dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Random jitter, horizontal"
        jitter:'random'
        horizontal:true
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart6"), these_data)

# Example 7: No jitter
d3.json "data.json", (data) ->
    mychart = dotchart({
        xlab:"X"
        ylab:"Y"
        title:"No jitter"
        jitter:'none'
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart7"), these_data)

# Example 8: random jitter
d3.json "data.json", (data) ->
    mychart = dotchart({
        xlab:"X"
        ylab:"Y"
        title:"No jitter, horizontal"
        jitter:'none'
        horizontal:true
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    mychart(d3.select("div#chart8"), these_data)
