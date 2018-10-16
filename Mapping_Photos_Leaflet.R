#============================
# Mapping Cell Phone Photos
#    using leaflet in R
#   The Map Guy (2018)
#============================

#Call the libaries
library(exifr)
library(dplyr)
library(leaflet)
library(mapview)

#Set working directory to the folder that holds the photos
setwd('/Users/OikoEco/Vacation')
getwd()

#clear global environment
rm(list=ls())

#Get the names of all the photos in the directory, save to dat data frame
photos <- list.files(pattern = "*.JPG") #pattern makes sure we're only selecting jpg files
dat <- read_exif(photos)

#Select only 4 important exif data columns, save to dat2 data frame
dat2 <- select(dat,
               SourceFile, DateTimeOriginal,
               GPSLongitude, GPSLatitude)

print(dat2) #see that there are two photos with no exif data

#Subset only those photos with exif data to dat3 data frame
dat3 <- subset(dat2, GPSLatitude > 0)

print(dat3) #see that we now have only photos with exif data

#Use Leaflet to make an interactive map
leaflet(dat3) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>% #1-Example using satellite imagery
  addMarkers(~ GPSLongitude, ~ GPSLatitude) 

leaflet(dat3) %>%
  addProviderTiles(providers$OpenStreetMap)%>% #2-Example using Open Street Map 
  addMarkers(~ GPSLongitude, ~ GPSLatitude) 

leaflet(dat3) %>%
  addProviderTiles(providers$Stamen.TonerBackground)%>% #3-Example using Open Street Map 
  addMarkers(~ GPSLongitude, ~ GPSLatitude) 

#Editing marker type, color, and display with addCircleMarkers
leaflet(dat3)%>%
  addProviderTiles(providers$OpenStreetMap)%>%
  addCircleMarkers(lng=~GPSLongitude, lat=~GPSLatitude, color = 'red',
                   clusterOptions = markerClusterOptions(),
                   weight = 4, radius = 5)

#Let's add labels & popups
#labels
leaflet(dat3)%>%
  addProviderTiles(providers$OpenStreetMap)%>%
  addCircleMarkers(lng=~GPSLongitude, lat=~GPSLatitude, color = 'red',
                   label = ~SourceFile, labelOptions = labelOptions(noHide=F,"font-style" = "bold","font-size" = "16px"),
                   clusterOptions = markerClusterOptions(),
                   weight = 4, radius = 5)

#labels & popups
map <- leaflet(dat3)%>%
  addProviderTiles(providers$OpenStreetMap)%>%
  addCircleMarkers(lng=~GPSLongitude, lat=~GPSLatitude, color = 'red',
                   label = ~SourceFile, labelOptions = labelOptions(noHide=F,"font-style" = "bold","font-size" = "16px"),
                   clusterOptions = markerClusterOptions(),
                   weight = 4, radius = 5,
                   popup = popupImage(dat3$SourceFile, src="file"))
map
## create .html and .png
library(htmlwidgets)
saveWidget(map,file="myMap.html")


