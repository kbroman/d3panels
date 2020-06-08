# illustration of use of the dotchart function

h = 300
w = 400
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
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
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
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
mychart3 = d3panels.dotchart({
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
mychart4 = d3panels.dotchart({
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
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
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
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
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
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
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
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
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


# Example 9: Some missing y data
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Missing y values"
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    for i of these_data.y
        these_data.y[i] = null if Math.random()<0.2
    mychart(d3.select("div#chart9"), these_data)

# Example 10: Some missing y data, horizontal
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Missing y values, horizontal"
        horizontal:true
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    for i of these_data.y
        these_data.y[i] = null if Math.random()<0.2
    mychart(d3.select("div#chart10"), these_data)



# Example 11: Some missing x data
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Missing x values"
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    for i of these_data.x
        these_data.x[i] = null if Math.random()<0.2
    mychart(d3.select("div#chart11"), these_data)

# Example 12: Some missing x data, horizontal
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Missing x values, horizontal"
        horizontal:true
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    for i of these_data.x
        these_data.x[i] = null if Math.random()<0.2
    mychart(d3.select("div#chart12"), these_data)



# Example 13: Some missing x and y data
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Missing x and y values"
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    for i of these_data.y
        these_data.x[i] = null if Math.random()<0.2
        these_data.y[i] = null if Math.random()<0.2
    these_data.x[0] = null
    these_data.y[0] = null
    mychart(d3.select("div#chart13"), these_data)

# Example 14: Some missing x and y data, horizontal
d3.json("data.json").then (data) ->
    mychart = d3panels.dotchart({
        xlab:"X"
        ylab:"Y"
        title:"Missing x and y values, horizontal"
        horizontal:true
        height:h
        width:w
        margin:margin})

    these_data = {x:(d[0] for d in data), y:(d[1] for d in data)}
    for i of these_data.y
        these_data.x[i] = null if Math.random()<0.2
        these_data.y[i] = null if Math.random()<0.2
    these_data.x[0] = null
    these_data.y[0] = null
    mychart(d3.select("div#chart14"), these_data)

# Example 15: More data
mychart15 = d3panels.dotchart({
    title:"Color by group"
    height:h
    width:w
    margin:margin})

ng = 4
n = 75*ng
x = (Math.ceil(Math.random()*ng) for i in [1..n])
y = (Math.random()*4+20+xv for xv in x)
group = ((if Math.random() < 0.5 then 1 else 2) for xv in x)
these_data = {x:x, y:y, group:group}
mychart15(d3.select("div#chart15"), these_data)
