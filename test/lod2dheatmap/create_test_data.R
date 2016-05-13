# create test data for lod2dheatmap in JSON format

library(qtl)
data(badorder)
badorder <- est.rf(badorder)

lod <- pull.rf(badorder, "lod")
diag(lod) <- rep(max(lod, na.rm=TRUE), nrow(lod))
dimnames(lod) <- list(NULL, NULL)

marker <- markernames(badorder)
chr <- rep(chrnames(badorder), nmar(badorder))
pos <- unlist(lapply(nmar(badorder), function(a) 1:a))
names(pos) <- NULL

cat(jsonlite::toJSON(list(chr=chr, pos=pos, lod=lod, marker=marker),
                     digits=I(4)),
    file="data.json")
