# create test data in JSON format

library(qtlcharts)
data(grav)
grav <- reduce2grid(calc.genoprob(grav, step=2))

grav$pheno <- grav$pheno[,seq(1, nphe(grav), by=5)]
out <- scanone(grav, method="hk", phe=1:nphe(grav))

time <- as.numeric(sub("^T", "", colnames(grav$pheno)))/60
hr <- floor(time)
min <- round((time-floor(time))*60)
min[min<10] <- paste0("0", min[min<10])
time_str <- paste0(hr, ":", min)


data <- list(chr = out[,1],
             pos = out[,2],
             lod = as.matrix(out[,-(1:2)]),
             time = time,
             time_str = time_str)

cat(jsonlite::toJSON(data, digits=I(4)), file="data.json")
