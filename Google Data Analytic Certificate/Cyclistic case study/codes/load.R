install.packages("tidyverse")
library(tidyverse)

library(hms) # Used for format the duration of rides in "hh:mm:ss"

# Gets the names of all files in the dataset.
dataset_names <- list.files(pattern = "\\.csv$",
                            recursive = TRUE)

# Extracts data from the dataset.
dataset <- lapply(dataset_names, function(name) {
  read_csv(name)
})

# Combines all data into single data frame.
df <- bind_rows(dataset)

# Checks if the data frame is created correctly.
glimpse(df)

# Computes the length of each ride by `ended_at` - `started_at`.
# Stored in the format "hh:mm:ss".
df <- df %>% 
  mutate(ride_length = as_hms(difftime(ended_at, started_at)))

# Calculates the distance between start position and end position
# of a bike trip with Haversine formula.
# The unit of the distance is mile.
# The calculated distance does not represent 
# the entire distance traveled in a ride.
haversineDist <- function(start_lat, start_lng, end_lat, end_lng) {
  start_lat_rad <- start_lat * pi / 180
  start_lng_rad <- start_lng * pi / 180
  end_lat_rad <- end_lat * pi / 180
  end_lng_rad <- end_lng * pi / 180
  diff_lat <- sin((end_lat_rad - start_lat_rad) / 2) ^ 2
  diff_lng <- sin((end_lng_rad - start_lng_rad) / 2) ^ 2
  tmp <- diff_lat + (cos(start_lat_rad) * cos(end_lat_rad) * diff_lng)
  
  R <- 6378.137 * 0.621371 # Earth's estimated radius in miles
  
  round(2 * R * asin(sqrt(tmp)), 2)
}

df <- df %>%
  mutate(dist = haversineDist(start_lat, start_lng, end_lat, end_lng))

# Finds day of week when the bike trip started.
df <- df %>%
  mutate(day_of_week = factor(weekdays(started_at),
                              levels = c("Sunday", "Monday", "Tuesday",
                                         "Wednesday", "Thursday", "Friday",
                                         "Saturday"),
                              ordered = TRUE))


