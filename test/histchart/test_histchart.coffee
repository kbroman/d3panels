# illustration of use of the d3panels.histchart() function

# Example 1: simplest use
x = [(Math.random()*3+10 for i in d3.range(1000)),
     (Math.random()*3+12 for i in d3.range(1000))]

mychart1 = d3panels.histchart()
mychart1(d3.select("div#chart1"), {x:x, breaks:64, indID:['U(10,13)','U(12,15)']})
