# illustration of use of the timeplot function

# example 1

h = 550
w = 900
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json("data.json").then (data) ->
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





# Example 2: sample, but less data, so x-axis has times instead of dates
d3.json("data.json").then (data) ->
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
