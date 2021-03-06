# illustration of use of the crosstab function

# Example 1: two autosomal markers
d3.json("data.json").then (data) ->
    markers = ["D1M430", "D1M318"]
    mychart = d3panels.crosstab()

    data2pass =
            x: data.geno[markers[0]]
            y: data.geno[markers[1]]
            xcat: data.genocat[data.chrtype[markers[0]]]
            ycat: data.genocat[data.chrtype[markers[1]]]
            xlabel: markers[0]
            ylabel: markers[1]

    mychart(d3.select("div#chart1"), data2pass)

# Example 2: two X-linked markers
d3.json("data.json").then (data) ->
    markers = ["DXM64", "DXM66"]
    mychart = d3panels.crosstab()

    data2pass =
            x: data.geno[markers[0]]
            y: data.geno[markers[1]]
            xcat: data.genocat[data.chrtype[markers[0]]]
            ycat: data.genocat[data.chrtype[markers[1]]]
            xlabel: markers[0]
            ylabel: markers[1]

    mychart(d3.select("div#chart2"), data2pass)

# Example 3: an autosomal and an X-linked marker
d3.json("data.json").then (data) ->
    markers = ["D1M430", "DXM64"]
    mychart = d3panels.crosstab()

    data2pass =
            x: data.geno[markers[0]]
            y: data.geno[markers[1]]
            xcat: data.genocat[data.chrtype[markers[0]]]
            ycat: data.genocat[data.chrtype[markers[1]]]
            xlabel: markers[0]
            ylabel: markers[1]

    mychart(d3.select("div#chart3"), data2pass)
