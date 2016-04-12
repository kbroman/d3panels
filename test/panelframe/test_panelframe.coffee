# illustration of use of the cichart function

# Example 1: simplest use
mychart1 = panelframe({title:"No NAs"})
d3.select("div#chart1")
  .call(mychart1)

# Example 2: xNA box, and thicker hlines (underneath vlines)
mychart2 = panelframe({
    xNA:true,
    title:"X-axis NAs",
    ylim:[0.5,3.5],
    yticks:[1,2,3],
    yticklab:["A","H","B"],
    ylab: "Group",
    hlineOpts:
        width:4,
        color:"#999",
    v_over_h:true})
d3.select("div#chart2")
  .call(mychart2)

# Example 3: yNA box and thicker vlines
mychart3 = panelframe({
    yNA:true,
    title:"Y-axis NAs",
    vlineOpts:
        width:4,
        color:"#999",
    xlim:[0.5,3.5],
    xticks:[1,2,3],
    xticklab:["A", "H", "B"],
    xlab:"Group"})
d3.select("div#chart3")
  .call(mychart3)

# Example 4: both xNA and yNA boxes, no vertical lines
mychart4 = panelframe({
    xNA:true,
    yNA:true,
    title:"X- and Y-axis NAs",
    vlineOpts:
        width:0,
        color:null})
d3.select("div#chart4")
  .call(mychart4)

# Example 5: both xNA and yNA boxes, dark lines
mychart5 = panelframe({
    xNA:true,
    yNA:true,
    title:"X- and Y-axis NAs + dark grid",
    vlineOpts:
        width:4,
        color:"#999",
    hlineOpts:
        width:4,
        color:"#999"})
d3.select("div#chart5")
  .call(mychart5)
