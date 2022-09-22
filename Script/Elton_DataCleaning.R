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

Elton <- Elton_raw %>% dplyr::filter(Diet.Certainty=="A") %>% 
                       dplyr::select(Scientific, Diet.Fruit) %>%
                       dplyr::rename(Species = Scientific,
                              Frugivory = Diet.Fruit)


Elton_pred <- Elton_raw %>% dplyr::filter(Diet.Certainty!="A") %>% 
                         dplyr::select(Scientific, Diet.Fruit) %>%
                       dplyr::rename(Species = Scientific,
                       Frugivory_Interpolated = Diet.Fruit) 

# two last rows from Elton_pred datasets are empty rows
length(Elton_pred$Species)
Elton_pred <- Elton_pred[1:2060,]

rm(Elton_raw) #Clean environment

# Check differences between species names in the two databases

setdiff(Elton$Species, AVONET$BirdLife_Species)

setdiff(Elton$Species, AVONET$BirdTree_Species)  #4 species names are not coincident

setdiff(Elton$Species, AVONET$BirdTree_Species) %in% AVONET$BirdLife_Species  

#Campylopterus curvipennis and C. excellens are now Pampa curvipennis and P.excellens
Elton[which(Elton$Species=="Campylopterus curvipennis"), "Species"]<-"Pampa curvipennis"
Elton[which(Elton$Species=="Campylopterus excellens"), "Species"]<-"Pampa excellens"

#The other 2 sps are extinct so we delete them in Elton database
Elton<- Elton %>% dplyr::filter(Species!= "Philydor novaesi") %>% filter(Species!="Melamprosops phaeosoma")

#Check again the differences
setdiff(Elton$Species, AVONET$BirdTree_Species) #no difference
Elton<-Elton %>% dplyr::rename(BirdTree_Species=Species)

#Merge both datasets
Frug_db <- left_join(Elton, AVONET, by="BirdTree_Species")

#Duplicated rows appears because there is some uncongruences between BirdTree and
# BirdLife species names

duplicated(Frug_db$BirdTree_Species)
Frug_db<- Frug_db[-which(duplicated(Frug_db$BirdTree_Species)),]

#Add a binomial variable depending if fruits are the major component of the diet (>50%) or not
Frug_db<- Frug_db %>% mutate (Frugivore=ifelse(Frugivory>=50,"Yes", "No"))

#check sps names in prediction database

setdiff(Elton_pred$Species, AVONET$BirdLife_Species)

setdiff(Elton_pred$Species, AVONET$BirdTree_Species) #5 sps names are not coincident

setdiff(Elton_pred$Species, AVONET$BirdTree_Species) %in% AVONET$BirdLife_Species  

#Anthus longicaudatus = Anthus vaalensis
#Phyllastrephus leucolepis = Phyllastrephus icterinus
#Lophura hatinhensis = Lophura edwardsi
#Polioptila clementsi = Polioptila guianensis
Elton_pred[which(Elton_pred$Species=="Phyllastrephus leucolepis"), "Species"]<-"Phyllastrephus icterinus"
Elton_pred[which(Elton_pred$Species=="Anthus longicaudatus"), "Species"]<-"Anthus vaalensis"
Elton_pred[which(Elton_pred$Species=="Polioptila clementsi"), "Species"]<-"Polioptila guianensis"
Elton_pred[which(Elton_pred$Species=="Lophura hatinhensis"), "Species"]<-"Lophura edwardsi"

#Hypositta perdita = invalid taxon

Elton_pred<- Elton_pred %>% dplyr::filter(Species!= "Hypositta perdita") 

#Check sps names again

setdiff(Elton_pred$Species, AVONET$BirdTree_Species)

#Prediction database with traits

Elton_pred<-Elton_pred %>% dplyr::rename(BirdTree_Species=Species)

Elton_pred<- left_join(Elton_pred, AVONET, by="BirdTree_Species")

#Check duplicates
Elton_pred[which(duplicated(Elton_pred$BirdTree_Species)),]

Elton_pred <- Elton_pred[-which(duplicated(Elton_pred$BirdTree_Species)),]

#Clean environment
rm(Elton) 