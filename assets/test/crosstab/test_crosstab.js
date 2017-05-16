// Generated by CoffeeScript 1.12.6
(function() {
  d3.json("data.json", function(data) {
    var data2pass, markers, mychart;
    markers = ["D1M430", "D1M318"];
    mychart = d3panels.crosstab();
    data2pass = {
      x: data.geno[markers[0]],
      y: data.geno[markers[1]],
      xcat: data.genocat[data.chrtype[markers[0]]],
      ycat: data.genocat[data.chrtype[markers[1]]],
      xlabel: markers[0],
      ylabel: markers[1]
    };
    return mychart(d3.select("div#chart1"), data2pass);
  });

  d3.json("data.json", function(data) {
    var data2pass, markers, mychart;
    markers = ["DXM64", "DXM66"];
    mychart = d3panels.crosstab();
    data2pass = {
      x: data.geno[markers[0]],
      y: data.geno[markers[1]],
      xcat: data.genocat[data.chrtype[markers[0]]],
      ycat: data.genocat[data.chrtype[markers[1]]],
      xlabel: markers[0],
      ylabel: markers[1]
    };
    return mychart(d3.select("div#chart2"), data2pass);
  });

  d3.json("data.json", function(data) {
    var data2pass, markers, mychart;
    markers = ["D1M430", "DXM64"];
    mychart = d3panels.crosstab();
    data2pass = {
      x: data.geno[markers[0]],
      y: data.geno[markers[1]],
      xcat: data.genocat[data.chrtype[markers[0]]],
      ycat: data.genocat[data.chrtype[markers[1]]],
      xlabel: markers[0],
      ylabel: markers[1]
    };
    return mychart(d3.select("div#chart3"), data2pass);
  });

}).call(this);
