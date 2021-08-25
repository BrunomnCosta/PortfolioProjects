## Loading libraries
library(tidyverse)
library(janitor)
library(lubridate)
library(scales)
## Data source
## https://divvy-tripdata.s3.amazonaws.com/index.html
df1 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202004-divvy-tripdata.csv")
df2 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202005-divvy-tripdata.csv")
df3 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202006-divvy-tripdata.csv")
df4 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202007-divvy-tripdata.csv")
df5 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202008-divvy-tripdata.csv")
df6 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202009-divvy-tripdata.csv")
df7 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202010-divvy-tripdata.csv")
df8 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202011-divvy-tripdata.csv")
df9 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202012-divvy-tripdata.csv")
df10 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202101-divvy-tripdata.csv")
df11 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202102-divvy-tripdata.csv")
df12 <- read.csv("~/R/projetos/Cyclist_bike_share/Data/202103-divvy-tripdata.csv")
#Combine 12 data frames into 1 
bike_rides <- rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
bike_rides <- janitor::remove_empty(bike_rides, which = c("cols"))
bike_rides <- janitor::remove_empty(bike_rides, which = c("rows"))
dim(bike_rides)
##Convert Data/Time to Date/Time ...
bike_rides$started_at <- lubridate::ymd_hms(bike_rides$started_at)
bike_rides$ended_at <- lubridate::ymd_hms(bike_rides$ended_at)
#Create hour field 
bike_rides$start_hour <- lubridate::hour(bike_rides$started_at)
bike_rides$end_hour <- lubridate::hour(bike_rides$ended_at)

bike_rides$start_date <- lubridate::date(bike_rides$started_at)
bike_rides$end_date <- lubridate::date(bike_rides$ended_at)
#Number of rides for every hour 

bike_rides %>% count(start_hour, sort = T) %>% 
  ggplot() + geom_line(aes(x=start_hour, y=n)) +
  scale_y_continuous(labels = comma) +
  labs(title = "Count of bike rides by hour: Previous 12 months", x="Start hour of ride", y="Number of rides")
