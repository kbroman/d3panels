# create test data in JSON format

library(qtl)
library(qtlcharts)
data(hyper)
map <- pull.map(hyper)

cat(RJSONIO::toJSON(qtlcharts:::convert_map(map)), file="data.json")
