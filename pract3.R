# 11-1-25

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

# Extract hours
domestic$Time = hour(domestic$Date)

# Group by weekday and hour to summarize frequency of domestic crimes
weekday_hour_counts = domestic %>%
                        group_by(Weekday, Time) %>%
                        summarize(Frequency = n()) %>%
                        ungroup()

# Plot the frequency of domestic crimes by hour and weekday
graph_1 = ggplot(weekday_hour_counts, aes(x = Time, y = Frequency, color = Weekday)) +
          geom_line(size = 1) +
          xlab("Hour of the Day") +
          ylab("Day of the Week") +
          ggtitle("Frequency of Domestic Crimes by Hour and Weekday")
graph_1

graph_1 = ggplot(weekday_hour_counts, aes(x = Time, y = Frequency, color = Weekday)) +
            geom_line(size = 1) +
            labs(title = "Domestic Crime Frequency by Weekday and Hour", x = "Hour", y = "Frequency")
graph_1

# Create a group for weekends
domestic$WeekdayGroup = ifelse(domestic$Weekday %in% c("Saturday", "Sunday"), "Weekend", domestic$Weekday)
weekday_hour_counts = domestic %>% group_by(WeekdayGroup, Time) %>%
                        summarize(Frequency = n()) %>%
                        ungroup()
head(weekday_hour_counts)

# Plot the frequency of domestic crimes by hour and day type
graph_2 = ggplot(weekday_hour_counts, aes(x = Time, y = Frequency, color = WeekdayGroup)) +
                geom_line(size = 1) +
                scale_color_manual(values = c("Weekend" = "red", "Monday" = "blue", "Tuesday" = "green", "Wednesday" = "purple", "Thursday" = "orange", "Friday" = "brown")) +
                xlab("Hour of the Day") + ylab("Frequency of Domestic Crimes") +
                ggtitle("Frequency of Domestic Crimes by Hour and Day Type")
print("Graph 2 displayed")
graph_2

graph_2 = ggplot(weekday_hour_counts, aes(x = Time, y = Frequency, color = WeekdayGroup)) +
            geom_line(size = 1) +
            labs(title = "Domestic Crime Frequency by Weekday Group and Hour", x = "Hour", y = "Frequency")
graph_2
