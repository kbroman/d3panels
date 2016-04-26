# illustration of use of the lodpanelframe() function

# Example 1: simplest use
mychart1 = lodpanelframe({title:"Defaults",ylim:[0,5]})
mychart1(d3.select("div#chart1"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})


# Example 2: constant background color
mychart2 = lodpanelframe({title:"No alternating rectangles", ylim:[0,5], rectcolor:"#e6e6e6", altrectcolor:"#e6e6e6"})
mychart2(d3.select("div#chart2"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})

# Example 3: rectangles pink on hover
mychart3 = lodpanelframe(title:"Select chromosomes on hover", {ylim:[0,5]})
mychart3(d3.select("div#chart3"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
chrSelect = mychart3.chrSelect()
chrSelect.on("mouseover", () -> d3.select(this).attr("fill", "#e9cfec")) # pink on hover
         .on("mouseout", (d,i) -> d3.select(this).attr("fill", ->
             return "#e6e6e6" if i % 2 == 0
             "#d4d4d4"))
