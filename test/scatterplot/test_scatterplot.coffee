# illustration of use of the scatterplot function

h = 380
w = 500
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json "data.json", (data) ->
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
              .on "mouseover", (d) ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", (d) ->
                                   d3.select(this).attr("r", 3)


# Example 2: three scatterplots within one SVG, with brushing
d3.json "data.json", (data) ->
    xvar = [1, 2, 2]
    yvar = [0, 0, 1]
    xshift = [0, halfw, halfw]
    yshift = [0, 0, halfh]

    svg = d3.select("div#chart2")
            .append("svg")
            .attr("class", "d3panels")
            .attr("height", totalh)
            .attr("width", totalw)

    mychart = []
    chart = []
    for i in [0..2]
        mychart[i] = d3panels.scatterplot({
            nxticks:6
            height:h
            width:w
            margin:margin
            xlab:"X#{xvar[i]+1}"
            ylab:"X#{yvar[i]+1}"
            title:"X#{yvar[i]+1} vs. X#{xvar[i]+1}"})

        chart[i] = svg.append("g").attr("id", "chart#{i}")
                      .attr("transform", "translate(#{xshift[i]},#{yshift[i]})")

        these_data = {x:(d[xvar[i]] for d in data), y:(d[yvar[i]] for d in data)}
        mychart[i](chart[i], these_data)

    brush = []
    brushstart = (i) ->
        () ->
            for j in [0..2]
                chart[j].call(brush[j].clear()) if j != i
            svg.selectAll("circle").attr("opacity", 0.6).classed("selected", false)

    brushmove = (i) ->
        () ->
            svg.selectAll("circle").classed("selected", false)
            e = brush[i].extent()
            chart[i].selectAll("circle")
                    .classed("selected", (d,j) ->
                                              circ = d3.select(this)
                                              cx = circ.attr("cx")
                                              cy = circ.attr("cy")
                                              selected =   e[0][0] <= cx and cx <= e[1][0] and
                                                           e[0][1] <= cy and cy <= e[1][1]
                                              svg.selectAll("circle.pt#{j}").classed("selected", true) if selected
                                              selected)

    brushend = () ->
        svg.selectAll("circle").attr("opacity", 1)

    xscale = d3.scale.linear().domain([margin.left,margin.left+w]).range([margin.left,margin.left+w])
    yscale = d3.scale.linear().domain([margin.top,margin.top+h]).range([margin.top,margin.top+h])

    for i in [0..2]
        brush[i] = d3.svg.brush().x(xscale).y(yscale)
                         .on("brushstart", brushstart(i))
                         .on("brush", brushmove(i))
                         .on("brushend", brushend)

        chart[i].call(brush[i])



# Example 3: different options regarding treatment of missing values
d3.json "data.json", (data) ->
    mychart01 = d3panels.scatterplot({
        height:h
        width:w
        margin:margin
        xlab:"X2"
        ylab:"X1"
        xNA:
            handle:true
            force:true
        xNA_size:
            width:15
            gap: 10
        yNA:
            handle:true
            force:true
        yNA_size:
            width:15
            gap:10
        title:"X1 vs X2"})

    mychart02 = d3panels.scatterplot({
        height:h
        width:w
        margin:margin
        xlab:"X3"
        ylab:"X1"
        xNA_size:
            width:15
            gap: 10
        yNA:
            handle:true
            force:true
        yNA_size:
            width:15
            gap: 10
        title: "X1 vs X3"})

    mychart12 = d3panels.scatterplot({
        height:h
        width:w
        margin:margin
        xlab:"X3"
        ylab:"X2"
        xNA:
            handle:false
            force:false
        yNA_size:
            width:15
            gap: 10
        title: "X2 vs X3"})

    svg = d3.select("div#chart3")
            .append("svg")
            .attr("class", "d3panels")
            .attr("height", totalh)
            .attr("width", totalw)

    chart01 = svg.append("g").attr("id", "chart01")

    chart02 = svg.append("g").attr("id", "chart02")
                 .attr("transform", "translate(#{halfw}, 0)")

    chart12 = svg.append("g").attr("id", "chart12")
                 .attr("transform", "translate(#{halfw}, #{halfh})")

    these_data = {x:(d[1] for d in data), y:(d[0] for d in data)}
    mychart01(chart01, these_data)
    these_data = {x:(d[2] for d in data), y:(d[0] for d in data)}
    mychart02(chart02, these_data)
    these_data = {x:(d[2] for d in data), y:(d[1] for d in data)}
    mychart12(chart12, these_data)

    [mychart01, mychart02, mychart12].forEach (chart) ->
        chart.points()
             .on "mouseover", (d,i) ->
                                  svg.selectAll("circle.pt#{i}").attr("r", 9)
             .on "mouseout", (d,i) ->
                                  svg.selectAll("circle.pt#{i}").attr("r", 3)


# Example 4: color by grouping
d3.json "data.json", (data) ->
    mychart = d3panels.scatterplot({
        xlab:"X"
        ylab:"Y"
        height:h
        width:w
        margin:margin})

    ngroup = 3
    group = (Math.ceil(Math.random()*ngroup) for i in data)
    these_data = {x:(d[0] for d in data), y:d[1] for d in data, group:group}
    for i of these_data.y
        these_data.y[i] = null if Math.random() < 0.1
        these_data.x[i] = null if Math.random() < 0.1

    mychart(d3.select("div#chart4"), these_data)

    # animate points
    mychart.points()
           .on "mouseover", (d) ->
                               d3.select(this).attr("r", 9)
           .on "mouseout", (d) ->
                               d3.select(this).attr("r", 3)
