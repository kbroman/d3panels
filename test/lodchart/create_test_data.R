# create test data in JSON format

library(qtl)
data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out.em <- scanone(hyper, chr=c(1:6,"X"))
out.hk <- scanone(hyper, chr=c(1:6,"X"), method="hk")

marker <- rownames(out.em)
# clear the pseudomarker names
marker[grep("^c[0-9X]+\\.loc[0-9\\.]+$", marker)] <- ""

data <- list(chr = out.em[,1],
             pos = out.em[,2],
             lod_em = out.em[,3],
             lod_hk = out.hk[,3],
             marker = marker)

cat(jsonlite::toJSON(data, digits=I(4)), file="data.json")
