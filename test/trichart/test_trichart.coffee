# illustration of use of the d3panels.trichart() function

# Example 1: simplest use
pts = [[1, 0, 0], [0,1,0], [0,0,1], [0.25, 0.5, 0.25], [0.5, 0.5, 0], [0.5, 0, 0.5], [0, 0.5, 0.5], [1/3, 1/3, 1/3]]
group = [1,1,1,2,3,3,3,4]

labels = ("(#{p[0]},#{p[1]},#{p[2]})" for p in pts)
labels[labels.length - 1] = "(1/3,1/3,1/3)"

mychart1 = d3panels.trichart()
mychart1(d3.select("div#chart1"), {p:pts, group:group, indID:labels})

# Example 2: random points centered around (1/4, 1/2, 1/4)

n = 100
m = 300
p = []
g = []
for i in d3.range(n)
    x = [0,0,0]
    for j in d3.range(m)
        r = Math.random()
        x[0] += 1 if r < 0.25
        x[1] += 1 if r >= 0.25 and r < 0.75
        x[2] += 1 if r >= 0.75
    x = (xv/m for xv in x)
    p.push(x)
    g.push(1)

for i in d3.range(n)
    x = [0,0,0]
    for j in d3.range(m)
        r = Math.random()
        x[0] += 1 if r < 1/3
        x[1] += 1 if r >= 1/3 and r < 2/3
        x[2] += 1 if r >= 2/3
    x = (xv/m for xv in x)
    p.push(x)
    g.push(2)

mychart2 = d3panels.trichart()
mychart2(d3.select("div#chart2"), {p:p, group:g})
