#read and/or install packages
library(tidyverse)
library(janitor)
library(devtools)
library(nbastatR)
library(tibble)
library(dplyr)
library(readr)
library(shiny)
install_github("abresler/nbastatR")
# Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2) #set size

#gather all shots for the 2022 season
shots <- teams_shots(all_active_teams = T, 
                     seasons = 2022, 
                     season_types = "Regular Season")

#filter the Raptors shots
Raptors_Shots <- shots %>% 
  filter(nameTeam == "Toronto Raptors")

#set date today
DateToday <- Sys.Date()

#pull daily nba schedule data
Today_Schedule <- days_scores(
  game_dates = DateToday,
  league = "NBA",
  day_offset = 0,
  include_standings = T,
  assign_to_environment = T,
  return_message = TRUE
)

#pull in raw eastern conference standings
EasternConferenceStandings <- dataScoreEastConfStandingsByDayNBA

#rename desired column titles
East_Rename <- EasternConferenceStandings %>% 
  rename(Conference = nameConference) %>% 
  rename(Team = slugTeam) %>% 
  rename(Winning_Percentage = pctWins) %>% 
  rename(Home_Record = recordHome) %>% 
  rename(Away_Record = recordAway) %>% 
  rename(Date = dateStandings) %>% 
  rename(Games_Played = gp) %>% 
  rename(Wins = wins) %>% 
  rename(Losses = losses)

#pull in raw western conference standings
WesternConferenceStandings <- dataScoreWestConfStandingsByDayNBA 

#rename desired column titles
West_Rename <- WesternConferenceStandings %>% 
  rename(Conference = nameConference) %>% 
  rename(Team = slugTeam) %>% 
  rename(Winning_Percentage = pctWins) %>% 
  rename(Home_Record = recordHome) %>% 
  rename(Away_Record = recordAway) %>% 
  rename(Date = dateStandings) %>% 
  rename(Games_Played = gp) %>% 
  rename(Wins = wins) %>% 
  rename(Losses = losses)

#select the desired columns for the eastern conference standings
EastStandings <- East_Rename %>% 
  select(Date, Conference, Team, Games_Played, Wins, Losses,
         Winning_Percentage, Home_Record, Away_Record)

#select the desired columns for the western conference standings
WestStandings <- West_Rename %>% 
  select(Date, Conference, Team, Games_Played, Wins, Losses,
         Winning_Percentage, Home_Record, Away_Record)

#write Toronto Raptors shots to a CSV file
write.csv(Raptors_Shots,
          file = "Raptors_Shots.csv")

#write the Eastern Conference standings to a CSV file
write.csv(EastStandings,
          file = "NBA_East_Standings.csv")

#write the western conference standings to a CSV file
write.csv(WestStandings,
          file = "NBA_West_Standings.csv")

##### END OF R SCRIPT ######
#this file does not show how the game box are produced
#this will be transfered in the coming days


