#### Preamble ####
# Purpose: Prepare and clean the census data downloaded from General Social Survey on social identity (cycle 27)
# Author: Wen Wang
# Data: 31 October 2020
# Contact: we.wang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the GSS data and saved it to inputs/data
## 1. Go to: http://www.chass.utoronto.ca/
## 2. Data centre --> UofT users or http://dc.chass.utoronto.ca/myaccess.html
## 3. Click SDA @ CHASS, should redirect to sign in. Sign in.
## 4. Continue in English (you're welcome to use the French, but we probably can't
## help you too much).
## 5. Crtl F GSS, click
## 6. Click "Data" on the one you want. We used 2017, but you may want a different 
## wave. In particular the General Social Survey on social identity (cycle 27), 
## 2013 has some variables on voter participation if you're into that sort of 
## thing. You're welcome to pick any year but this code applies to 2017.
## 7. Click download
## 8. Select CSV data file, data definitions for STATA (gross, but stick with it for now).
## 9. Can select all variables by clicking button next to green colored "All". Then continue.
## 10. Create the files, download and save
# Check: 
## You WILL need to change the raw data name. Search for .csv - line 30
## You may need to adjust the filepaths depending on your system. Search for: read_

library(tidyverse)

# Load the data dictionary and the raw data and correct the variable names
raw_data <- read_csv("./inputs/AAOaw2Tx.csv")

#select age,sex, province, income_family
gss <- raw_data %>% 
  select(age = agedc,
         sex = sex,
         province = prv,
         income_family = famincg2) 

#match age_group
census_data <- gss %>% 
  mutate(age_group = case_when(age <= 20 & age>=18 ~ '20 or less',
                              age > 20 & age <= 35 ~ '21 to 35', 
                              age > 35 & age <= 50 ~ '36 to 50',
                              age > 50 & age <= 65 ~ '51 to 65',
                              age > 65 & age <= 80 ~ '66 to 80',
                              age >80 ~ 'above 80'))

#match data
census_data <- gss %>% 
  mutate(age_group = case_when(age >=18  & age < 30 ~ 'Age 18 to 29',
                              age >= 30  & age < 45 ~ 'Age 30 to 44', 
                              age >= 45 & age < 60 ~ '45 to 59',
                              age >= 60  ~ '60+'))

#match sex
census_data <- census_data %>% 
  mutate(sex = case_when(
    sex=="1" ~ "Male",
    sex=="2" ~ "Female"))

#match province
census_data <- census_data %>% 
  mutate(province = case_when(
    province=="10" ~ "Newfoundland and Labrador",
    province=="11" ~ "Prince Edward Island",
    province=="12" ~ "Nova Scotia",
    province=="13" ~ "New Brunswick",
    province=="24" ~ "Quebec",
    province=="35" ~ "Ontario",
    province=="46" ~ "Manitoba",
    province=="47" ~ "Saskatchewan",
    province=="48" ~ "Alberta",
    province=="59" ~ "British Columbia"))

#math income_family
census_data <- census_data %>% 
  mutate(household_income = case_when(
    income_family =="1" ~ "Less than $25,000",
    income_family =="2" ~ "$25,000 to $49,999",
    income_family =="3" ~ "$50,000 to $74,999",
    income_family =="4" ~ "$75,000 to $99,999",
    income_family =="5" ~ "$100,000 to $ 124,999",
    income_family =="6" ~ "$125,000 and more"))


census_data <- census_data %>% 
  select(age_group,
         sex,
         household_income,
         province)

# census_data <- na.omit(census_data)

#write to file
write_csv(census_data, "./outputs/census_data.csv")






