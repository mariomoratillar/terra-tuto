install("terra")
library("terra")
sst<- rast("C:/Users/mario/Desktop/MNCN/CopernicusData/cmems_mod_glo_phy-thetao_anfc_0.083deg_P1M-m_1772700744417.nc")
gdal(drivers=TRUE)
sst
plot(sst[[1]])

#As an example we are going to mask the global temperature layer to have a restricted area, in this case we want to focus in the great barrier reef
#To do this we need a layer that is going to act as a mask, in this case we downloaded it from the github repository from the course
gbr_boundary<-vect("C:/Users/mario/Downloads/gbr_MPA_boundary.gpkg")
gbr_boundary

#In order to see what are we going to cropped with we can draw the mask over our map
plot(sst[[8]])
lines(gbr_boundary, col="black")

#Now in order to cropp and mask we are going to do 2 different steps which are
sst_cropped <- crop(sst[[8]], gbr_boundary)
sst_cropped
plot(sst_cropped)

#If we overlay again the cropping layer we can see how close have we gotten
lines(gbr_boundary)

#In order to delete erase the data outside our cropped zone we can use the function mask
sst_cropped_masked <- mask(sst_cropped, gbr_boundary)
plot(sst_cropped_masked)

#Raster values and representing
hist(sst[[8]],main="Temperature August 25", xlab="Temperature", ylab="Frequency", col="red", border="blue")
#To see how frequent are my values for the gbr
hist(sst_cropped_masked,main="Temperature August 25 GBR", xlab="Temperature", ylab="Frequency", col="red", border="blue")
freq(sst_cropped_masked)
freq(sst_cropped_masked, digits = 1)
#If i want to see the specific frequency of a value
freq(sst_cropped_masked, value = NA)
ncell(sst_cropped_masked)
#To do a global statistics analysis only in the data that are not NA
global(sst_cropped_masked, "mean", na.rm = TRUE)
summary(sst_cropped_masked, na.rm = TRUE)
global(sst_cropped_masked, "median", na.rm = TRUE)

#In order to save the numeric value of the mean we have calculated using mean
sst_mean <- global(sst_cropped_masked, "mean", na.rm = TRUE) |> as.numeric()
sst_mean

#Clasifying rasters
reclass_matrix <- c(0, sst_mean, 1,
                sst_mean, Inf, 2) |>
    matrix(ncol = 3, byrow = TRUE)

reclass_matrix

sst_reclassed <- classify(sst_cropped_masked, reclass_matrix)

plot(sst_reclassed, col = c("blue", "red"), plg = list(legend = c("cooler", "warmer")))

#Raster math

sst_cropped_masked*2
#All raster values are multiplied by 2

sst_F <- (sst_cropped_masked*1.8)+32

plot(sst_F)

#projecting rasters
zones <- vect("C:/Users/mario/Desktop/MNCN/TUTOTERRA/data/gbr_habitat_protection_zones.gpkg")

zones

plot(sst_cropped_masked)
lines(zones)#nothing is painted cause each of them is in a different reference system
# They both need to match

crs(zones)#To see the reference system information of my layer
crs(zones, describe = TRUE) #to get a clear description


sst_cropped_masked_projected <- project(sst_cropped_masked, crs(zones))

sst_cropped_masked_projected

plot(sst_cropped_masked_projected)

summary(sst_cropped_masked)

summary(sst_cropped_masked_projected)

ncell(sst_cropped_masked)

ncell(sst_cropped_masked_projected)

#Raster layers

#sst data monthly for 1 years

sst_monthly_coper <- rast("C:/Users/mario/Desktop/MNCN/CopernicusData/cmems_mod_glo_phy-thetao_anfc_0.083deg_P1M-m_1772700744417.nc")
sst_monthly_coper

plot(sst_monthly_coper)
