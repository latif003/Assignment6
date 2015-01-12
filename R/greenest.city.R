# Name: Nikoula, Latifah & Nikos
# Date: 9 January 2015
# Assignment 6: Raster Vector integration in R
# Function to define the greenest city

greenest.city <- function (data, month){
  # data is the dataframe 
  # month is the month where you want to investigate which city has the highest ndvi value
  green <- subset (data, data[, month] == max(data [, month], na.rm = TRUE), select = c(NAME_2))
  return (green)
}
