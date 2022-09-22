# Script: Data cleaning AVONET database

###############################################################################
library(dplyr)
library(ggplot2)
library(stringr)

##############################################################

#Import AVONET  BirdLife data 
AVONET <- read.csv("Data/Traits/AVONET/AVONET_BirdLife_Data.csv", sep=";")

#Import crosswalk between BirdLife dataset and BirdTree (Jetz phylo)
crosswalk <- read.csv("Data/Traits/AVONET/BirdLife_BirdTree_crosswalk.csv", sep=";")
crosswalk <- crosswalk %>% dplyr::select(BirdLife_Species, BirdTree_Species)

# merge with AVONET dataset
AVONET <- AVONET %>% dplyr::rename(BirdLife_Species=Species1) 
AVONET <- left_join(AVONET, crosswalk, by="BirdLife_Species")
rm(crosswalk) #clean environment

#Select only traits of interest

AVONET <- AVONET %>% dplyr::select(Avibase.ID1, Family1, Order1, BirdLife_Species,
                            BirdTree_Species, Beak.Length_Culmen,
                            Beak.Length_Nares, Beak.Width, Beak.Depth,
                            Kipps.Distance, Primary.Lifestyle, Centroid.Latitude,
                            Centroid.Longitude, Range.Size) %>%
                   dplyr::rename(ID_Avibase = Avibase.ID1, Family=Family1, Order= Order1,
                           Beak_CulmenLength = Beak.Length_Culmen,
                           Beak_NaresLength = Beak.Length_Nares,
                           Beak_Width = Beak.Width, Beak_Depth= Beak.Depth,
                           KippsD = Kipps.Distance, Lifestyle = Primary.Lifestyle,
                           Centre_Lat = Centroid.Latitude, Centre_Long=Centroid.Longitude,
                           Range_Size = Range.Size)

#Create genus column
AVONET$Genus <- word(AVONET$BirdTree_Species, 1)
