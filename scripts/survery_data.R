#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://hodgettsp.github.io/cesR/
# Author: Wen Wang
# Data: 18 December 2020
# Contact: we.wang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Comment out the lines 10 and 11 if you already have them installed in your computer

# install.packages("devtools")
# devtools::install_github("hodgettsp/cesR")

library(cesR)
library(labelled)
library(tidyverse)

#web survey
get_ces("ces2019_web")
ces2019_web <- to_factor(ces2019_web)


survey_data <- ces2019_web %>% 
  select(cps19_age, 
         cps19_gender,
         cps19_income_number,
         cps19_province,
         cps19_votechoice)

#match age
survey_data <- survey_data %>% 
  mutate(age_group = case_when(cps19_age >=18  & cps19_age < 30 ~ 'Age 18 to 29',
                              cps19_age >= 30  & cps19_age < 45 ~ 'Age 30 to 44', 
                              cps19_age >= 45 & cps19_age < 60 ~ '45 to 59',
                              cps19_age >= 60  ~ '60+'))

#match sex
survey_data <- survey_data %>% 
  mutate(sex = case_when(
    cps19_gender =="A man" ~ "Male",
    cps19_gender =="A woman" ~ "Female"))

#match income
survey_data <- survey_data %>% 
  mutate(household_income = case_when(
    cps19_income_number < 25000 ~ "Less than $25,000",
    cps19_income_number >= 25000 & cps19_income_number < 49999  ~ "$25,000 to $49,999",
    cps19_income_number >= 50000 & cps19_income_number < 74999  ~ "$50,000 to $74,999",
    cps19_income_number >= 75000 & cps19_income_number < 99999  ~ "$75,000 to $99,999",
    cps19_income_number >= 100000 & cps19_income_number < 123999  ~ "$100,000 to $ 124,999",
    cps19_income_number >= 125000 ~ "$125,000 and more"))


survey_data <- survey_data %>% 
  mutate(province = cps19_province)


survey_data <- survey_data %>% 
  mutate(voteLib = ifelse(cps19_votechoice =="Liberal Party", 1, 0))


survey_data <- survey_data %>% 
  mutate(voteCon = ifelse(cps19_votechoice =="Conservative Party", 1, 0))

survey_data <- survey_data %>% 
  select(age_group,
         sex,
         household_income,
         province,
         voteLib,
         voteCon,
         cps19_votechoice)

survey_data$age_group =  as.factor(survey_data$age_group)
survey_data$sex =  as.factor(survey_data$sex)
survey_data$household_income =  as.factor(survey_data$household_income)
survey_data$voteLib =  as.factor(survey_data$voteLib)
survey_data$voteCon =  as.factor(survey_data$voteCon)


# survey_data <- na.omit(survey_data)


write_csv(survey_data, "./outputs/survey_data.csv")


