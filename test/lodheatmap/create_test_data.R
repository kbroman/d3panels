# create test data in JSON format

library(qtlcharts)
data(grav)
grav <- reduce2grid(calc.genoprob(grav, step=2))

grav$pheno <- grav$pheno[,seq(1, nphe(grav), by=5)]
out <- scanone(grav, method="hk", phe=1:nphe(grav))

data <- list(chr = out[,1],
             pos = out[,2],
             lod = as.matrix(out[,-(1:2)]),
             time = as.numeric(sub("^T", "", colnames(grav$pheno))))

cat(jsonlite::toJSON(data), file="data.json")
