// Generated by CoffeeScript 1.9.0
var crosstab;

crosstab = function() {
  var bordercolor, cellHeight, cellPad, cellWidth, chart, fontsize, hilitcolor, margin, rectcolor, title, titlepos;
  cellHeight = 30;
  cellWidth = 80;
  cellPad = 20;
  margin = {
    left: 60,
    top: 80,
    right: 40,
    bottom: 20
  };
  titlepos = 50;
  title = "";
  fontsize = cellHeight * 0.7;
  rectcolor = "#e6e6e6";
  hilitcolor = "#e9cfec";
  bordercolor = "black";
  chart = function(selection) {
    return selection.each(function(data) {
      var borders, cell, cells, collab, colrect, denom, g, gEnter, height, i, j, n, ncol, nrow, rect, rowlab, rowrect, svg, tab, titles, values, width, xscale, yscale, _i, _j, _k, _l, _ref, _ref1, _ref2, _ref3, _results, _results1;
      n = data.x.length;
      if (data.y.length !== n) {
        displayError("data.x.length [" + data.x.length + "] != data.y.length [" + data.y.length + "]");
      }
      ncol = data.xcat.length;
      if (d3.max(data.x) >= ncol || d3.min(data.x) < 0) {
        displayError("data.x should be in range 0-" + (ncol - 1) + " [was " + (d3.min(data.x)) + " - " + (d3.max(data.x)) + "]");
      }
      nrow = data.ycat.length;
      if (d3.max(data.y) >= nrow || d3.min(data.y) < 0) {
        displayError("data.y should be in range 0-" + (nrow - 1) + " [was " + (d3.min(data.y)) + " - " + (d3.max(data.y)) + "]");
      }
      tab = calc_crosstab(data);
      data.xlabel = (_ref = data != null ? data.xlabel : void 0) != null ? _ref : "";
      data.ylabel = (_ref1 = data != null ? data.ylabel : void 0) != null ? _ref1 : "";
      cells = [];
      for (i = _i = 0; 0 <= nrow ? _i <= nrow : _i >= nrow; i = 0 <= nrow ? ++_i : --_i) {
        for (j = _j = 0; 0 <= ncol ? _j <= ncol : _j >= ncol; j = 0 <= ncol ? ++_j : --_j) {
          cell = {
            value: tab[i][j],
            row: i,
            col: j,
            shaded: false,
            rowpercent: "",
            colpercent: ""
          };
          if (i < nrow - 1 && (j < ncol - 1 || j === ncol)) {
            cell.shaded = true;
          }
          if (j < ncol - 1 && (i < nrow - 1 || i === nrow)) {
            cell.shaded = true;
          }
          if (i < nrow - 1) {
            denom = tab[nrow][j] - tab[nrow - 1][j];
            cell.colpercent = denom > 0 ? (Math.round(100 * tab[i][j] / denom)) + "%" : "\u2014";
          } else if (i === nrow - 1) {
            denom = tab[nrow][j];
            cell.colpercent = denom > 0 ? "(" + (Math.round(100 * tab[i][j] / denom)) + "%)" : "\u2014";
          } else {
            cell.colpercent = cell.value;
          }
          if (j < ncol - 1) {
            denom = tab[i][ncol] - tab[i][ncol - 1];
            cell.rowpercent = denom > 0 ? (Math.round(100 * tab[i][j] / denom)) + "%" : "\u2014";
          } else if (j === ncol - 1) {
            denom = tab[i][ncol];
            cell.rowpercent = denom > 0 ? "(" + (Math.round(100 * tab[i][j] / denom)) + "%)" : "\u2014";
          } else {
            cell.rowpercent = cell.value;
          }
          cells.push(cell);
        }
      }
      width = margin.left + margin.right + (ncol + 2) * cellWidth;
      height = margin.top + margin.bottom + (nrow + 2) * cellHeight;
      xscale = d3.scale.ordinal().domain((function() {
        _results = [];
        for (var _k = 0, _ref2 = ncol + 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; 0 <= _ref2 ? _k++ : _k--){ _results.push(_k); }
        return _results;
      }).apply(this)).rangeBands([margin.left, width - margin.right], 0, 0);
      yscale = d3.scale.ordinal().domain((function() {
        _results1 = [];
        for (var _l = 0, _ref3 = nrow + 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; 0 <= _ref3 ? _l++ : _l--){ _results1.push(_l); }
        return _results1;
      }).apply(this)).rangeBands([margin.top, height - margin.bottom], 0, 0);
      svg = d3.select(this).selectAll("svg").data([data]);
      gEnter = svg.enter().append("svg").attr("class", "d3panels").append("g");
      svg.attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom);
      g = svg.select("g");
      rect = g.append("g").attr("id", "value_rect");
      rect.selectAll("empty").data(cells).enter().append("rect").attr("x", function(d) {
        return xscale(d.col + 1);
      }).attr("y", function(d) {
        return yscale(d.row + 1);
      }).attr("width", cellWidth).attr("height", cellHeight).attr("fill", function(d) {
        if (d.shaded) {
          return rectcolor;
        } else {
          return "none";
        }
      }).attr("stroke", function(d) {
        if (d.shaded) {
          return rectcolor;
        } else {
          return "none";
        }
      }).attr("stroke-width", 0).style("pointer-events", "none");
      values = g.append("g").attr("id", "values");
      values.selectAll("empty").data(cells).enter().append("text").attr("x", function(d) {
        return xscale(d.col + 1) + cellWidth - cellPad;
      }).attr("y", function(d) {
        return yscale(d.row + 1) + cellHeight / 2;
      }).text(function(d) {
        return d.value;
      }).attr("class", function(d) {
        return "crosstab row" + d.row + " col" + d.col;
      }).style("font-size", fontsize).style("pointer-events", "none");
      colrect = g.append("g").attr("id", "colrect");
      colrect.selectAll("empty").data(data.xcat.concat("Total")).enter().append("rect").attr("x", function(d, i) {
        return xscale(i + 1);
      }).attr("y", yscale(0)).attr("width", cellWidth).attr("height", cellHeight).attr("fill", "white").attr("stroke", "white").on("mouseover", function(d, i) {
        d3.select(this).attr("fill", hilitcolor).attr("stroke", hilitcolor);
        return values.selectAll(".col" + i).text(function(d) {
          return d.colpercent;
        });
      }).on("mouseout", function(d, i) {
        d3.select(this).attr("fill", "white").attr("stroke", "white");
        return values.selectAll("text.col" + i).text(function(d) {
          return d.value;
        });
      });
      collab = g.append("g").attr("id", "collab");
      collab.selectAll("empty").data(data.xcat.concat("Total")).enter().append("text").attr("x", function(d, i) {
        return xscale(i + 1) + cellWidth - cellPad;
      }).attr("y", yscale(0) + cellHeight / 2).text(function(d) {
        return d;
      }).attr("class", "crosstab").style("font-size", fontsize).style("pointer-events", "none");
      rowrect = g.append("g").attr("id", "rowrect");
      rowrect.selectAll("empty").data(data.ycat.concat("Total")).enter().append("rect").attr("x", xscale(0)).attr("y", function(d, i) {
        return yscale(i + 1);
      }).attr("width", cellWidth).attr("height", cellHeight).attr("fill", "white").attr("stroke", "white").on("mouseover", function(d, i) {
        d3.select(this).attr("fill", hilitcolor).attr("stroke", hilitcolor);
        return values.selectAll(".row" + i).text(function(d) {
          return d.rowpercent;
        });
      }).on("mouseout", function(d, i) {
        d3.select(this).attr("fill", "white").attr("stroke", "white");
        return values.selectAll(".row" + i).text(function(d) {
          return d.value;
        });
      });
      rowlab = g.append("g").attr("id", "rowlab");
      rowlab.selectAll("empty").data(data.ycat.concat("Total")).enter().append("text").attr("x", xscale(0) + cellWidth - cellPad).attr("y", function(d, i) {
        return yscale(i + 1) + cellHeight / 2;
      }).text(function(d) {
        return d;
      }).attr("class", "crosstab").style("font-size", fontsize).style("pointer-events", "none");
      borders = g.append("g").attr("id", "borders");
      borders.append("rect").attr("x", xscale(1)).attr("y", yscale(1)).attr("width", cellWidth * ncol).attr("height", cellHeight * nrow).attr("fill", "none").attr("stroke", bordercolor).attr("stroke-width", 2).style("pointer-events", "none");
      borders.append("rect").attr("x", xscale(ncol + 1)).attr("y", yscale(nrow + 1)).attr("width", cellWidth).attr("height", cellHeight).attr("fill", "none").attr("stroke", bordercolor).attr("stroke-width", 2).style("pointer-events", "none");
      titles = g.append("g").attr("id", "titles");
      titles.append("text").attr("class", "crosstabtitle").attr("x", margin.left + (ncol + 1) * cellWidth / 2).attr("y", margin.top - cellHeight / 2).text(data.xlabel).style("font-size", fontsize).style("font-weight", "bold");
      titles.append("text").attr("class", "crosstab").attr("x", xscale(0) + cellWidth - cellPad).attr("y", yscale(0) + cellHeight / 2).text(data.ylabel).style("font-size", fontsize).style("font-weight", "bold");
      return titles.append("text").attr("class", "crosstabtitle").attr("x", margin.left + (width - margin.left - margin.right) / 2).attr("y", margin.top - titlepos).text(title).style("font-size", fontsize);
    });
  };
  chart.cellHeight = function(value) {
    if (!arguments.length) {
      return cellHeight;
    }
    cellHeight = value;
    return chart;
  };
  chart.cellWidth = function(value) {
    if (!arguments.length) {
      return cellWidth;
    }
    cellWidth = value;
    return chart;
  };
  chart.cellPad = function(value) {
    if (!arguments.length) {
      return cellPad;
    }
    cellPad = value;
    return chart;
  };
  chart.margin = function(value) {
    if (!arguments.length) {
      return margin;
    }
    margin = value;
    return chart;
  };
  chart.titlepos = function(value) {
    if (!arguments.length) {
      return titlepos;
    }
    titlepos = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.rectcolor = function(value) {
    if (!arguments.length) {
      return rectcolor;
    }
    rectcolor = value;
    return chart;
  };
  chart.hilitcolor = function(value) {
    if (!arguments.length) {
      return hilitcolor;
    }
    hilitcolor = value;
    return chart;
  };
  chart.bordercolor = function(value) {
    if (!arguments.length) {
      return bordercolor;
    }
    bordercolor = value;
    return chart;
  };
  chart.fontsize = function(value) {
    if (!arguments.length) {
      return fontsize;
    }
    fontsize = value;
    return chart;
  };
  return chart;
};
