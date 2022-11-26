library(dplyr)
library(tidyr)
## read Table
elec_Power_con<-read.table("~/Data Science John Hopkins/Exploratory Data Analysis/household_power_consumption.txt",
                           sep = ";", header = TRUE, na.strings = "?"
)
## set Date
elec_Power_con$Date<-as.Date(elec_Power_con$Date, "%d/%m/%Y") 
## Subset 2007-02-01 to 2007-0202 by "which"
plot_data<-elec_Power_con[which(elec_Power_con$Date=="2007-02-01"|elec_Power_con$Date=="2007-02-02"),]

## plot 1
hist(plot_data$Global_active_power,col = "red",
     xlab = "Global Aactive Power(kliowatts)",
     main = "Global Aactive Power"
   )
dev.copy(png,"plot1.png", width=480, height=480)
dev.off()

## combine Date & time inot new column DataTime 33
library(lubridate)
plot_data$DateTime<-with(plot_data, ymd(plot_data$Date) + hms(plot_data$Time))
## plot 2
plot(plot_data$DateTime,plot_data$Global_active_power,
     ylab = "Global Aactive Power(kliowatts)",
     xlab = "",
     type = "l")
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()
## plot 3
plot(plot_data$DateTime,plot_data$Sub_metering_1, col="black",
     ylab = "Enery sub metering",
     xlab = "",
     type = "l")
lines(plot_data$DateTime,plot_data$Sub_metering_2, col="red")
lines(plot_data$DateTime,plot_data$Sub_metering_3, col="blue")

legend("topright",col=c("black","red","blue"),lwd=c(1,1,1),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       )
dev.copy(png,"plot3.png", width=480, height=480)
dev.off()
## plot4
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
plot(plot_data$DateTime,plot_data$Global_active_power,
     ylab = "Global Aactive Power",cex = 0.25,
     xlab = "",
     type = "l")

plot(plot_data$DateTime,plot_data$Voltage,
     ylab = "Voltage",
     xlab = "datetime",cex = 0.5,
     type= "l"
)

plot(plot_data$DateTime,plot_data$Sub_metering_1, col="black",
     ylab = "Enery sub metering",cex.lab=0.75,
     xlab = "",
     type = "l")
lines(plot_data$DateTime,plot_data$Sub_metering_2, col="red")
lines(plot_data$DateTime,plot_data$Sub_metering_3, col="blue")

legend("topright",col=c("black","red","blue"),lwd=c(1,1,1),cex = 0.5,
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
)

plot(plot_data$DateTime,plot_data$Global_reactive_power,
     ylab = "Global_reactive_power", 
     xlab = "datetime",
     type= "l",
     cex.lab=0.75
)
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()
