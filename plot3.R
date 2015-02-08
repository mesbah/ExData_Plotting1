# Create data directory if not exist

if(!file.exists("data")){
    dir.create("data")
}

#download, save, and extract the data file
if (!file.exists("./data/household_power_consumption.txt")) {
    fileUrl ="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, "./data/household_power_consumption.zip")
    unzip("./data/household_power_consumption.zip", overwrite = T, exdir = "./data")
}

# Calculate required Memory in MB ,8 bytes per column, 9 columns in 2075259 rows, is 142.4967 MB
# rm = ((2075259 * 9) * 8) / 1048576

# print("Required Memory in MB:")
# print(rm)


# Read the data from 2007-02-01 and 2007-02-02 dates
# Replace ? with NA
df <- read.table(text = grep("^[1,2]/2/2007", readLines("./data//household_power_consumption.txt"), value = TRUE),
                 col.names = c("Date", "Time", "Global_active_power", 
                               "Global_reactive_power", "Voltage", 
                               "Global_intensity", "Sub_metering_1", 
                               "Sub_metering_2", "Sub_metering_3"), 
                 sep = ";", header = TRUE, na.strings ="?")

# Create and add new Datetime field to the data frame, based on Date and Time Fields
df$Datetime = strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S")

# Change class of Date field to date
df$Date = as.Date(df$Date, format = "%d/%m/%Y")

# Create PNG file for plot 3
png("./ExData_Plotting1//plot3.png",  width = 480, height = 480, units = "px")

# Create Plot 3
plot(df$Datetime, df$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
points(df$Datetime, df$Sub_metering_2, type = "l", col = "red")
points(df$Datetime, df$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", 
                                                                        "Sub_metering_2", "Sub_metering_3"))

# close PNG file
dev.off()