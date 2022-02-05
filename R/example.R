# library(sf)
# library(rnaturalearth)
# library(rnaturalearthdata)
#
# # Required to enable st_crop validity
# sf::sf_use_s2(FALSE)
#
# angle_to_tilt <- pi/4
#
# # import data
# world <- ne_countries(scale="medium",returnclass="sf")
#
# # Create boundary box
# box_shape <- create_boundary_shape(vertices = 4, radius = 50, transpose = c(50,55))
#
# boundary <- st_bbox(box_shape)
#
# outline <- box_shape %>%
#   st_cast("POINT") %>% # cast to point before making any changes
#   shear_data(shear_angle=angle_to_tilt) %>%
#   rotate_data(rotate_angle=angle_to_tilt/2) %>%
#   dplyr::summarise(geometry=st_combine(geometry)) %>%
#   st_cast("POLYGON")
#
# # Cut world map using boundary box
# data <- world %>%
#   st_crop(boundary)%>%
#   shear_data(shear_angle=angle_to_tilt) %>%
#   rotate_data(rotate_angle=angle_to_tilt/2)%>%
#   transpose_data(y_add = 2)
#
# data2 <- world %>%
#   crop_circle(boundary,angle=(pi/24))%>%
#   shear_data(shear_angle=angle_to_tilt)#%>%
#   #transpose_data(y_add = 10)
#
# ggplot2::ggplot(data2) +
#   ggplot2::geom_sf()
#
#
# # Plot
# ggplot2::ggplot(data=data) +
#   ggplot2::geom_sf(data = outline,fill="lightblue")+
#   ggplot2::geom_sf(fill="lightgreen",colour="black") +
#   ggplot2::geom_sf(data=data2,fill="grey",colour="black",alpha=0.6) +
#   ggplot2::theme(axis.title=ggplot2::element_blank(),
#                  axis.ticks =ggplot2::element_blank() ,
#                  axis.text =ggplot2::element_blank() ,
#                  plot.background =ggplot2::element_blank(),
#                  panel.background = ggplot2::element_blank()
#                  )
#
