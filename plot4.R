### plot4.R

# a. cleanup 
rm(list = ls())

# b. fetch and unzip the data set
baseDir <- "."

# b.1 create data sub-directory if necessary
dataDir <- file.path(baseDir, "data")
if(!file.exists(dataDir)) { dir.create(dataDir) }

# b.2 download original data if necessary (skip if exists already as it takes time)
zipFilePath <- file.path (dataDir, "data.zip")
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dateFilePath <- file.path(dataDir,"date_time_downloaded.txt")
if (!file.exists(zipFilePath)) {
  download.file (zipFileUrl, zipFilePath, method="curl")
  DTDownloaded <- format(Sys.time(), "%Y-%b-%d %H:%M:%S")
  cat (DTDownloaded, file=dateFilePath)
  unzip (zipFilePath, exdir=dataDir)
} else {
  DTDownloaded <- scan(file=dateFilePath, what="character", sep="\n")
}

cat ("The dataset is located in", dataDir, "and was downloaded on downloaded on", DTDownloaded)

# b.3 unzip and creates dataSetDir if necessary
dataSetDir <- file.path (dataDir, "household_power_consumption.txt")
if (!file.exists(dataSetDir)) {
  unzip (zipFilePath, exdir=dataDir)
}
list.files(dataDir)

# c. read the file if necessary; transform "?" to NA while reading
d <- read.table(dataSetDir, sep=";", header=TRUE, fill=FALSE, na.strings=c("?"))
# real date to make labels easier to build
d$DateTime <- strptime(paste(d$Date,d$Time,sep=" "), "%d/%m/%Y %H:%M:%S")
d$Date <- as.Date(d$Date,"%d/%m/%Y")
d <- subset(d , Date == as.Date("2007-02-01","%Y-%m-%d") | Date == as.Date("2007-02-02","%Y-%m-%d"))

# d. plot

png(filename = "plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))
#1
with(d, plot(DateTime, Global_active_power, 
             type = "l",xlab="",main="",
             ylab="Global Active Power"))
#2
with(d, plot(DateTime, Voltage, 
             type = "l", main="", xlab="datetime"))
#3
with(d, plot(DateTime, Sub_metering_1, 
             type = "l", col="black",
             xlab="",main="",
             ylab="Energy sub metering"))
with(d, lines(DateTime, Sub_metering_2, 
              col="red",
))
with(d, lines(DateTime, Sub_metering_3, 
              col="blue",
))
legend(x="topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1),bty = "n",
       col=c("black","red","blue"))
#4
with(d, plot(DateTime, Global_reactive_power, 
             type = "l", main="", xlab="datetime"))
dev.off()

