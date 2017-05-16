// Generated by CoffeeScript 1.12.6
(function() {
  var i, mychart1, mychart2, norm10, norm12, x, y;

  x = [
    (function() {
      var j, len, ref, results;
      ref = d3.range(1000);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        i = ref[j];
        results.push(Math.random() * 3 + 10);
      }
      return results;
    })(), (function() {
      var j, len, ref, results;
      ref = d3.range(1000);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        i = ref[j];
        results.push(Math.random() * 3 + 12);
      }
      return results;
    })()
  ];

  mychart1 = d3panels.histchart({
    xlab: "Measurements",
    ylab: "Density"
  });

  mychart1(d3.select("div#chart1"), {
    x: x,
    breaks: 64,
    indID: ['U(10,13)', 'U(12,15)']
  });

  norm10 = d3.randomNormal(10, 3);

  norm12 = d3.randomNormal(12, 3);

  y = [
    (function() {
      var j, len, ref, results;
      ref = d3.range(1000);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        i = ref[j];
        results.push(norm10());
      }
      return results;
    })(), (function() {
      var j, len, ref, results;
      ref = d3.range(1000);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        i = ref[j];
        results.push(norm12());
      }
      return results;
    })()
  ];

  mychart2 = d3panels.histchart({
    density: false,
    xlab: "Measurements",
    ylab: "Count"
  });

  mychart2(d3.select("div#chart2"), {
    x: y,
    breaks: 41,
    indID: ['N(10,3)', 'N(12,3)']
  });

}).call(this);
