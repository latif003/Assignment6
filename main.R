# Name: Nikoula, Latifah & Nikos
# Date: 9 January 2015
# Assignment 6: Raster Vector integration in R

# clear workspace
rm (list=ls())

# load libraries
library (raster)
library (rgdal)
library (sp)

# call the functions
source('R/greenest.city.R')

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

## create an anual column in data frame to calculate the average of ndvi value all over the year
ndvidf$annualMean <- rowMeans(ndvidf [,-1:-14], na.rm = TRUE)

## greenest municipality of the selected month and greenest municipality of the year
greenest.city (ndvidf, "January") # the greenest municipality of January is Littenseradiel
greenest.city (ndvidf, "August") # the greenest municipality of August is Vorden
greenest.city (ndvidf, "annualMean") # the greenest municipality of the year is Graafstroom

# plot the result for January 
## define the greenest city of January
gr_january <- as.character(greenest.city (ndvidf, "January"))
spplot(ndviVal, zcol = 'January',main=paste("The greenest city of January is", gr_january), col.regions = colorRampPalette(c('lightgreen', 'darkgreen'))(50))

# another plot 
## define the greenest city of January
# jan <- nlCityTrans[nlCityTrans$NAME_2 == "Littenseradiel", ]
# spplot (ndviVal, zcol= "January",main="The greenest city of January", col.regions = colorRampPalette(c('brown', 'darkgreen'))(50), 
# sp.layout=list(list("sp.polygons", jan, fill ="transparent", pch=19, cex=1.5)))

