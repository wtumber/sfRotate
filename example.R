library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Required to enable st_crop validity
sf::sf_use_s2(FALSE)

angle_to_tilt <- pi/4

# import data
world <- ne_countries(scale="medium",returnclass="sf")

# Create boundary box shape
box_shape <- create_boundary_shape(vertices = 32, radius = 30)

outline <- box_shape %>%
  st_cast("POINT") %>% # cast to point before making any changes
  shear_data(shear_angle=angle_to_tilt) %>%
  rotate_data(rotate_angle=angle_to_tilt/2) %>%
  dplyr::summarise(geometry=st_combine(geometry)) %>%
  st_cast("POLYGON")

data <- world %>%
  crop_sf(n_vertices = 32,radius= 30,crop_center = c(0,40))%>%
  shear_data(shear_angle=angle_to_tilt)%>%
  rotate_data(rotate_angle=angle_to_tilt/2)%>%
  transpose_data(y_add = -15)

background_data <- world %>%
  crop_sf(n_vertices = 4,radius= 30,crop_center = c(0,40))%>%
  transpose_data(x_add = 70)

box2_shape <- create_boundary_shape(vertices = 4, radius = 20)

outline2 <- box2_shape %>%
  st_cast("POINT") %>% # cast to point before making any changes
  shear_data(shear_angle=angle_to_tilt) %>%
  rotate_data(rotate_angle=0) %>%
  dplyr::summarise(geometry=st_combine(geometry)) %>%
  st_cast("POLYGON")

data2 <- world %>%
  crop_sf(n_vertices = 4,radius= 20,crop_center = c(0,40))%>%
  shear_data(shear_angle=angle_to_tilt)%>%
  rotate_data(rotate_angle=0)%>%
  transpose_data(y_add = 20)

# Plot
ggplot2::ggplot(data=data) +
  ggplot2::geom_sf(data = background_data,fill="grey", alpha = 0.4)+
  ggplot2::geom_sf(data = outline%>%
                     transpose_data(y_add = -15),fill="lightblue") +
  ggplot2::geom_sf(data = outline2%>%
                     transpose_data(y_add = 20),fill="lightblue") +
  ggplot2::geom_sf(data=data2,fill="lightgreen",colour="black") +
  ggplot2::geom_sf(fill="lightgreen",colour="black") +
  ggplot2::theme(axis.title=ggplot2::element_blank(),
                 axis.ticks =ggplot2::element_blank() ,
                 axis.text =ggplot2::element_blank() ,
                 plot.background =ggplot2::element_blank(),
                 panel.background = ggplot2::element_blank()
                 )

