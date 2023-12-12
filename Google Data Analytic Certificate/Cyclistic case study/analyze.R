# The summary table corresponding to
# member riders and casual riders.
df %>%
  group_by(member_casual) %>%
  reframe(n = c("min", "Q1", "median", "Q3", "max", "mean"),
          v = c(fivenum(ride_length), round(mean(ride_length)))) %>%
  pivot_wider(names_from = n, values_from = v) %>%
  mutate(across(min:mean, as_hms)) %>%
  data.frame()


# Calculates the median of `ride_length`
# of users by `day_of_week`
df %>%
  group_by(member_casual, day_of_week) %>%
  summarize(median = round(median(ride_length))) %>%
  arrange(day_of_week) %>%
  pivot_wider(names_from = day_of_week, values_from = median) %>%
  mutate(across(Sunday:Saturday, as_hms)) %>%
  data.frame()

# Calculates the number of rides for users by `day_of_week`
df %>%
  group_by(member_casual, day_of_week) %>%
  summarize(number_of_rides = n()) %>%
  arrange(day_of_week) %>%
  pivot_wider(names_from = day_of_week, values_from = number_of_rides) %>%
  mutate(total = sum(Sunday + Monday + Tuesday + Wednesday + 
                       Thursday + Friday + Saturday))
