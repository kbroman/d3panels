# illustration of use of the cichart function

# Example 1: simplest use
mychart1 = panelframe({title:"No NAs"})
mychart1(d3.select("div#chart1"))

# Example 2: xNA box, and thicker ylines (underneath xlines)
mychart2 = panelframe({
    xNA:true
    title:"X-axis NAs"
    ylim:[0.5,3.5]
    yticks:[1,2,3]
    yticklab:["A","H","B"]
    ylab: "Group"
    ylineOpts:
        width:4
        color:"#CDCDCD"
    v_over_h:true})
mychart2(d3.select("div#chart2"))

# add some points to this one
svg = mychart2.svg()
xscale = mychart2.xscale()
yscale = mychart2.yscale()
data = [{x:0.2, y:1}, {x:0.4, y:2}, {x:0.6, y:3}, {x:0.8, y:1}]
svg.append("g").attr("id", "pointgroup")
   .selectAll("empty")
   .data(data)
   .enter()
   .append("circle")
   .attr("fill", "slateblue")
   .attr("stroke", "black")
   .attr("r", 5)
   .attr("cx", (d) -> xscale(d.x))
   .attr("cy", (d) -> yscale(d.y))

# Example 3: yNA box and thicker xlines
mychart3 = panelframe({
    yNA:true
    title:"Y-axis NAs"
    xlineOpts:
        width:4
        color:"#CDCDCD"
    xlim:[0.5,3.5]
    xticks:[1,2,3]
    xticklab:["A", "H", "B"]
    xlab:"Group"})
mychart3(d3.select("div#chart3"))

# Example 4: both xNA and yNA boxes, no vertical lines
mychart4 = panelframe({
    xNA:true
    yNA:true
    title:"X- and Y-axis NAs"
    xlineOpts:
        width:0
        color:null})
mychart4(d3.select("div#chart4"))

# Example 5: both xNA and yNA boxes, dark lines
mychart5 = panelframe({
    xNA:true
    yNA:true
    title:"X- and Y-axis NAs + dark grid"
    xlineOpts:
        width:4
        color:"#CDCDCD"
    ylineOpts:
        width:4
        color:"#CDCDCD"})
mychart5(d3.select("div#chart5"))
