###############################################################################
# BIODIVERSITY DATASET CONSTRUCTION
# Species: Tyto alba & Athene noctua
# Country: Italy
###############################################################################
###############################################################################
# SIMPLE DATASET CONSTRUCTION
# Species: Tyto alba & Athene noctua
# Country: Italy
###############################################################################

# =========================
# 1 PACKAGES
# =========================

library(rgbif)
library(rnaturalearth)
library(ggplot2)
library(rinat)
library(raster)
library(dplyr)
library(sf)


###############################################################################
# 2) BASE MAP
###############################################################################

Italy <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Italy"
)
x11()
ggplot(data = Italy) +
  geom_sf(fill = "grey95", color = "black") +
  theme_classic()

###############################################################################
# 3) -------- SPECIES 1: Tyto alba --------
###############################################################################

myspecies <- "Tyto alba"
gbif_limit <- 5000

date_start <- as.Date("2016-01-01")
date_end   <- as.Date("2026-03-01")

# Italy bounding box
xmin <- 6
xmax <- 19
ymin <- 36
ymax <- 47



# GBIF
key_tyto <- name_backbone(name = myspecies)$usageKey

gbif_tyto_raw <- occ_data(
  taxonKey = key_tyto,
  hasCoordinate = TRUE,
  limit = gbif_limit
)

gbif_occ_tyto <- gbif_tyto_raw$data

gbif_tyto_italy <- gbif_occ_tyto %>%
  filter(country == "Italy")

nrow(gbif_tyto_italy)

plot(
  gbif_tyto_italy$decimalLongitude,
  gbif_tyto_italy$decimalLatitude,
  pch = 16,
  col = "darkgreen",
  xlab = "Longitude",
  ylab = "Latitude",
  main = "GBIF occurrences of Tyto alba in Italy"
)

ggplot(data = Italy) +
  geom_sf(fill = "grey95", color = "black") +
  geom_point(
    data = gbif_tyto_italy,
    aes(x = decimalLongitude, y = decimalLatitude),
    size = 3,
    shape = 21,
    fill = "darkgreen",
    color = "black"
  ) +
  theme_classic()



# iNaturalist
inat_tyto_raw <- get_inat_obs(
  query = "Tyto alba",
  place_id = "italy"
)
# Inspect the structure
head(inat_tyto_raw)
names(inat_tyto_raw)

ggplot(data = Italy) +
  geom_sf(fill = "grey95", color = "black") +
  geom_point(
    data = inat_tyto_raw,
    aes(x = longitude, y = latitude),
    size = 3,
    shape = 21,
    fill = "darkred",
    color = "black"
  ) +
  theme_classic()


inat_tyto <- data.frame(
  species = "Tyto alba",
  latitude = inat_tyto_raw$latitude,
  longitude = inat_tyto_raw$longitude,
  date_obs = as.Date(inat_tyto_raw$observed_on),
  source = "inat"
)

# Check structure
head(inat_tyto)
str(inat_tyto)
nrow(inat_tyto)

###############################################################################
# 5) -------- SPECIES 2: Athene noctua --------
###############################################################################

myspecies2 <- "Athene noctua"

# GBIF
key_athene <- name_backbone(name = myspecies2)$usageKey

gbif_athene_raw <- occ_data(
  taxonKey = key_athene,
  hasCoordinate = TRUE,
  limit = gbif_limit
)

gbif_occ_athene <- gbif_athene_raw$data

gbif_athene_italy <- gbif_occ_athene %>%
  filter(country == "Italy")

nrow(gbif_athene_italy)

plot(
  gbif_athene_italy$decimalLongitude,
  gbif_athene_italy$decimalLatitude,
  pch = 16,
  col = "darkgreen",
  xlab = "Longitude",
  ylab = "Latitude",
  main = "GBIF occurrences of Athene noctua in Italy"
)

ggplot(data = Italy) +
  geom_sf(fill = "grey95", color = "black") +
  geom_point(
    data = gbif_athene_italy,
    aes(x = decimalLongitude, y = decimalLatitude),
    size = 3,
    shape = 21,
    fill = "darkgreen",
    color = "black"
  ) +
  theme_classic()




# iNaturalist
inat_athene_raw <- get_inat_obs(
  query = "Athene noctua",
  place_id = "italy"
)
# Inspect the structure
head(inat_athene_raw)
names(inat_athene_raw)
nrow(inat_athene_raw)

ggplot(data = Italy) +
  geom_sf(fill = "grey95", color = "black") +
  geom_point(
    data = inat_athene_raw,
    aes(x = longitude, y = latitude),
    size = 3,
    shape = 21,
    fill = "darkred",
    color = "black"
  ) +
  theme_classic()


inat_athene <- data.frame(
  species = "Athene noctua",
  latitude = inat_athene_raw$latitude,
  longitude = inat_athene_raw$longitude,
  date_obs = as.Date(inat_athene_raw$observed_on),
  source = "inat"
)

head(inat_athene)
names(inat_athene)
nrow(inat_athene)



###############################################################################
# 6) FORMAT GBIF DATA (IMPORTANT FIX)
###############################################################################

gbif_tyto <- data.frame(
  species = "Tyto alba",
  latitude = gbif_tyto_italy$decimalLatitude,
  longitude = gbif_tyto_italy$decimalLongitude,
  date_obs = as.Date(gbif_tyto_italy$eventDate),
  source = "gbif"
)

gbif_athene <- data.frame(
  species = "Athene noctua",
  latitude = gbif_athene_italy$decimalLatitude,
  longitude = gbif_athene_italy$decimalLongitude,
  date_obs = as.Date(gbif_athene_italy$eventDate),
  source = "gbif"
)

###############################################################################
# 7) MERGE ALL DATA
###############################################################################

matrix_full <- bind_rows(
  gbif_tyto,
  inat_tyto,
  gbif_athene,
  inat_athene
)

###############################################################################
# 8) CLEAN DATA
###############################################################################

#matrix_full <- matrix_full %>%
  #filter(!is.na(latitude), !is.na(longitude)) %>%
  #filter(!is.na(date_obs))

###############################################################################
# 9) QUICK CHECK
###############################################################################

head(matrix_full)
table(matrix_full$species)
table(matrix_full$source)

###############################################################################
# 10) SIMPLE MAP
###############################################################################
x11()
ggplot() +
  geom_sf(data = Italy, fill = "grey90") +
  geom_point(
    data = matrix_full,
    aes(x = longitude, y = latitude, color = species),
    alpha = 0.6
  ) +
  theme_classic()

###############################################################################
# 11) SAVE CLEAN DATASET
###############################################################################

#write.csv(matrix_full, "owl_occurrences_italy.csv", row.names = FALSE)
