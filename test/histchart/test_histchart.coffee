# illustration of use of the d3panels.histchart() function

# Example 1: simplest use
x = [(Math.random()*3+10 for i in d3.range(1000)),
     (Math.random()*3+12 for i in d3.range(1000))]

mychart1 = d3panels.histchart({xlab:"Measurements", ylab:"Density"})
mychart1(d3.select("div#chart1"), {x:x, breaks:64, indID:['U(10,13)','U(12,15)']})

# Example 2: random normals
norm10 = d3.random.normal(10, 3)
norm12 = d3.random.normal(12, 3)
y = [(norm10() for i in d3.range(1000)),
     (norm12() for i in d3.range(1000))]

mychart2 = d3panels.histchart({density:false, xlab:"Measurements", ylab:"Count"})
mychart2(d3.select("div#chart2"), {x:y, breaks:41, indID:['N(10,3)','N(12,3)']})
