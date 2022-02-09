
#' Crop sf
#'
#' crop an sf geometry object to a desired shape.
#'
#' @param data
#' @param n_vertices
#' @param bbox a POLYGON from create_boundary_shape.
#'
#' @return
#' @export
#'
#' @examples
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


#' Crop and rotate data
#'
#' Function which is looped
#'
#' @param data
#' @param bbox
#' @param angle
#'
#' @return
crop_and_rotate <- function(data,bbox,angle) {
  data %>%
    rotate_data(rotate_angle=angle)%>%
    sf::st_crop(bbox)
}



#' transpose boundary box
#'
#' Centers the bbox at (0,0) for easy rotation cropping.
#'
#' @param bbox
#'
#' @return
transpose_bbox <- function(original_bbox) {
  xmin <- as.integer(original_bbox[1])
  xmax<- as.integer(original_bbox[3])
  ymin<- as.integer(original_bbox[2])
  ymax<- as.integer(original_bbox[4])

  sf::st_bbox(c(xmin=-((xmax - xmin)/2),
                ymin = -((ymax - ymin)/2),
                xmax=((xmax - xmin)/2),
                ymax=((ymax - ymin)/2)))
}


#' Create a shape which matches the boundary.
#'
#' Create an sf Polygon of any regular shape.
#'
#' @param vertices Number of vertices.
#' @param radius distance from center to each vertex.
#' @param transpose (X, Y) distance to transpose by.
#'
#' @return sf POLYGON
#' @export
create_boundary_shape <- function(vertices = 24,radius = 1,transpose = c(0,0)){

  rotation_per_point <- 2*pi/vertices

  point_angle <- rotation_per_point * 1:vertices

  calculated_radius <- radius / sin(pi/2 - pi/vertices)

 #message(paste("If you are creating a square you might have wanted radius :\t",sqrt(2*(radius^2))))
  data.frame(x = calculated_radius * cos(point_angle),
             y = calculated_radius * sin(point_angle)) %>%
    sf::st_as_sf(coords=c("x","y"))%>%
    rotate_data(rotate_angle = rotation_per_point/2)%>%
    transpose_data(x_add = transpose[1], y_add = transpose[2]) %>%
    dplyr::summarise(geometry=sf::st_combine(geometry)) %>%
    sf::st_cast("POLYGON")

}
