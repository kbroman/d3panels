# create test data in JSON format

set.seed(79833104)
n <- 30
x <- sample(1:3, 30, repl=TRUE)
y <- rnorm(n, 20+x/2)
dat <- cbind(x, y)
colnames(dat) <- NULL

cat(jsonlite::toJSON(dat, digits=I(4)), file="data.json")
