# illustration of use of the cichart function

# Example 1: simplest use
mychart = frame({title:"No NAs"})
d3.select("div#chart1")
  .call(mychart)

# Example 2: xNA box
mychart = frame({xNA:true, title:"X-axis NAs"})
d3.select("div#chart2")
  .call(mychart)

# Example 3: yNA box
mychart = frame({yNA:true, title:"Y-axis NAs"})
d3.select("div#chart3")
  .call(mychart)

# Example 4: both xNA and yNA boxes
mychart = frame({xNA:true, yNA:true, title:"X- and Y-axis NAs"})
d3.select("div#chart4")
  .call(mychart)
