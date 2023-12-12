# Box plot of length of a ride by users.
ggplot(df, aes(y = member_casual, x = ride_length)) + 
  geom_boxplot() + 
  labs(title = "Figure 1. Length of ride by Users",
       x = "Length of ride",
       y = "Type of user")

ggplot(df, aes(y = member_casual, x = ride_length)) + 
  geom_boxplot(outlier.alpha = 0) + 
  coord_cartesian(xlim = c(60, 3600)) + 
  labs(title = "Figure 2. Length of ride by Users (Excluding Outliers)",
       x = "Length of ride",
       y = "Type of user")

# Bar plot of number of rides for users by day of week.
rides_by_day_of_week <- df %>%
  group_by(day_of_week, member_casual) %>%
  summarize(number_of_rides = n()) %>%
  arrange(member_casual) %>%
  pivot_wider(names_from = member_casual, values_from = number_of_rides)

ggplot(df) + 
  geom_bar(aes(x = day_of_week, fill = member_casual), position = 'dodge') + 
  geom_hline(yintercept = max(rides_by_day_of_week$casual)) + 
  geom_hline(yintercept = max(rides_by_day_of_week$member)) +
  labs(title = "Figure 3. Number of Rides for Users by day of Week",
       x = "Day of week",
       y = "Number of rides") + 
  scale_fill_discrete(name = "Type of user")

# Bar plot of median length of ride for users by day of week.
median_rides_length <- df %>%
  group_by(day_of_week, member_casual) %>%
  summarize(median_rides = median(ride_length)) %>%
  arrange(member_casual)

ggplot(median_rides_length) + 
  geom_col(aes(x = day_of_week, y = median_rides, fill = member_casual), position = 'dodge') + 
  labs(title = "Figure 4. Median Length of Ride for Users by day of Week",
       x = "Day of week",
       y = "Length of ride") + 
  scale_fill_discrete(name = "Type of user")

