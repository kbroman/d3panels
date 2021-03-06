# exploring a d3-slider

# slider size
slider_width=800
slider_height=80
slider_margin=25

# svg size
h = 100+slider_height
w = slider_width

# figure size
figw = w - slider_margin*2
figh = h-slider_height

####
# simple application
####

# insert svg
svg = d3.select("div#chart").insert("svg").attr("id", "chart")
        .attr("height", h).attr("width", w)

# insert figure
fig = svg.insert("g").attr("transform", "translate(" + slider_margin + ",0)")
fig.insert("rect").attr("x", 0).attr("y", 0).attr("height", figh).attr("width", figw).attr("fill", "#ddd")

# stop positions (at marker locations)
marker_pos = [0, 14.2, 16.4, 17.5, 18.6, 21.9, 23, 23, 25.1, 28.4, 29.5,
             30.6, 31.7, 31.7, 32.8, 33.9, 35, 47, 56.8, 74.3]

# xscale
xscale = d3.scaleLinear().range([0,figw]).domain([d3.min(marker_pos), d3.max(marker_pos)])

# add vertical lines to figure
fig.selectAll("empty")
   .data(marker_pos)
   .enter()
   .insert("line")
   .attr("stroke", "black")
   .attr("stroke-width", 2)
   .attr("x1", (d) => xscale(d))
   .attr("x2", (d) => xscale(d))
   .attr("y1", 0)
   .attr("y2", figh)

# central horizontal line
fig.insert("line")
   .attr("x1", 0)
   .attr("x2", figw)
   .attr("y1", figh/2)
   .attr("y2", figh/2)
   .attr("stroke", "slateblue")
   .attr("stroke-width", 2)


# a circle in the figure, whose position will be controlled by the slider
circle = fig.insert("circle")
            .attr("id", "circle")
            .attr("cx", Math.random()*figw)
            .attr("cy", figh/2)
            .attr("r", 10)
            .attr("fill", "slateblue")

# g to contain the slider
slider_g = svg.insert("g").attr("transform", "translate(0," + figh + ")")

# slider callback
slider_callback = (sl) ->
    circle.attr("cx", xscale(sl.value()))

# insert slider
my_slider = d3panels.slider({
    height:slider_height
    width:slider_width
    margin:{left:slider_margin, right:slider_margin, top:40, bottom:40, inner:0}})
my_slider(slider_g, slider_callback, [d3.min(marker_pos), d3.max(marker_pos)], marker_pos)



####
# does it work if the parent div is shifted to the right?
####

left_margin = 25
right_margin = 100
width = 600
figw2 = 600-left_margin-right_margin

# insert svg
svg2 = d3.select("div#chart2").insert("svg").attr("id", "chart")
         .attr("height", h).attr("width", w)

# insert figure
fig2 = svg2.insert("g").attr("transform", "translate(" + left_margin + ",0)")
fig2.insert("rect").attr("x", 0).attr("y", 0).attr("height", figh).attr("width", figw2).attr("fill", "#ddd")

# xscale
xscale2 = d3.scaleLinear().range([0,figw2]).domain([d3.min(marker_pos), d3.max(marker_pos)])

# add vertical lines to figure
fig2.selectAll("empty")
   .data(marker_pos)
   .enter()
   .insert("line")
   .attr("stroke", "black")
   .attr("stroke-width", 2)
   .attr("x1", (d) => xscale2(d))
   .attr("x2", (d) => xscale2(d))
   .attr("y1", 0)
   .attr("y2", figh)

# central horizontal line
fig2.insert("line")
   .attr("x1", 0)
   .attr("x2", figw2)
   .attr("y1", figh/2)
   .attr("y2", figh/2)
   .attr("stroke", "slateblue")
   .attr("stroke-width", 2)

# a circle in the figure, whose position will be controlled by the slider
circle2 = fig2.insert("circle")
            .attr("id", "circle")
            .attr("cx", Math.random()*figw2)
            .attr("cy", figh/2)
            .attr("r", 10)
            .attr("fill", "slateblue")

# g to contain the slider
slider2_g = svg2.insert("g").attr("transform", "translate(0," + figh + ")")

# slider callback
slider2_callback = (sl) ->
    circle2.attr("cx", xscale2(sl.value()))

# insert slider
my_slider2 = d3panels.slider({
    height:slider_height
    width:width
    margin:{left:left_margin, right:right_margin, top:40, bottom:40, inner:0}})
my_slider2(slider2_g, slider2_callback, [d3.min(marker_pos), d3.max(marker_pos)], marker_pos, 63)

#####
# example from the documentation
#####

data = {x:[13,6,9,16,11,8], y:[28.6,10.3,22.8,30.9,15.1,22.8]}

svg3 = d3.select("div#chart3").insert("svg")
        .attr("height", 500).attr("width", 400)

mychart = d3panels.scatterplot({height:400, width:400})
mychart(svg3, data)

slider3_g = svg3.insert("g").attr("transform", "translate(0,400)")

my_slider3 = d3panels.slider({
    height:100
    width:400
    margin:{left:slider_margin, right:slider_margin, top:40, bottom:40, inner:0}})

callback3 = (sl) -> mychart.points().attr("opacity", sl.value())

my_slider3(slider3_g, callback3, [0,1], null, 0.8)
