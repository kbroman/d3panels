# illustration of use of the d3panels.trichart() function

# Example 1: simplest use
pts = [[1, 0, 0], [0,1,0], [0,0,1], [0.25, 0.5, 0.25], [0.5, 0.5, 0], [0.5, 0, 0.5], [0, 0.5, 0.5]]

mychart1 = d3panels.trichart()
mychart1(d3.select("div#chart1"), {p:pts})
