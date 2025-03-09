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

weekdayCount = as.data.frame(table(domestic$Weekday))

weekdayCount$Weekday = factor(weekdayCount$Var1, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

ggplot(weekdayCount, aes(x = Var1, y = Freq)) +
  geom_line(aes(group = 1), color = "red") +
  labs(title = "Domestic Crime Count by Weekday", x = "Weekday", y = "Count")