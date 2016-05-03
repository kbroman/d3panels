# illustration of use of the chr2dpanelframe() function

# Example 1: simplest use
mychart1 = chr2dpanelframe({title:"Defaults",ylim:[0,5]})
mychart1(d3.select("div#chart1"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})


# Example 2: rectangles pink on hover
mychart2 = chr2dpanelframe({title:"Select chromosomes on hover", ylim:[0,5]})
mychart2(d3.select("div#chart2"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
chrSelect = mychart2.chrSelect()
chrSelect.on("mouseover", () -> d3.select(this).attr("fill", "#e9cfec")) # pink on hover
         .on("mouseout", (d,i) -> d3.select(this).attr("fill", ->
             return "#e6e6e6" if i % 2 == 0
             "#d4d4d4"))
