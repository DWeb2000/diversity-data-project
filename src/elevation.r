################################################################################
# EXTRACTING ELEVATION DATA IN SWITZERLAND AND VISUALIZATION
################################################################################

# =========================
# 1. Load required packages
# =========================
library(sf)        # modern spatial data handling (simple features)
library(elevatr)   # download elevation data
library(raster)    # raster data manipulation (maps)
library(ggplot2)   # data visualization
library(rnaturalearth)
# Disable s2 geometry engine (can avoid issues in some spatial operations)
sf_use_s2(FALSE)


# =========================
# 2. Load Switzerland boundaries
# =========================
# Retrieve country borders from Natural Earth
Italy <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Italy"
)


# =========================
# 3. Download elevation data
# =========================
# z controls resolution (higher = more detail but slower)
elevation_Italy <- get_elev_raster(Italy, z = 8)

# Quick visualization of the elevation raster
x11()
plot(elevation_Italy)


# =========================
# 4. Prepare sampling points
# =========================
# We assume your dataset contains:
# - longitude
# - latitude

# Convert coordinates into a spatial object (SpatialPoints format)
spatial_points <- SpatialPoints(
  coords = matrix_full_eco[, c("longitude", "latitude")],
  proj4string = CRS("+proj=longlat +datum=WGS84")
)


# =========================
# 5. Extract elevation values
# =========================
# Extract raster values at each point location
elevation <- raster::extract(elevation_Italy, spatial_points)


# =========================
# 6. Add elevation to the dataset
# =========================
matrix_full_eco_elev <- data.frame(
  matrix_full_eco,
  elevation = elevation
)


# =========================
# 7. Visualization: elevation distribution
# =========================
# Compare elevation distributions across climate categories

p3 <- ggplot(matrix_full_eco_elev, aes(x = elevation, fill = Climate_Re)) +
  geom_density(alpha = 0.5, adjust = 3) +  # smoothed density curves
  labs(
    title = "Elevation Distribution by Climate",
    x = "Elevation (m)",
    y = "Density"
  ) +
  theme_minimal()

# Display the plot
print(p3)

#write.csv(matrix_full_eco_elev, "owl_matrix.csv", row.names = FALSE)
