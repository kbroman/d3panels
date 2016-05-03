# illustration of use of the lodchart function

h = 300
w = 600
margin = {left:60, top:40, right:40, bottom: 40, inner:5}

# simplest use
d3.json "data.json", (data) ->
    mychart = d3panels.lodchart({height:h, width:w, margin:margin})

    data.lod = data.lod_em
    mychart(d3.select("div#chart1"), data)

    # grab chromosome rectangles; color pink on hover
    chrrect = mychart.chrSelect()
    chrrect.on "mouseover", ->
                                d3.select(this).attr("fill", "#E9CFEC")
           .on "mouseout", (d,i) ->
                                d3.select(this).attr("fill", ->
                                     return "#c8c8c8" if i % 2
                                     "#e6e6e6")

    # animate points at markers on click
    mychart.markerSelect()
           .on "click", (d) ->
                            r = d3.select(this).attr("r")
                            d3.select(this)
                              .transition().duration(500).attr("r", r*3)
                              .transition().duration(500).attr("r", r)

# two LOD charts within one SVG
d3.json "data.json", (data) ->
    mychart_em = d3panels.lodchart({
        height:h*0.7
        width:w
        margin:margin
        ylab:"LOD score (by EM)"
        pointsize:1
        pointstroke:"white"
        nyticks:9
        title:"Standard interval mapping"})

    mychart_hk = d3panels.lodchart({
        height:h*0.7
        width:w
        margin:margin
        ylab:"LOD score (by H-K)"
        linecolor:"Crimson"
        yticks:[0,1,2,4,6,8]
        title:"Haley-Knott regression"})

    svg = d3.select("div#chart2")
            .append("svg")
            .attr("class", "d3panels")
            .attr("height", h*1.4)
            .attr("width", w)

    chart2a = svg.append("g").attr("id", "chart2a")

    chart2b = svg.append("g").attr("id", "chart2b")
                .attr("transform", "translate(0, #{h*0.7})")

    data.lod = data.lod_em
    mychart_em(chart2a, data)
    data.lod = data.lod_hk
    mychart_hk(chart2b, data)

# two curves on one chart
d3.json "data.json", (data) ->
    mychart = d3panels.lodchart({
        height:h
        width:w
        margin:margin
        pointstroke:"white"})

    data.lod = data.lod_em
    mychart(d3.select("div#chart3"), data)

    data2 = {chr:data.chr, pos:data.pos, lod:data.lod_hk, marker:data.marker}
    addtochart = d3panels.add_lodcurve({linecolor:"Crimson", pointcolor:"slateblue", linedash:"4,4"})
    addtochart(mychart, data2)

# horizontal
d3.json "data.json", (data) ->
    mychart = d3panels.lodchart({height:600, width:400, margin:margin, horizontal:true})

    data.lod = data.lod_em
    mychart(d3.select("div#chart4"), data)
