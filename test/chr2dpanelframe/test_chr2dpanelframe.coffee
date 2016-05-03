# illustration of use of the chr2dpanelframe() function

# Example 1: simplest use
mychart1 = chr2dpanelframe({title:"Defaults"})
mychart1(d3.select("div#chart1"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})


# Example 2: rectangles pink on hover
mychart2 = chr2dpanelframe({title:"Select chromosomes on hover"})
mychart2(d3.select("div#chart2"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
chrSelect = mychart2.chrSelect()
chrSelect.on("mouseover", () -> d3.select(this).attr("fill", "#e9cfec")) # pink on hover
         .on("mouseout", (d) -> d3.select(this).attr("fill", ->
                                                        return "#d4d4d4" if d.odd
                                                        "#e6e6e6"))

# Example 3: chromosome 1 at top (and left)
mychart3 = chr2dpanelframe({title:"One at top", oneAtTop:true})
mychart3(d3.select("div#chart3"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
