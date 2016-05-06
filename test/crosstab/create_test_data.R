# create test data for crosstab in JSON format

# example data set
library(qtl)
data(fake.f2)

# select first two markers from each of chr 1 and X
mar <- c(markernames(fake.f2, chr=1)[1:2],
         markernames(fake.f2, chr="X")[1:2])

# subset to just these markers
fake.f2 <- pull.markers(fake.f2, mar)

# autosomal data; NAs to 4
gA <- pull.geno(fake.f2, chr="1")
gA[is.na(gA)] <- 4

# X chr data: expand to 1:5 and then NAs to 6
gX <- pull.geno(fake.f2, chr="X")
gX <- reviseXdata("f2", "standard", getsex(fake.f2), gX)
gX[is.na(gX)] <- 6

# convert to list
g <- as.list(as.data.frame(cbind(gA,gX)))

data <- list(geno=g,
             genocat=list(A=c("AA","AB","BB","N/A"),
             X=c("AA","AB","BB","AY", "BY", "N/A")),
             chrtype=as.list(c("A","A","X","X")))
names(data$chrtype) <- names(data$geno)

# write to data file
cat(jsonlite::toJSON(data), file="data.json")
