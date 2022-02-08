library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)

# Required to enable st_crop validity
sf::sf_use_s2(FALSE)

angle_to_tilt <- pi/4

# import data
world <- ne_countries(scale="medium",returnclass="sf")

# Create boundary box
box_shape <- create_boundary_shape(vertices = 24,radius = 20,transpose = c(25,25))
boundary <- st_bbox(box_shape)

data <- crop_circle(world,boundary,angle=(pi/12)) %>%
  shear_data(shear_angle=angle_to_tilt)%>%
  rotate_data(angle_to_tilt/2)

outline <-box_shape %>%
  shear_data(shear_angle=angle_to_tilt)%>%
  rotate_data(angle_to_tilt/2)

# Plot
ggplot2::ggplot(data=data) +
  ggplot2::geom_sf(data = outline,fill="lightblue")+
  ggplot2::geom_sf(fill="lightgreen",colour="black") #+
  ggplot2::theme(axis.title=ggplot2::element_blank(),
                 axis.ticks =ggplot2::element_blank() ,
                 axis.text =ggplot2::element_blank() ,
                 plot.background =ggplot2::element_blank(),
                 panel.background = ggplot2::element_blank()
  )

