# Filter out rides with duration less than 1 minute
# which may not be an actual bike trip.
df <- df %>% 
  filter(ride_length >= hms(minutes = 1))

# Checks no ride have duration less than 1 minute.
df %>%
  filter(ride_length < hms(minutes = 1)) %>%
  select(ride_id, ride_length) %>%
  arrange(desc(ride_length)) %>%
  n_distinct()

# There is a 2 minutes and 35 seconds bike trip that 
# started and ended at stations with id "Pawel Bialowas - Test- PBSC charging station"
# and a distance of 739.96 miles between two stations.
# The ride is very unlikely to be a normal ride made by a user.
df %>%
  select(ride_id, rideable_type,
         start_station_name, end_station_name, 
         ride_length, dist) %>%
  arrange(desc(dist)) %>%
  head()

# Since the station id contains the keyword "Test",
# rides with station ids that has the keyword "Test" will be checked.
df %>%
  filter((grepl("test", start_station_id, ignore.case = TRUE) |
            grepl("test", end_station_id, ignore.case = TRUE))) %>%
  arrange(desc(dist)) %>%
  View()

# Stations with station id that has the keyword "test" also has
# the keyword "checking" in their id and "warehouse" in their name.
# The rides appeared to be not normal rides made by customers.
# Thus, all rides that has the keyword "test" in the column
# `start_station_id` or `end_station_id` will be filter out.
df <- df %>%
  filter(!(grepl("test", start_station_id, ignore.case = TRUE) |
             grepl("test", end_station_id, ignore.case = TRUE)))

# Checks that all stations have ids that does not contains the keyword "test"
df %>%
  filter((grepl("test", start_station_id, ignore.case = TRUE) |
            grepl("test", end_station_id, ignore.case = TRUE))) %>%
  glimpse()

# The fictional company Cyclistic bikes need to be unlocked from a station
# and returned to a station. However, Divvy electric bike can be parked at 
# a legal public location other than their docking stations. Thus, all rides
# that are started or ended at a location without station id
# will be filter out.
df <- df %>%
  filter(!(is.na(start_station_id) |
             is.na(end_station_id)))

# Checks that all rides have stations with station names and ids.
df %>%  
  arrange(start_station_id, end_station_id) %>%
  View()

# Checks that all rides have a start position and end position.
df %>%
  filter(is.na(end_lat) | is.na(start_lat)) %>%
  n_distinct()
