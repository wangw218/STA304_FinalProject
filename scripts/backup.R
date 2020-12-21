library(tidyverse)
library(lme4)
library(pROC)
library(knitr)
library(broom)


# Loading in the cleaned survey Data
survey_data <- read_csv("./outputs/survey_data.csv")

# Loading in the cleaned census Data
census_data <- read_csv("./outputs/census_data.csv")
survey_data <- na.omit(survey_data)
census_data <- na.omit(census_data)


# census_data <- 
#   census_data %>% 
#   group_by(state, gender, age_group) %>% 
#   summarise(number = sum(number)) %>% 
#   ungroup()





census_data <-
  census_data%>%
  count(sex, province, age_group,household_income) %>%
  group_by(sex, province, age_group,household_income) %>%
  ungroup()

# Make proportions
census_data <-
  census_data %>%
  group_by(province) %>%
  mutate(total = sum(n)) %>%
  mutate(cell_prop_of_division_total = n / total) %>%
  ungroup()

model_Scheer <- glmer(voteTrudeau~(1|province) + age_group + sex + household_income, data = survey_data, family=binomial)


census_data$log_estimate_T <-
  model_Trudeau %>%
  predict(newdata = census_data)

census_data$estimate_T<-
  exp(census_data$log_estimate_T)/(1+exp(census_data$log_estimate_T))

census_data %>%
  mutate(alp_predict_prop_T = estimate_T * n / sum(n)) %>%
  summarise(Trudeau_Win_Rate = sum(alp_predict_prop_T))

t = census_data %>%
  mutate(alp_predict_prop_T = estimate_T * cell_prop_of_division_total) %>%
  group_by(province) %>%
  summarise(Trudeau_Win_Rate = sum(alp_predict_prop_T))


t
census_data$log_estimate_S <-
  model_Scheer %>%
  predict(newdata = census_data)

census_data$estimate_S<-
  exp(census_data$log_estimate_S)/(1+exp(census_data$log_estimate_S))

census_data %>%
  mutate(alp_predict_prop_S = estimate_S * n / sum(n)) %>%
  summarise(Trudeau_Win_Rate = sum(alp_predict_prop_S))

s = census_data %>%
  mutate(alp_predict_prop_S = estimate_S * cell_prop_of_division_total) %>%
  group_by(province) %>%
  summarise(Trudeau_Win_Rate = sum(alp_predict_prop_S))

s
t$Trudeau_Win_Rate / s$Trudeau_Win_Rate
votes = c(34,42,14,19,7,11,121,4,78,14)
sum(t$Trudeau_Win_Rate*votes)
sum(s$Trudeau_Win_Rate*votes)

