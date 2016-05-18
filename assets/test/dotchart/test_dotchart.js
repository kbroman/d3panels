// Generated by CoffeeScript 1.10.0
(function() {
  var group, h, halfh, halfw, i, margin, mychart15, mychart3, mychart4, n, ng, these_data, totalh, totalw, w, x, xv, y;

  h = 300;

  w = 400;

  margin = {
    left: 60,
    top: 40,
    right: 40,
    bottom: 40,
    inner: 5
  };

  halfh = h + margin.top + margin.bottom;

  totalh = halfh * 2;

  halfw = w + margin.left + margin.right;

  totalw = halfw * 2;

  d3.json("data.json", function(data) {
    var d, mychart, these_data;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Default",
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    mychart(d3.select("div#chart1"), these_data);
    return mychart.points().on("mouseover", function(d) {
      return d3.select(this).attr("r", 6);
    }).on("click", function(d) {
      return d3.select(this).attr("fill", "Orchid");
    }).on("mouseout", function(d) {
      return d3.select(this).attr("fill", "slateblue").attr("r", 3);
    });
  });

  d3.json("data.json", function(data) {
    var d, mychart, these_data;
    mychart = d3panels.dotchart({
      height: h,
      width: w,
      margin: margin,
      horizontal: true
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    mychart(d3.select("div#chart2"), these_data);
    return mychart.points().on("mouseover", function(d) {
      return d3.select(this).attr("r", 6);
    }).on("click", function(d) {
      return d3.select(this).attr("fill", "Orchid");
    }).on("mouseout", function(d) {
      return d3.select(this).attr("fill", "slateblue").attr("r", 3);
    });
  });

  mychart3 = d3panels.dotchart({
    title: "More data",
    height: h,
    width: w,
    margin: margin
  });

  ng = 4;

  n = 75 * ng;

  x = (function() {
    var j, ref, results;
    results = [];
    for (i = j = 1, ref = n; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      results.push(Math.ceil(Math.random() * ng));
    }
    return results;
  })();

  y = (function() {
    var j, len, results;
    results = [];
    for (j = 0, len = x.length; j < len; j++) {
      xv = x[j];
      results.push(Math.random() * 4 + 20 + xv);
    }
    return results;
  })();

  these_data = {
    x: x,
    y: y
  };

  mychart3(d3.select("div#chart3"), these_data);

  mychart3.points().on("mouseover", function(d) {
    return d3.select(this).attr("r", 6);
  }).on("click", function(d) {
    return d3.select(this).attr("fill", "Orchid");
  }).on("mouseout", function(d) {
    return d3.select(this).attr("fill", "slateblue").attr("r", 3);
  });

  mychart4 = d3panels.dotchart({
    title: "More data, horizontal",
    height: h,
    width: w,
    margin: margin,
    horizontal: true
  });

  mychart4(d3.select("div#chart4"), these_data);

  mychart4.points().on("mouseover", function(d) {
    return d3.select(this).attr("r", 6);
  }).on("click", function(d) {
    return d3.select(this).attr("fill", "Orchid");
  }).on("mouseout", function(d) {
    return d3.select(this).attr("fill", "slateblue").attr("r", 3);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Random jitter",
      jitter: 'random',
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    return mychart(d3.select("div#chart5"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Random jitter, horizontal",
      jitter: 'random',
      horizontal: true,
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    return mychart(d3.select("div#chart6"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "No jitter",
      jitter: 'none',
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    return mychart(d3.select("div#chart7"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "No jitter, horizontal",
      jitter: 'none',
      horizontal: true,
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    return mychart(d3.select("div#chart8"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Missing y values",
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    for (i in these_data.y) {
      if (Math.random() < 0.2) {
        these_data.y[i] = null;
      }
    }
    return mychart(d3.select("div#chart9"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Missing y values, horizontal",
      horizontal: true,
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    for (i in these_data.y) {
      if (Math.random() < 0.2) {
        these_data.y[i] = null;
      }
    }
    return mychart(d3.select("div#chart10"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Missing x values",
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    for (i in these_data.x) {
      if (Math.random() < 0.2) {
        these_data.x[i] = null;
      }
    }
    return mychart(d3.select("div#chart11"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Missing x values, horizontal",
      horizontal: true,
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    for (i in these_data.x) {
      if (Math.random() < 0.2) {
        these_data.x[i] = null;
      }
    }
    return mychart(d3.select("div#chart12"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Missing x and y values",
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    for (i in these_data.y) {
      if (Math.random() < 0.2) {
        these_data.x[i] = null;
      }
      if (Math.random() < 0.2) {
        these_data.y[i] = null;
      }
    }
    these_data.x[0] = null;
    these_data.y[0] = null;
    return mychart(d3.select("div#chart13"), these_data);
  });

  d3.json("data.json", function(data) {
    var d, mychart;
    mychart = d3panels.dotchart({
      xlab: "X",
      ylab: "Y",
      title: "Missing x and y values, horizontal",
      horizontal: true,
      height: h,
      width: w,
      margin: margin
    });
    these_data = {
      x: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[0]);
        }
        return results;
      })(),
      y: (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          d = data[j];
          results.push(d[1]);
        }
        return results;
      })()
    };
    for (i in these_data.y) {
      if (Math.random() < 0.2) {
        these_data.x[i] = null;
      }
      if (Math.random() < 0.2) {
        these_data.y[i] = null;
      }
    }
    these_data.x[0] = null;
    these_data.y[0] = null;
    return mychart(d3.select("div#chart14"), these_data);
  });

  mychart15 = d3panels.dotchart({
    title: "Color by group",
    height: h,
    width: w,
    margin: margin
  });

  ng = 4;

  n = 75 * ng;

  x = (function() {
    var j, ref, results;
    results = [];
    for (i = j = 1, ref = n; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      results.push(Math.ceil(Math.random() * ng));
    }
    return results;
  })();

  y = (function() {
    var j, len, results;
    results = [];
    for (j = 0, len = x.length; j < len; j++) {
      xv = x[j];
      results.push(Math.random() * 4 + 20 + xv);
    }
    return results;
  })();

  group = (function() {
    var j, len, results;
    results = [];
    for (j = 0, len = x.length; j < len; j++) {
      xv = x[j];
      results.push(Math.random() < 0.5 ? 1 : 2);
    }
    return results;
  })();

  these_data = {
    x: x,
    y: y,
    group: group
  };

  mychart15(d3.select("div#chart15"), these_data);

}).call(this);
