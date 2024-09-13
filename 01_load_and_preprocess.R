# 01_load_and_preprocess.R

# Load required libraries
library(tidyverse)
library(skimr)
library(lubridate)

# Set working directory if needed (or use RStudio project for relative paths)
setwd('path/to/Flight-Delay-Analysis')

# Load the data
flight_data <- read.csv("data/flight_delays.csv")

# Explore the data structure
glimpse(flight_data)
summary(flight_data)
skim(flight_data)

# Remove duplicates if there are any
flight_data <- flight_data %>% distinct()

# Handle missing data
# Visualize missing values
flight_data %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  gather(key = "Variable", value = "MissingCount") %>%
  ggplot(aes(x = reorder(Variable, -MissingCount), y = MissingCount)) +
  geom_bar(stat = "identity", fill = "red") +
  coord_flip() +
  labs(title = "Missing Values per Variable", x = "Variables", y = "Count of Missing Values")

# Impute missing values with median or mean
flight_data <- flight_data %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Convert date and time columns if necessary
flight_data$flight_date <- ymd(flight_data$flight_date)

# Save the cleaned data for further use
write.csv(flight_data, "data/cleaned_flight_delays.csv", row.names = FALSE)
