# 23-12-24

# Load packages
library(mongolite)
library(ggplot2)
library(dplyr)

# Connect to MongoDB collection
my_collection = mongo(collection = "Crime", db = "TYIT2024")

# List all the domestic crimes to be displayed
domestic = my_collection$find('{ "Domestic": true }', fields='{ "_id": 0, "Domestic": 1, "Date": 1}')

# Load packages
library(lubridate)
library(hms)

# Convert data to data frame
domestic = data.frame(domestic)

# Convert String to Datetime format
domestic$Date = mdy_hms(domestic$Date)

# Extract weekdays
domestic$Weekday = weekdays(domestic$Date)

# Count weekdays
weekdayCount = as.data.frame(table(domestic$Weekday))
weekdayCount

# Order weekdays
weekdayCount$Var1 = factor(weekdayCount$Var1, ordered=TRUE, levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))

# Plot graph
graph= ggplot(weekdayCount, aes(x=Var1, y=Freq)) +
        geom_line(aes(group=1), color="red") +
        xlab("Day of the Week") + ylab("Total Domestic Crimes") +
        ggtitle("Domestic Crimes in the City of Chicago Since 2001")
graph

ggplot(weekdayCount, aes(x = Var1, y = Freq)) +
  geom_line(aes(group = 1), color = "red") +
  labs(title = "Domestic Crime Count by Weekday", x = "Weekday", y = "Count")
graph
