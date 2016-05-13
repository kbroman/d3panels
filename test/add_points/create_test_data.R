# create test data in JSON format

set.seed(27806353)
# simulate data
n <- 100
x <- sort(rnorm(n, 10, 4))
y <- x*2+3 + rnorm(n, 0, 2)

group <- as.numeric((y < 20) + (y < 30))+1

cat(jsonlite::toJSON(list(x=x, y=y, group=group), digits=I(4)), file="data.json")
