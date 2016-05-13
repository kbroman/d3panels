# crosstab: Display of a cross-tabulation (a two-way table)

d3panels.crosstab = (chartOpts) ->
    chartOpts = {} unless chartOpts? # make sure it's defined

    # chartOpts start
    width = chartOpts?.width ? 600                # overall width of chart in pixels
    height = chartOpts?.height ? 300               # overall height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:80, right:40, bottom: 20} # margins in pixels
    cellPad = chartOpts?.cellPad ? null            # padding of cells (if null, we take cell width * 0.1)
    titlepos = chartOpts?.titlepos ? 50            # position of title in pixels
    title = chartOpts?.title ? ""                  # chart title
    fontsize = chartOpts?.fontsize ? null          # font size (if null, we take cell height * 0.5)
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"   # color of rectangle
    hilitcolor = chartOpts?.hilitcolor ? "#e9cfec" # color of rectangle when highlighted
    bordercolor = chartOpts?.bordercolor ? "black" # color of borders
    # chartOpts end
    # accessors start
    rowrect = null # row header rectangle selection
    colrect = null # col header rectangle selection
    svg = null     # SVG selection
    # accessors end

    ## the main function
    chart = (selection, data) -> # {x, y, xcat, ycat, xlabel, ylabel} (xcat, ycat, xlabel, ylabel are optional; x and y in {0,1,2,...})

        d3panels.displayError("crosstab: data.x is missing") unless data.x?
        d3panels.displayError("crosstab: data.y is missing") unless data.y?

        n = data.x.length
        if data.y.length != n
            d3panels.displayError("crosstab: data.x.length [#{data.x.length}] != data.y.length [#{data.y.length}]")

        data.xcat = data?.xcat ? (xv+1 for xv in d3.range(d3.max(data.x)))
        data.ycat = data?.ycat ? (yv+1 for yv in d3.range(d3.max(data.y)))

        ncol = data.xcat.length
        if d3.max(data.x) > ncol or d3.min(data.x) <= 0
            d3panels.displayError("crosstab: data.x should be in range 1-#{ncol} [was #{d3.min(data.x)} - #{d3.max(data.x)}]")
        nrow = data.ycat.length
        if d3.max(data.y) > nrow or d3.min(data.y) <= 0
            d3panels.displayError("crosstab: data.y should be in range 1-#{nrow} [was #{d3.min(data.y)} - #{d3.max(data.y)}]")

        # convert x and y to 0,1,2,...
        data.x = (xv-1 for xv in data.x)
        data.y = (yv-1 for yv in data.y)

        tab = d3panels.calc_crosstab(data)

        # in case labels weren't provided
        data.xlabel = data?.xlabel ? ""
        data.ylabel = data?.ylabel ? ""

        # turn it into a vector of cells
        cells = []
        for i in [0..nrow]
            for j in [0..ncol]
                cell = {value:tab[i][j], row:i, col:j, shaded: false, rowpercent: "", colpercent: ""}
                if (i < nrow-1 and (j < ncol-1 or j==ncol))
                    cell.shaded = true
                if (j < ncol-1 and (i < nrow-1 or i==nrow))
                    cell.shaded = true
                if i < nrow-1
                    denom = tab[nrow][j] - tab[nrow-1][j]
                    cell.colpercent = if denom > 0 then "#{Math.round(100*tab[i][j]/denom)}%" else "\u2014"
                else if i == nrow-1
                    denom = tab[nrow][j]
                    cell.colpercent = if denom > 0 then "(#{Math.round(100*tab[i][j]/denom)}%)" else "\u2014"
                else
                    cell.colpercent = cell.value
                if j < ncol-1
                    denom = tab[i][ncol] - tab[i][ncol-1]
                    cell.rowpercent = if denom > 0 then "#{Math.round(100*tab[i][j]/denom)}%" else "\u2014"
                else if j == ncol-1
                    denom = tab[i][ncol]
                    cell.rowpercent = if denom > 0 then "(#{Math.round(100*tab[i][j]/denom)}%)" else "\u2014"
                else
                    cell.rowpercent = cell.value
                cells.push(cell)

        # widths and heights
        plot_width = width - margin.left - margin.right
        plot_height = height - margin.top - margin.bottom
        cellWidth = plot_width/(ncol+2)
        cellHeight = plot_height/(nrow+2)
        fontsize = fontsize ? cellHeight*0.5
        cellPad = cellPad ? cellWidth*0.1

        xscale = d3.scale.ordinal()
                         .domain([0..(ncol+1)])
                         .rangeBands([margin.left, width-margin.right], 0, 0)
        yscale = d3.scale.ordinal()
                         .domain([0..(nrow+1)])
                         .rangeBands([margin.top, height-margin.bottom], 0, 0)

        # Select the svg element, if it exists.
        svg = selection.append("svg")
                       .attr("width", width)
                       .attr("height", height)
                       .attr("class", "d3panels")

        # rectangles for body of table
        rect = svg.append("g").attr("id", "value_rect")
        rect.selectAll("empty")
            .data(cells)
            .enter()
            .append("rect")
            .attr("x", (d) -> xscale(d.col+1))
            .attr("y", (d) -> yscale(d.row+1))
            .attr("width", cellWidth)
            .attr("height", cellHeight)
            .attr("fill", (d) -> if d.shaded then rectcolor else "none")
            .attr("stroke", (d) -> if d.shaded then rectcolor else "none")
            .attr("stroke-width", 0)
            .style("pointer-events", "none")
            .attr("shape-rendering", "crispEdges")

        # text for the body of the table
        values = svg.append("g").attr("id", "values")
        values.selectAll("empty")
              .data(cells)
              .enter()
              .append("text")
              .attr("x", (d) -> xscale(d.col+1) + cellWidth - cellPad)
              .attr("y", (d) -> yscale(d.row+1) + cellHeight/2)
              .text((d) -> d.value)
              .attr("class", (d) -> "crosstab row#{d.row} col#{d.col}")
              .style("font-size", fontsize)
              .style("pointer-events", "none")

        # rectangles for the column headings
        colrect = svg.append("g").attr("id", "colrect")
        colrect.selectAll("empty")
               .data((data.xcat).concat("Total"))
               .enter()
               .append("rect")
               .attr("x", (d,i) -> xscale(i+1))
               .attr("y", yscale(0))
               .attr("width", cellWidth)
               .attr("height", cellHeight)
               .attr("fill", "white")
               .attr("stroke", "white")
               .attr("shape-rendering", "crispEdges")
               .on "mouseover", (d,i) ->
                    d3.select(this).attr("fill", hilitcolor).attr("stroke", hilitcolor)
                    values.selectAll(".col#{i}").text((d) -> d.colpercent)
               .on "mouseout", (d,i) ->
                    d3.select(this).attr("fill", "white").attr("stroke", "white")
                    values.selectAll("text.col#{i}").text((d) -> d.value)

        # labels in the column headings
        collab = svg.append("g").attr("id", "collab")
        collab.selectAll("empty")
              .data((data.xcat).concat("Total"))
              .enter()
              .append("text")
              .attr("x", (d,i) -> xscale(i+1) + cellWidth - cellPad)
              .attr("y", yscale(0)+cellHeight/2)
              .text((d) -> d)
              .attr("class", "crosstab")
              .style("font-size", fontsize)
              .style("pointer-events", "none")

        # rectangles for the row headings
        rowrect = svg.append("g").attr("id", "rowrect")
        rowrect.selectAll("empty")
               .data((data.ycat).concat("Total"))
               .enter()
               .append("rect")
               .attr("x", xscale(0))
               .attr("y", (d,i) -> yscale(i+1))
               .attr("width", cellWidth)
               .attr("height", cellHeight)
               .attr("fill", "white")
               .attr("stroke", "white")
               .attr("shape-rendering", "crispEdges")
               .on "mouseover", (d,i) ->
                    d3.select(this).attr("fill", hilitcolor).attr("stroke", hilitcolor)
                    values.selectAll(".row#{i}").text((d) -> d.rowpercent)
               .on "mouseout", (d,i) ->
                    d3.select(this).attr("fill", "white").attr("stroke", "white")
                    values.selectAll(".row#{i}").text((d) -> d.value)

        # labels in the column headings
        rowlab = svg.append("g").attr("id", "rowlab")
        rowlab.selectAll("empty")
              .data((data.ycat).concat("Total"))
              .enter()
              .append("text")
              .attr("x", xscale(0) + cellWidth - cellPad)
              .attr("y", (d,i) -> yscale(i+1) + cellHeight/2)
              .text((d) -> d)
              .attr("class", "crosstab")
              .style("font-size", fontsize)
              .style("pointer-events", "none")

        # border around central part
        borders = svg.append("g").attr("id", "borders")
        borders.append("rect")
               .attr("x", xscale(1))
               .attr("y", yscale(1))
               .attr("width", cellWidth*ncol)
               .attr("height", cellHeight*nrow)
               .attr("fill", "none")
               .attr("stroke", bordercolor)
               .attr("stroke-width", 2)
               .style("pointer-events", "none")
               .attr("shape-rendering", "crispEdges")
        # border around overall total
        borders.append("rect")
               .attr("x", xscale(ncol+1))
               .attr("y", yscale(nrow+1))
               .attr("width", cellWidth)
               .attr("height", cellHeight)
               .attr("fill", "none")
               .attr("stroke", bordercolor)
               .attr("stroke-width", 2)
               .style("pointer-events", "none")
               .attr("shape-rendering", "crispEdges")

        # row and column headings and optional overall title
        titles = svg.append("g").attr("id", "titles")
        titles.append("text").attr("class", "crosstabtitle")
              .attr("x", margin.left + (ncol+1)*cellWidth/2)
              .attr("y", margin.top - cellHeight/2)
              .text(data.xlabel)
              .style("font-size", fontsize)
              .style("font-weight", "bold")
        titles.append("text").attr("class", "crosstab")
              .attr("x", xscale(0) + cellWidth - cellPad)
              .attr("y", yscale(0) + cellHeight/2)
              .text(data.ylabel)
              .style("font-size", fontsize)
              .style("font-weight", "bold")
        titles.append("text").attr("class", "crosstabtitle")
              .attr("x", margin.left+(width-margin.left-margin.right)/2)
              .attr("y", margin.top-titlepos)
              .text(title)
              .style("font-size", fontsize)

    # functions to grab stuff
    chart.rowrect = () -> rowrect
    chart.colrect = () -> colrect
    chart.svg = () -> svg

    # function to remove chart
    chart.remove = () ->
                      svg.remove()
                      return null

    # return the chart function
    chart
