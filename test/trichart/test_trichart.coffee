# illustration of use of the d3panels.trichart() function

# Example 1: simplest use
pts = [[1, 0, 0], [0,1,0], [0,0,1], [0.25, 0.5, 0.25], [0.5, 0.5, 0], [0.5, 0, 0.5], [0, 0.5, 0.5], [1/3, 1/3, 1/3]]
group = [1,1,1,2,3,3,3,4]

labels = ("(#{p[0]},#{p[1]},#{p[2]})" for p in pts)
labels[labels.length - 1] = "(1/3,1/3,1/3)"

mychart1 = d3panels.trichart()
mychart1(d3.select("div#chart1"), {p:pts, group:group, indID:labels})
