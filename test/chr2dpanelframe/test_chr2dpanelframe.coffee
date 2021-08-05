# illustration of use of the chr2dpanelframe() function

# Example 1: simplest use
mychart1 = d3panels.chr2dpanelframe({title:"Defaults"})
mychart1(d3.select("div#chart1"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})


# Example 2: rectangles pink on hover
mychart2 = d3panels.chr2dpanelframe({title:"Select chromosomes on hover"})
mychart2(d3.select("div#chart2"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
chrSelect = mychart2.chrSelect()
chrSelect.on("mouseover", () -> d3.select(this).attr("fill", "#e9cfec")) # pink on hover
         .on("mouseout", (event,d) -> d3.select(this).attr("fill", ->
                                                        return "#d4d4d4" if d.odd
                                                        "#e6e6e6"))

# Example 3: chromosome 1 at top (and left) and lines between chromosomes
mychart3 = d3panels.chr2dpanelframe({
    title:"One at top; lines between chromosomes"
    xlab:"QTL position (Mbp)"
    ylab:"mRNA position (Mbp)"
    rectcolor:"white"
    altrectcolor:"white"
    chrlinecolor:"black"
    oneAtTop:true})
mychart3(d3.select("div#chart3"), {chr:[1,2,3,4,5],end:[100,90,70,50,50]})
chrSelect = mychart3.chrSelect()
chrSelect.on("mouseover", () -> d3.select(this).attr("fill", "#dff")) # pink on hover
         .on("mouseout", () -> d3.select(this).attr("fill", -> "white"))
