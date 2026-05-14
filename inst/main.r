###############################################################################
#INTERMEDIATE PROJECT - BIODIVERSITY DATA ANALYSIS
###############################################################################

#Script of the step 1 : Combining GBIF + iNatursalist occurences of the 2 species,
#Tyto alba and Athene noctua, and creation of the main matrix.
source("./src/gbif_inat.R")


#Script of the step 2 : Adding ecosystem data to species occurence coordinates.
source("./src/ecosystem.r")


#Script of the step 3 : Adding elevation data to species occurence coordinates and to the main matrix. 
source("./src/elevation.r")


#Script of the step 4 : Adding climat data to species occurence coordinates and to the main matrix. 
source("./src/climat.R")


#Script of the step 5 : Adding satellite (NDVI) data to species occurence coordinates and to the main matrix. 
source("./src/sat_manual.r")
#Finally, the completed matrix contains 388 occurrences of the two species. 
#(Only the column containing the data collection dates has missing values (NA); the other columns are complete.)