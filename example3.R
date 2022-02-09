library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Required to enable st_crop validity
sf::sf_use_s2(FALSE)

world <- ne_countries(scale="medium",returnclass="sf")

# Create boundary box polygon for plot
box_shape <- create_boundary_shape(vertices = 16, radius = 30)


# Crop map into 12 vertex shape
data <- crop_sf(world,16,radius= 30,crop_center = c(-20,60))


ggplot2::ggplot(data) +
  ggplot2::geom_sf(data=box_shape)+
  ggplot2::geom_sf()

