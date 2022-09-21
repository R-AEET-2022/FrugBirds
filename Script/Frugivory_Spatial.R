#Script: Interactive map of fruit importance in bird's diet worldwide
#Date: 22/09/2022

#Load specific packages

library(sp)
library(mapview)

# This script aims at plotting the centroids of distribution rage for each
# species worldwide. Size of each coordinate will depict the importance
# of fruits in bird's diet in order to test if there is an latitudinal
# pattern in the consumption of fruits by birds

#Check NA's within data and remove it from data (just for plotting)
which(is.na(Frug_db$Centre_Lat))
Frug_Spatial <- Frug_db[-which(is.na(Frug_db$Centre_Lat)),]

which(is.na(Frug_Spatial$Centre_Long))
Frug_Spatial <- Frug_Spatial[-which(is.na(Frug_Spatial$Centre_Long)),]

coords <- cbind(Frug_Spatial$Centre_Long, Frug_Spatial$Centre_Lat)

#Turn df into SpatialPoinstDataframe

Frug_Spatial <- SpatialPointsDataFrame(coords=coords, data = Frug_Spatial,
                                       proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))


# Create interactive map
map<-mapview(Frug_Spatial,cex="Frugivory", zcol="Family", legend=FALSE, alpha=2)

#Save map as interactive html
mapshot(map, url="Figures/Frugivory_Map.html")
rm(list=c("coords", "Frug_Spatial", "map"))#clean environment
