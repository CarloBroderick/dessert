library(tidyverse)
library(rvest)
library(here)

# read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>%
  html_text2() %>% # extracting the text associated with this type of elements of the webpage
  as_tibble() %>% # make it a data frame
  rename(dessert = value) %>% # better name for the column
  head(.,-3) %>% # 3 last ones were not desserts
  rowid_to_column("rank") %>% # adding a column using the row number as proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv

our_desserts <- read_csv(here::here("data","favorite_desserts_CB_GR.csv"))

dessert_listing_lower <- dessert_listing |>
  mutate(dessert = str_to_lower(dessert))

our_desserts_lower <- our_desserts |>
  mutate(dessert = Favorite_dessert)


desserts_match <- inner_join(dessert_listing_lower, our_desserts_lower, by = "dessert")


