#This sets the library directory, where we are saving packages
.libPaths("X:/WORK/R/libraries")

#Load the tidyverse! Good times
library(tidyverse)
library(janitor)
library(readxl)
library(xlsx)
library(pacman)
library(readxl)
library(sf)
library(devtools)
library(bbmap)
library(zoo)
library(extrafont)
library(cowplot)
library(pracma)
library(lubridate)
library(gdata)
library(ukcovid19)
library(formattable)
library(rio)
library(DT)
library(git2r)
library(downloadthis)

#check working directory
getwd()

#doing charts?
p_load('dplyr', 'tidyr', 'gapminder',
       'ggplot2',  'ggalt',
       'forcats', 'R.utils', 'png', 
       'grid', 'ggpubr', 'scales',
       'bbplot2')


p_load('dplyr', 'tidyr', 
       'rgdal', 'ggplot2', 
       'readxl', 'png', 
       'grid', 'ggpubr',
       'RColorBrewer', 
       'classInt', 'rmapshaper')



#Start work


########################PART 1#########################

# 1. get ltla data from API

query_filter <- c("areaType=ltla")

# 2. this is what we're querying

cases = list(
  date = "date",
  areaName = "areaName",
  areaCode = "areaCode",
  cumCasesBySpecimenDate = "cumCasesBySpecimenDate")

# 3. get the data. be warned, it often times out. you may need to restart r

data <- get_data(
  filters = query_filter,
  structure = cases)

# 4. filter for England only

eng_data <- filter(data, grepl("E", areaCode))

# 5. pivot cumulate cases to have dates in the columns and cumulatives cases in values

wide_data <- eng_data %>%
  arrange(desc(date)) %>% 
  pivot_wider(names_from = date, 
              values_from= c(cumCasesBySpecimenDate)) %>% 
  # THIS IS AN IMPORTANT BIT, we ALWAYS take the data from three days from TODAY (as in, the day you're running this)
  # So, if the government has given you data for TODAY, subtract -3, -4 and -5, if not just -3 and -4 
  select(-3, -4)

# 6. choose the days needed, these should always be the 3rd and 10th, as we have already discount the first two days of data

calc_wks <- wide_data %>%
  mutate(cases_week_recent=.[[3]]-.[[10]]) %>% 
  mutate(cases_previous_week=.[[10]]-.[[17]]) %>% 
  select(1:2, cases_previous_week, cases_week_recent)

# 7. graft on population and BBC region etc

pop_estimates <- read_csv("population.csv") %>% 
  remove_empty("cols")

# 8. Join them

la_pop_data <- left_join(calc_wks,pop_estimates, by = "areaName")

# 9. check if you've missed any area populations

la_pop_join_check <- anti_join(calc_wks,pop_estimates, by = "areaName")

# 10. Build our analysis tab

analysis_tab <- la_pop_data %>%
  select(areaName, county, bbc_region, govt_region, population, cases_previous_week, cases_week_recent) %>% 
  filter(!is.na(population)) %>% 
  mutate(rate_per_100k_in_previous_week=(cases_previous_week/population)*100000) %>% 
  mutate(rate_per_100k_in_recent_week=(cases_week_recent/population)*100000)

# 11. add 'has it risen' column

analysis_tab <- analysis_tab %>% 
  mutate(has_rate_risen=(rate_per_100k_in_recent_week-rate_per_100k_in_previous_week)>0) %>% 
  arrange(desc(rate_per_100k_in_recent_week))

# change true/false to yes/no

analysis_tab$has_rate_risen <- as.character(analysis_tab$has_rate_risen)
analysis_tab$has_rate_risen[analysis_tab$has_rate_risen == "TRUE"] <- "Yes"
analysis_tab$has_rate_risen[analysis_tab$has_rate_risen == "FALSE"] <- "No"

# 12. Create thousand separators

analysis_tab$population <- prettyNum(c(analysis_tab$population),big.mark=",", preserve.width="none")
analysis_tab$cases_previous_week <- prettyNum(c(analysis_tab$cases_previous_week),big.mark=",", preserve.width="none")
analysis_tab$cases_week_recent <- prettyNum(c(analysis_tab$cases_week_recent),big.mark=",", preserve.width="none")

# 13. tidy up names

colnames(analysis_tab)[1:10] <- c("Area", "Ceremonial County/City region", "BBC Region", "Government region", "Population", "Cases, previous week", "Cases, latest week", "Rate per 100k population, previous week", "Rate per 100k population, latest week", "Has the rate increased?")

########################PART 2#########################

# 1. get nation data and make England analysis

query_filter2 <- c("areaType=nation")

# 2. get the data. be warned, it often times out. you may need to restart r

data2 <- get_data(
  filters = query_filter2,
  structure = cases)

# 3. pivot cumulate cases to have dates in the columns and cumulatives cases in values

wide_data2 <- data2 %>%
  arrange(desc(date)) %>% 
  pivot_wider(names_from = date, 
              values_from= c(cumCasesBySpecimenDate)) %>% 
  # THIS IS AN IMPORTANT BIT, we ALWAYS take the data from three days from TODAY (as in, the day you're running this)
  # So, if the government has given you data for TODAY, subtract -3, -4 and -5, if not just -3 and -4 
  select(-3, -4)


# 4. ANNA: this should be much easier counting forwards as it won't 'slip' when we add a new calc column:

calc_wks2 <- wide_data2 %>%
  mutate(cases_week_recent=.[[3]]-.[[10]]) %>% 
  mutate(cases_previous_week=.[[10]]-.[[17]]) %>% 
  select(1:2, cases_previous_week, cases_week_recent)

# 5. graft on population

pop_estimates2 <- read_csv("population.csv") %>% 
  remove_empty("cols")

# 6. Join them

la_pop_data2 <- left_join(calc_wks2,pop_estimates2, by = "areaCode")

# 7. filter out duplicates

la_pop_data2 <- la_pop_data2 %>% 
  distinct()

# 8. Build our analysis tab

analysis_tab2 <- la_pop_data2 %>%
  select(areaName.x, population, cases_previous_week, cases_week_recent) %>% 
  #population sheet is taken from Itla_analysis master sheet so we know it matches where necessary
  filter(!is.na(population)) %>% 
  mutate(rate_per_100k_in_previous_week=(cases_previous_week/population)*100000) %>% 
  mutate(rate_per_100k_in_recent_week=(cases_week_recent/population)*100000)

# 9. add 'has it risen' column

analysis_tab2 <- analysis_tab2 %>% 
  mutate(has_rate_risen=(rate_per_100k_in_recent_week-rate_per_100k_in_previous_week)>0) %>% 
  arrange(desc(population))

# 10. change true/false to yes/no

analysis_tab2$has_rate_risen <- as.character(analysis_tab2$has_rate_risen)
analysis_tab2$has_rate_risen[analysis_tab2$has_rate_risen == "TRUE"] <- "Yes"
analysis_tab2$has_rate_risen[analysis_tab2$has_rate_risen == "FALSE"] <- "No"

# 11. Create thousand separators

analysis_tab2$population <- prettyNum(c(analysis_tab2$population),big.mark=",", preserve.width="none")
analysis_tab2$cases_previous_week <- prettyNum(c(analysis_tab2$cases_previous_week),big.mark=",", preserve.width="none")
analysis_tab2$cases_week_recent <- prettyNum(c(analysis_tab2$cases_week_recent),big.mark=",", preserve.width="none")

# 12. tidy up names

colnames(analysis_tab2)[1:7] <- c("Country", "Population", "Previous week", "Latest week", "Rate per 100k population, previous week", "Rate per 100k population, latest week", "Has the rate increased?")

########################PART 3#########################

# 1. Need to create a weekly total tab

cases2 = list(
  date = "date",
  areaName = "areaName",
  areaCode = "areaCode",
  newCasesBySpecimenDate = "newCasesBySpecimenDate")

# 2. get the data. be warned, it often times out. you may need to restart r

data_for_weekly <- get_data(
  filters = query_filter,
  structure = cases2)

# 3. filter for England only

data_for_weekly <- filter(data_for_weekly, grepl("E", areaCode))

# 4. pivot

wide_data3 <- data_for_weekly %>%
  arrange(desc(date)) %>% 
  pivot_wider(names_from = date, 
              values_from= c(newCasesBySpecimenDate)) %>% 
  # THIS IS AN IMPORTANT BIT, we ALWAYS take the data from three days from TODAY (as in, the day you're running this)
  # So, if the government has given you data for TODAY, subtract -3, -4 and -5, if not just -3 and -4 
  select(-3, -4)

# 5. get BBC region 

wide_data3 <- left_join(wide_data3, pop_estimates, by = "areaName")

# 6. calculate weeks 

calc_wks3 <- wide_data3 %>%
  mutate(cases_week_1=.[[3]]+.[[4]]+.[[5]]+.[[6]]+.[[7]]+.[[8]]+.[[9]]) %>% 
  mutate(cases_week_2=.[[10]]+.[[11]]+.[[12]]+.[[13]]+.[[14]]+.[[15]]+.[[16]]) %>%
  mutate(cases_week_3=.[[17]]+.[[18]]+.[[19]]+.[[20]]+.[[21]]+.[[22]]+.[[23]]) %>%
  mutate(cases_week_4=.[[24]]+.[[25]]+.[[26]]+.[[27]]+.[[28]]+.[[29]]+.[[30]]) %>%
  mutate(cases_week_5=.[[31]]+.[[32]]+.[[33]]+.[[34]]+.[[35]]+.[[36]]+.[[37]]) %>%
  mutate(cases_week_6=.[[38]]+.[[39]]+.[[40]]+.[[41]]+.[[42]]+.[[43]]+.[[44]]) %>%
  mutate(cases_week_7=.[[45]]+.[[46]]+.[[47]]+.[[48]]+.[[49]]+.[[50]]+.[[51]]) %>%
  mutate(cases_week_8=.[[52]]+.[[53]]+.[[54]]+.[[55]]+.[[56]]+.[[57]]+.[[58]]) %>%
  mutate(cases_week_9=.[[59]]+.[[60]]+.[[61]]+.[[62]]+.[[63]]+.[[64]]+.[[65]]) %>%
  mutate(cases_week_10=.[[66]]+.[[67]]+.[[68]]+.[[69]]+.[[70]]+.[[71]]+.[[72]]) %>%
  select(areaName, bbc_region, cases_week_1,cases_week_2,cases_week_3,cases_week_4,cases_week_5,cases_week_6,cases_week_7,cases_week_8,cases_week_9,cases_week_10)

# 7. do rates by bringing in population

calc_wks3_rates <- left_join(calc_wks3, pop_estimates2, by = "areaName")

calc_wks3_rates <- calc_wks3_rates %>%
  mutate(rate_per_100k_week_1=(cases_week_1/population)*100000) %>% 
  mutate(rate_per_100k_week_2=(cases_week_2/population)*100000) %>%
  mutate(rate_per_100k_week_3=(cases_week_3/population)*100000) %>%
  mutate(rate_per_100k_week_4=(cases_week_4/population)*100000) %>%
  mutate(rate_per_100k_week_5=(cases_week_5/population)*100000) %>%
  mutate(rate_per_100k_week_6=(cases_week_6/population)*100000) %>%
  mutate(rate_per_100k_week_7=(cases_week_7/population)*100000) %>%
  mutate(rate_per_100k_week_8=(cases_week_8/population)*100000) %>%
  mutate(rate_per_100k_week_9=(cases_week_9/population)*100000) %>%
  mutate(rate_per_100k_week_10=(cases_week_10/population)*100000) %>% 
  select(areaName, bbc_region.x, rate_per_100k_week_1,rate_per_100k_week_2,rate_per_100k_week_3,rate_per_100k_week_4,rate_per_100k_week_5,rate_per_100k_week_6,rate_per_100k_week_7,rate_per_100k_week_8,rate_per_100k_week_9,rate_per_100k_week_10)

# 8. tidy up names YOU NEED TO CHANGE THESE IN BOTH

colnames(calc_wks3_rates)[1:12] <- c("Area", "BBC Region", "Rate per 100k population, latest week", "Rate per 100k population, previous week", "Rate per 100k population, 3 weeks ago", "Rate per 100k population, 4 weeks ago", "Rate per 100k population, 5 weeks ago", "Rate per 100k population, 6 weeks ago", "Rate per 100k population, 7 weeks ago", "Rate per 100k population, 8 weeks ago", "Rate per 100k population, 9 weeks ago", "Rate per 100k population, 10 weeks ago")

colnames(calc_wks3)[1:12] <- c("Area", "BBC Region", "Cases, latest week", "Cases, previous week", "Cases, 3 weeks ago", "Cases, 4 weeks ago", "Cases, 5 weeks ago", "Cases, 6 weeks ago", "Cases, 7 weeks ago", "Cases, 8 weeks ago", "Cases, 9 weeks ago", "Cases, 10 weeks ago")

#######################PART 4##########################

# 1. get ltla data from API

query_filter <- c("areaType=ltla")

# 2. this is what we're querying

deaths2 = list(
  date = "date",
  areaName = "areaName",
  areaCode = "areaCode",
  cumDeaths28DaysByPublishDate = "cumDeaths28DaysByPublishDate")

# 3. get the data. be warned, it often times out. you may need to restart r

deaths_data_for_weekly <- get_data(
  filters = query_filter,
  structure = deaths2)

# 4. filter for England only - may not need it

deaths_data_for_weekly <- filter(deaths_data_for_weekly, grepl("E", areaCode))

# 5. pivot

wide_data3_death <- deaths_data_for_weekly %>%
  arrange(desc(date)) %>% 
  pivot_wider(names_from = date, 
              values_from= c(cumDeaths28DaysByPublishDate))

# 6. calculate weeks


calc_wks3_death <- wide_data3_death %>%
  mutate(total_deaths=.[[3]]) %>%
  mutate(change_since_yesterday=.[[3]]-.[[4]])%>%
  mutate(change_since_last_week=.[[3]]-.[[10]])

calc_wks3_death <- calc_wks3_death %>%
  select(areaName, total_deaths, change_since_yesterday,change_since_last_week)%>%
  arrange(desc(change_since_last_week))

# 7. join the population

calc_wks3_death <- left_join(calc_wks3_death,pop_estimates, by = "areaName")

# 8. Create thousand separators

calc_wks3_death$population <- prettyNum(c(calc_wks3_death$population),big.mark=",", preserve.width="none")
calc_wks3_death$total_deaths <- prettyNum(c(calc_wks3_death$total_deaths),big.mark=",", preserve.width="none")

# 9. tidy up names 

calc_wks3_death <- calc_wks3_death[, c(1, 8, 11, 9, 7, 2, 3, 4)]

colnames(calc_wks3_death)[1:8] <- c("Area", "Ceremony county/city region", "BBC region", "Government region", "Population", "Total deaths", "Change since yesterday", "Change since last week")

#######################PART 5##########################

# write out

write_csv(analysis_tab,"covid_ltla_analysis.csv")
write_csv(analysis_tab2, "covid_nation_analysis.csv")
write_csv(calc_wks3,"covid_weekly_raw.csv")
write_csv(calc_wks3_rates,"covid_weekly_rates.csv")
write_csv(calc_wks3_death, "local_covid_deaths.csv")

