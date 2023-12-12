# Checks any inconsistencies between end station names and ids
name_id <- df %>%
  select(end_station_name, end_station_id) %>%
  distinct()

name_id %>% n_distinct()

# any stations with name or id that is NA
name_id %>%
  filter(is.na(end_station_name) | is.na(end_station_id))

# ids with multiple names
name_id %>% 
  group_by(end_station_id) %>%
  summarize(n = n()) %>%
  filter(n > 1)

# id 444 is assigned to two different station names,
# "N Shore Channel Trail & Argyle Ave" and
# "N Shore Channel Trail & Argyle St".
name_id %>%
  filter(end_station_id == 444)

# Checks that both station names referred to the same station
df %>% 
  select(end_station_name, end_station_id,
         end_lat, end_lng) %>%
  filter(end_station_id == 444) %>%
  head()

# Replaces station name "N Shore Channel Trail & Argyle Ave"
# to "N Shore Channel Trail & Argyle St".
df <- df %>% 
  mutate(end_station_name =
           ifelse(end_station_id == 444,
                  "N Shore Channel Trail & Argyle St",
                  end_station_name))

# Checks no station has the name "N Shore Channel Trail & Argyle Ave".
df %>%
  filter(end_station_name == "N Shore Channel Trail & Argyle Ave")

name_id <- df %>%
  select(end_station_name, end_station_id) %>%
  distinct()

# Checks that id 444 is assigned to only one station name.
name_id %>%
  filter(end_station_id == 444)

# names with multiple ids
name_id %>%
  group_by(end_station_name) %>%
  summarize(n = n()) %>%
  filter(n > 1)

# Station name "Lakefront Trail & Bryn Mawr Ave"
# has two ids,
# "KA1504000152" and "15576".
name_id %>%
  filter(end_station_name == "Lakefront Trail & Bryn Mawr Ave")

# Both ids are unique for the station "Lakefront Trail & Bryn Mawr Ave".
# Replace id "KA1504000152" with "15576".
df <- df %>% 
  mutate(end_station_id = 
           ifelse(end_station_name == "Lakefront Trail & Bryn Mawr Ave",
                  "15576",
                  end_station_id))

# Checks that no station has id "KA1504000152".
df %>%
  filter(end_station_id == "KA1504000152")

name_id <- df %>%
  select(end_station_name, end_station_id) %>%
  distinct()

# Checks that the station "Lakefront Trail & Bryn Mawr Ave" 
# has only one id.
name_id %>%
  filter(end_station_name == "Lakefront Trail & Bryn Mawr Ave")

name_id %>% n_distinct()
