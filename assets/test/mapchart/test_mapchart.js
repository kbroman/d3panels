// Generated by CoffeeScript 1.12.6
(function() {
  d3.json("data.json", function(data) {
    var mychart;
    mychart = d3panels.mapchart();
    return mychart(d3.select("div#chart1"), data);
  });

  d3.json("data.json", function(data) {
    var mychart;
    mychart = d3panels.mapchart({
      horizontal: true,
      height: 600
    });
    return mychart(d3.select("div#chart2"), data);
  });

  d3.json("data.json", function(data) {
    var mychart;
    mychart = d3panels.mapchart({
      title: "Shifted start",
      shiftStart: true
    });
    return mychart(d3.select("div#chart3"), data);
  });

  d3.json("data.json", function(data) {
    var mychart;
    mychart = d3panels.mapchart({
      title: "Backwards order"
    });
    data.chrname = d3panels.unique(data.chr).reverse();
    return mychart(d3.select("div#chart4"), data);
  });

}).call(this);
