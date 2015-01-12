# Name: Nikoula, Latifah & Nikos
# Date: 9 January 2015
# Assignment 6: Raster Vector integration in R

# clear workspace
rm (list=ls())

# load libraries
library (raster)
library (rgdal)
library (sp)

# unzip file
unzip('data/MODIS.zip')
getwd()

# call the file
MODIS <- list.files(pattern = glob2rx('*.grd'), full.names = TRUE)
ndviModis <- brick(MODIS)
ndviModis <- ndviModis/10000 # convert the values in ndvi scale

# Download municipality boundaries
nlCity <- getData('GADM',country='NLD', level=3)

# reproject municipalities boundary
nlCityTrans <- spTransform(nlCity, CRS(proj4string(ndviModis)))
         
# extract NDVI value the MODIS
ndviVal <- extract(ndviModis, nlCityTrans, fun = mean, sp = TRUE, na.rm = TRUE)

# find the greenest municipality in January and august
## create a data frame of ndvi value
ndvidf <- data.frame(ndviVal)
ndviCity <- cbind(nlCityTrans$NAME_2, ndvidf)
colnames(ndviCity)[1] <- 'Municipality' # change the name of the first column

## create an anual column in data frame to calculate the average of ndvi value all over the year
ndviCity$annualMean <- rowMeans(ndviCity [,-1:-15], na.rm = TRUE)

## greenest municipality of the selected month and greenest municipality of the year
greenest.city (ndviCity, "January") # the greenest municipality of January is Littenseradiel
greenest.city (ndviCity, "August") # the greenest municipality of August is Vorden
greenest.city (ndviCity, "annualMean") # the greenest municipality of the year is Graafstroom

# plot the result for January 
## define the greenest city of January
spplot (ndviVal, zcol= "January",main="January", col.regions = colorRampPalette(c('brown', 'darkgreen'))(50))

