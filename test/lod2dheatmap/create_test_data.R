# create test data for lod2dheatmap in JSON format

library(qtl)
data(badorder)
badorder <- est.rf(badorder)
lod <- pull.rf(badorder, "lod")
diag(lod) <- rep(max(lod, na.rm=TRUE), nrow(lod))
mnames <- markernames(badorder)
dimnames(lod) <- list(NULL, NULL)
n.mar <- nmar(badorder)
names(n.mar) <- NULL
chrnam <- chrnames(badorder)

cat(RJSONIO::toJSON(list(z=lod, nmar=n.mar, chrnames=chrnam, labels=mnames),
                     na="null"),
    file="data.json")