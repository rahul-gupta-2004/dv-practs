library("mongolite")
library("dplyr")
library("ggplot2")

my_collection = mongo(collection = "Crime_prac", db = "TYIT_PRAC")

# 1. domestic crimes
domestic = my_collection$find('{"Domestic": true}', fields = '{"_id": 0, "Date": 1, "Description": 1}')

library(lubridate)
library(hms)

domestic = data.frame(domestic)

domestic$Date = mdy_hms(domestic$Date)

domestic$Weekday = weekdays(domestic$Date)

domestic$Time = hour(domestic$Date)

weekday_hour_counts = domestic %>%
                        group_by(Weekday, Time) %>% 
                        summarize(Frequency = n()) %>%
                        ungroup()

graph_1 = ggplot(weekday_hour_counts, aes(x = Time, y = Frequency, color = Weekday)) +
            geom_line(size = 1) +
            labs(title = "Domestic Crime Frequency by Weekday and Hour", x = "Hour", y = "Frequency")
graph_1

domestic$WeekdayGroup = ifelse(domestic$Weekday %in% c("Saturday", "Sunday"), "Weekend", "Weekday")

weekday_hour_counts = domestic %>%
                                group_by(WeekdayGroup, Time) %>% 
                                summarize(Frequency = n()) %>%
                                ungroup()
head(weekday_hour_counts)

graph_2 = ggplot(weekday_hour_counts, aes(x = Time, y = Frequency, color = WeekdayGroup)) +
            geom_line(size = 1) +
            labs(title = "Domestic Crime Frequency by Weekday Group and Hour", x = "Hour", y = "Frequency")
graph_2