# create test data in JSON format

n <- 101
x <- y <- seq(-pi, pi, len=n)
z <- matrix(ncol=n, nrow=n)
for(i in seq(along=x))
    for(j in seq(along=y))
        z[i,j] <- sin(x[i]) + cos(y[j])

cat(jsonlite::toJSON(list(x=x, y=y, z=z)),
    file="data.json")

# second data set with unequal bins
set.seed(40092090)
nx <- 101
ny <- 51
x <- sort(runif(nx, -pi, pi))
y <- sort(runif(ny, -pi/2, pi/2))
z <- matrix(nrow=nx, ncol=ny)
for(i in seq(along=x))
    for(j in seq(along=y))
        z[i,j] <- sin(x[i]) + cos(y[j])

cat(jsonlite::toJSON(list(x=x, y=y, z=z)),
    file="data_unequal.json")

# third data set: correlation matrix
n <- 30
p <- 15
X <-matrix(rnorm(n*p), ncol=p) %*% chol(matrix(0.5, p, p) + diag(rep(0.5, p)))
X[,1:5] <- -X[,1:5]
z <- cor(X)

xcat <- paste0("var", 1:p)
cat(jsonlite::toJSON(list(xcat=xcat, ycat=xcat, z=z)),
    file="data_categorical.json")
