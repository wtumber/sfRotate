
#' Crop sf
#'
#' Crop an sf geometry object to a desired 4-sided shape. The shape is
#' defined by a radius and a number of vertices. The radius is the distance
#' from the center to the tangent point of each face. The crop center is
#' the central point of the sf geometry point to crop round.
#'
#' @param data sf geometry data.
#' @param radius Radius of sf geometry crop.
#' @param crop_center Central point of sf crop.
#' @param n_vertices Number of vertices crop will have.
#'
#' @return sf geometry data.
#' @export
crop_sf <- function(data, n_vertices=4,radius = 10, crop_center=c(0,0)) {

  if (n_vertices %% 4){
    stop("n_vertices must be a multiple of 4.")
  } else if (n_vertices < 4) {
    stop("n_vertices must be greater than 3.")
  }

  n_vertices <- as.integer(n_vertices)
  n_rot <- ceiling(n_vertices/4)
  rot_angle <- (pi/2)/n_rot

  bbox <- create_boundary_shape(vertices = 4,radius = radius) %>%
    sf::st_bbox()

  # find min and max of the data for easy centering
  data_shape <- sf::st_bbox(data)

  # center the data ready for rotations
  data2 <- data %>%
    transpose_data(x_add =-as.integer(data_shape["xmin"] + data_shape["xmax"])/2 ,
                   y_add = -as.integer(data_shape["ymin"] + data_shape["ymax"])/2)%>%
    # center again based on the user input center
    transpose_data(x_add = -crop_center[1] ,
                   y_add = -crop_center[2])

  for (i in 1:n_rot) {
    data2 <- crop_and_rotate(data2,bbox,rot_angle)
  }

  data2 %>%
    rotate_data(rotate_angle = -(pi/2))
}


#' Create an sf polygon.
#'
#' Create an sf Polygon of any regular shape.
#'
#' @param vertices Number of vertices on shape.
#' @param radius Distance from center to each tangent point.
#'
#' @return sf POLYGON
#' @export
create_boundary_shape <- function(vertices = 24,radius = 1){

  rotation_per_point <- 2*pi/vertices

  point_angle <- rotation_per_point * 1:vertices

  calculated_radius <- radius / sin(pi/2 - pi/vertices)

  data.frame(x = calculated_radius * cos(point_angle),
             y = calculated_radius * sin(point_angle)) %>%
    sf::st_as_sf(coords=c("x","y"))%>%
    rotate_data(rotate_angle = rotation_per_point/2)%>%
    dplyr::summarise(geometry=sf::st_combine(geometry)) %>%
    sf::st_cast("POLYGON")

}


#' Crop and rotate data
#'
#' Crop sf geometry data using an st::bbox and rotate by angle Radians.
#'
#' @param data sf geometry data.
#' @param bbox An sf::st_bbox-defined object.
#' @param angle Angle to rotate by, in Radians.
#'
#' @return  sf geometry data.
crop_and_rotate <- function(data,bbox,angle) {
  data %>%
    rotate_data(rotate_angle=angle) %>%
    sf::st_crop(bbox)
}

