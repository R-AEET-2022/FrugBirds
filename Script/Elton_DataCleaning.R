# Script: Data cleaning EltonTraits database

#Load specific libraries

library(dplyr)

#Import Elton Traits database
Elton_raw <- read.delim("Data/Traits/ELTON/Elton_BirdFuncDat.txt")

# Our main aim is to predict those values related to the percentage of fruits
# within species-specific diet that were previously interpolated by EltonTraits
# owners and curators.

table(Elton_raw$Diet.Certainty) #Only Category A is valid for our purposes

# Create 2 subsets:

Elton <- Elton_raw %>% filter(Diet.Certainty=="A") %>% 
                       select(Scientific, Diet.Fruit) %>%
                       rename(Species = Scientific,
                              Frugivory = Diet.Fruit)


Elton_pred <- Elton_raw %>% filter(Diet.Certainty!="A") %>% 
                         select(Scientific, Diet.Fruit) %>%
                       rename(Species = Scientific,
                       Frugivory_Interpolated = Diet.Fruit) 

# two last rows from Elton_pred datasets are empty rows
length(Elton_pred$Species)
Elton_pred <- Elton_pred[1:2060,]

rm(Elton_raw) #Clean environment
