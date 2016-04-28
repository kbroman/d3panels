# create test data in JSON format

library(qtl)
library(qtlcharts)
data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out.em <- scanone(hyper, chr=1:6)
out.hk <- scanone(hyper, chr=1:6, method="hk")
out <- cbind(out.em, out.hk, labels=c("em", "hk"))

cat(jsonlite::toJSON(qtlcharts:::convert_scanone(out)), file="data.json")
