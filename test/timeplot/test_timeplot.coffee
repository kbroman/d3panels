# illustration of use of the timeplot function

# example 1
# Example 1: simplest use
d3.json("data.json").then (data) ->
    h = 550
    w = 900
    margin = {left:60, top:40, right:40, bottom: 40, inner:5}

    mychart = d3panels.timeplot({
        xlab:"Date"
        ylab:"Download speed"
        height:h
        width:w
        pointsize: 3
        ylim: [0, 1000]
        margin:margin})

    # reorg data
    these_data = {x:(d.time for d in data),
                  y:(d.download for d in data),
                  indID:("#{d3panels.formatdatetime(new Date(d.time))} #{Math.round(d.download)} Mbp" for d in data)}

    # make plot
    mychart(d3.select("div#chart1"), these_data)

    # animate points
    mychart.points()
              .on "mouseover", () ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", () ->
                                   d3.select(this).attr("r", 3)





# Example 2: same, but less data, so x-axis has times instead of dates
d3.json("data.json").then (data) ->
    h = 550
    w = 900
    margin = {left:60, top:40, right:40, bottom: 40, inner:5}

    mychart = d3panels.timeplot({
        xlab:"Time"
        ylab:"Download speed"
        height:h
        width:w
        pointsize: 3
        ylim: [0, 1000]
        margin:margin})

    # reorg data, subsetting to just 22 points
    n_pts = 22
    start = Math.round(Math.random()*(data.length-n_pts))
    these_data = {x:(data[i].time for i of data when i>=start and i<start+n_pts)
                  y:(data[i].download for i of data when i>=start and i<start+n_pts)
                  indID:("#{d3panels.formatdatetime(new Date(data[i].time))} #{Math.round(data[i].download)} Mbp" for i of data when i>=start & i<start+n_pts)}

    # make plot
    mychart(d3.select("div#chart2"), these_data)

    # animate points
    mychart.points()
              .on "mouseover", () ->
                                   d3.select(this).attr("r", 3*3)
              .on "mouseout", () ->
                                   d3.select(this).attr("r", 3)

# Example 3: linked charts
d3.json("data.json").then (data) ->
    pointcolor = "slateblue"
    hilitcolor = "pink"
    h = 450
    w = 900
    margin = {left:60, top:10, right:40, bottom: 20, inner:5}
    halfh = (h+margin.top+margin.bottom)
    totalh = halfh*2
    totalw = (w+margin.left+margin.right)
    r = 3

    mychart1 = d3panels.timeplot({
        xlab:"Time"
        ylab:"Download speed"
        height:h
        width:w
        pointsize: r
        pointcolor: pointcolor
        ylim: [0, 1000]
        margin:margin})

    mychart2 = d3panels.timeplot({
        xlab:"Time"
        ylab:"Upload speed"
        height:h
        width:w
        pointsize: r
        pointcolor: pointcolor
        ylim: [0, 1000]
        margin:margin})

    # reorg data
    data1 = {x:(d.time for d in data),
             y:(d.download for d in data),
             indID:("#{Math.round(d.download)} Mbps (#{d3panels.formatdatetime(new Date(d.time))})" for d in data)}

    data2 = {x:(d.time for d in data),
             y:(d.upload for d in data),
             indID:(" #{Math.round(d.upload)} Mbp (#{d3panels.formatdatetime(new Date(d.time))})" for d in data)}

    svg = d3.select("div#chart3")
            .append("svg")
            .attr("class", "d3panels")
            .attr("height", totalh)
            .attr("width", totalw)

    chart1 = svg.append("g").attr("id", "chart01")

    chart2 = svg.append("g").attr("id", "chart02")
                .attr("transform", "translate(0,#{halfh})")


    # make plots
    mychart1(chart1, data1)
    mychart2(chart2, data2)

    # animate points
    mychart1.points()
              .on "mouseover", (d,i) ->
                                   d3.select(this).attr("r", r*3)
                                                  .attr("fill", hilitcolor)
                                   chart2.selectAll("circle")
                                         .attr("fill", (d2,i2) ->
                                             if i2==i then hilitcolor else pointcolor)
                                         .attr("r", (d2,i2) ->
                                             if i2==i then r*3 else r)

              .on "mouseout", (d,i) ->
                                   d3.select(this).attr("r", r)
                                                  .attr("fill", pointcolor)
                                   chart2.selectAll("circle")
                                         .attr("fill", pointcolor)
                                         .attr("r", r)

    mychart2.points()
              .on "mouseover", (d,i) ->
                                   d3.select(this).attr("r", r*3)
                                                  .attr("fill", hilitcolor)
                                   chart1.selectAll("circle")
                                         .attr("fill", (d2,i2) ->
                                             if i2==i then hilitcolor else pointcolor)
                                         .attr("r", (d2,i2) ->
                                             if i2==i then r*3 else r)

              .on "mouseout", (d,i) ->
                                   d3.select(this).attr("r", r)
                                                  .attr("fill", pointcolor)
                                   chart1.selectAll("circle")
                                         .attr("fill", pointcolor)
                                         .attr("r", r)
