#sqldf should be installed beforehand

#Loading required package - sqldf package should be installed beforehand
library(sqldf)

#Creating a directory to download and unzip data file
if(!file.exists("EDACP1"))
{
  dir.create("EDACP1")
}

#Downloading file
setInternet2(True) # For downloading https url
url<-"https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
download.file(url,dest="./EDACP1/hpc.zip")
unzip("./EDACP1/hpc.zip",exdir="./EDACP1")


#Reading the required data set from two dates 1st & 2nd Feb,2007

edata<-read.csv.sql("./EDACP1/household_power_consumption.txt",
                    sql="select * from file where Date='1/2/2007' or Date='2/2/2007'",sep=";",
                    header=T)

#Converting and merging date and time
edata$Date<-as.Date(edata$Date,"%d/%m/%Y")
datetime<-paste(edata$Date,edata$Time,sep=" ")
datetime<-strptime(datetime, "%Y-%m-%d %H:%M:%S")

#Replacing date & time column from original data with one datetime column
edata<-edata[-c(1,2)]
edata<-cbind(datetime,edata)

#Creating & saving plot as png image in the clones repo
#Plot 3
png(file="./ExData_Plotting1/figure/Plot3.png",width=480,height=480)
plot(edata$datetime,edata$Sub_metering_1,type="l",col="black", xlab="",ylab="Energy sub metering")
lines(edata$datetime,edata$Sub_metering_2,type="l",col="red")
lines(edata$datetime,edata$Sub_metering_3,type="l",col="blue")
legend("topright",legend=c("Sub-metering_1","Sub-metering_2","Sub-metering_3"),col=c("black","red","blue"),lwd=1,xjust=1,lty=1)
dev.off()