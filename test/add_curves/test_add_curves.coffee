# illustration of use of the heatmap function

h = 300
w = 500

# Example: simplest use
data = {x:[[6,8,9,11,13,16]], y:[[10.3,22.8,22.9,32.1,28.6,30.9]]}

myframe = d3panels.panelframe({height:h, width:w, xlim:[5,17], ylim:[8.3,32.9]})
myframe(d3.select('div#chart1'))

add_curve = d3panels.add_curves({linecolor:"slateblue"})
add_curve(myframe, data)

# Example: multiple curves
d3.json "data.json", (data) ->
    xlim = d3panels.matrixExtent(data.x)
    ylim = d3panels.matrixExtent(data.y)

    myframe = d3panels.panelframe({
        height:600
        width:900
        xlab:"Age (weeks)"
        ylab:"Body weight"
        xlim:xlim
        ylim:ylim})
    myframe(d3.select('div#chart2'))

    add_curves = d3panels.add_curves({linewidthhilit:4})
    add_curves(myframe, data)
