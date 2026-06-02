# create test data in JSON format

speed <- readRDS("speed.rds")
# columns time, ping, download, upload
# time is POSIXct / POSIXt

# convert time to character string with format "2026-06-01T14:59Z"
speed$time <- strftime(speed$time, "%FT%H:%MZ")

cat(jsonlite::toJSON(speed, na="null", digits=I(4)), file="data.json")
