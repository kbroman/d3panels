// Generated by CoffeeScript 1.9.0
(function() {
  d3.json("data.json", function(data) {
    var mychart;
    mychart = chrheatmap().pixelPerCell(20).chrGap(4);
    return d3.select("div#chart1").datum(data).call(mychart);
  });

  d3.json("data.json", function(data) {
    var mychart;
    mychart = chrheatmap().pixelPerCell(20).chrGap(4).oneAtTop(true);
    return d3.select("div#chart2").datum(data).call(mychart);
  });

}).call(this);