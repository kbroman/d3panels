# illustration of use of the chrpanelframe() function

# Example 1: simplest use
mychart1 = chrpanelframe({title:"Defaults",ylim:[0,5]})
mychart1(d3.select("div#chart1"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})


# Example 2: constant background color
mychart2 = chrpanelframe({title:"No alternating rectangles", ylim:[0,5], rectcolor:"#e6e6e6", altrectcolor:"#e6e6e6"})
mychart2(d3.select("div#chart2"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})

# Example 3: rectangles pink on hover
mychart3 = chrpanelframe({title:"Select chromosomes on hover", ylim:[0,5]})
mychart3(d3.select("div#chart3"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
chrSelect = mychart3.chrSelect()
chrSelect.on("mouseover", () -> d3.select(this).attr("fill", "#e9cfec")) # pink on hover
         .on("mouseout", (d,i) -> d3.select(this).attr("fill", ->
             return "#e6e6e6" if i % 2 == 0
             "#d4d4d4"))

# Example 4: add some points
mychart4 = chrpanelframe({title:"Add some points using add_lodcurve()", ylim:[0,5]})
mychart4(d3.select("div#chart4"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
addpoints = add_lodcurve({linewidth:0, pointsize:4, pointcolor:"slateblue", pointstroke:"white"})
addpoints(mychart4, {
    chr:[1,2,2,3,4,5,5]
    pos:[52.45, 11.91, 55.93, 1.56, 49.34, 38.84, 21.68]
    lod:[3.342, 4.102, 3.002, 0.420, 2.654, 1.731, 2.246]
    marker:["1", "2", "3", "4", "5", "6", "7"]})

# Example 5: horizontal
mychart5 = chrpanelframe({title:"Horizontal",ylim:[0,5],height:800,width:600,horizontal:true})
mychart5(d3.select("div#chart5"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
