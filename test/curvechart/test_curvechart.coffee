# illustration of use of the curvechart function

h = 600
w = 900
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example : simplest use
d3.json "data.json", (data) ->
    mychart = d3panels.curvechart({
        xlab:"Age (weeks)"
        ylab:"Body weight"
        height:h
        width:w
        margin:margin
        strokewidthhilit:4})

    mychart(d3.select("div#chart1"), data)

    # add indication of individual (initially blank)
    textbox = mychart.svg()
                     .append("text")
                     .attr("class", "title")
                     .text("")
                     .attr("y", margin.top/2)
                     .attr("x", margin.left)
                     .style("text-anchor","start")

    mychart.curvesSelect()
           .on("mouseover.text", (d,i) ->
                                     textbox.text("ind #{i+1}"))
           .on("mouseout.text", () ->
                                     textbox.text(""))

# Example : swap x and y
d3.json "data.json", (data) ->
    mychart = d3panels.curvechart({
        xlab:"Age (weeks)"
        ylab:"Body weight"
        height:w
        width:h
        margin:margin
        strokewidthhilit:4})

    # expand data.x
    data.x = (data.x[0] for i of data.y)
    # swap x and y
    [data.x, data.y] = [data.y, data.x]

    mychart(d3.select("div#chart2"), data)
