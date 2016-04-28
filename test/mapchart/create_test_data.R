# create test data in JSON format

library(qtl)
data(hyper)
map <- pull.map(hyper)

map_converted <-
    list(chr=rep(names(map), vapply(map, length, 1)),
         pos=unlist(map),
         marker=unlist(lapply(map, names)))

cat(jsonlite::toJSON(map_converted), file="data.json")
