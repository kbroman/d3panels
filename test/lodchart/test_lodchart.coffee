# illustration of use of the lodchart function

h = 300
w = 600
margin = {left:60, top:40, right:40, bottom: 40, inner:5}

# simplest use
d3.json "data.json", (data) ->
    mychart = lodchart({height:h, width:w, margin:margin})

    mychart(d3.select("div#chart1"), {chr:data.chr,pos:data.pos,lod:data["lod.em"],marker:data.markernames})

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
    mychart_em = lodchart({
        height:h*0.7
        width:w
        margin:margin
        ylab:"LOD score (by EM)"
        pointsize:1
        pointstroke:"white"
        nyticks:9
        title:"Standard interval mapping"})

    mychart_hk = lodchart({
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

    mychart_em(chart2a, {chr:data.chr, pos:data.pos, lod:data["lod.em"],marker:data.markernames})
    mychart_hk(chart2b, {chr:data.chr, pos:data.pos, lod:data["lod.hk"],marker:data.markernames})

# two curves on one chart
d3.json "data.json", (data) ->
    mychart = lodchart({
        height:h
        width:w
        margin:margin
        ylab:"LOD score"
        pointstroke:"white"})

    svg = d3.select("div#chart3")

    mychart(d3.select("div#chart3"), {chr:data.chr, pos:data.pos, lod:data["lod.em"],marker:data.markernames})
    add_lodcurve(mychart, {linecolor:"Crimson", linedash:"4,4"},
                 {chr:data.chr, pos:data.pos, lod:data["lod.hk"],marker:data.markernames})
