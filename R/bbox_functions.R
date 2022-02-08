
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
crop_sf <- function(data, n_vertices=4,bbox) {

  if (n_vertices %% 4){
    stop("n_vertices must be a multiple of 4.")
  } else if (n_vertices < 4) {
    stop("n_vertices must be greater than 3.")
  }

  n_vertices <- as.integer(n_vertices)


  # convert boundary shape to bbox - finds the max and min for each axis
  boundary <- sf::st_bbox(bbox)

  # find the radius as half distance xmax-xmin for boundary box
  radius <- as.integer
  # find min and max of the data for easy centering
  data_shape <- sf::st_bbox(data)

  # center the data ready for rotations
  data <-  data %>%
    transpose_data(x_add =-as.integer(data_shape["xmin"] + data_shape["xmax"])/2 ,
                   y_add = -as.integer(data_shape["ymin"] + data_shape["ymax"])/2)

  # crop until vertices - 4

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




#' Crop sf as circle
#'
#' Crop an sf object to a circular shape (or any shape with
#' even sides).
#'
#' @param data
#' @param original_bbox
#' @param angle
#'
#' @return
#' @export
crop_circle <- function(data,original_bbox, angle=pi/6) {

  xmin <- as.integer(original_bbox[1])
  xmax<- as.integer(original_bbox[3])
  ymin<- as.integer(original_bbox[2])
  ymax<- as.integer(original_bbox[4])

  n_rot <- ceiling((pi/2) / (angle))

  data <- data %>%
    sf::st_crop(original_bbox) %>% # Next transpose so that center is 0,0
    transpose_data(x_add = -((xmin+xmax)/2),
                   y_add = -((ymin+ymax)/2))
    #dplyr::mutate(geometry = .$geometry + c(-((xmin+xmax)/2),-((ymin+ymax)/2)))

  new_bbox <- transpose_bbox(original_bbox)

  data2 <- data

  for (i in 1:n_rot) {
    data2 <- crop_and_rotate(data2,new_bbox,angle)

  }

  data2 %>%
    rotate_data(rotate_angle = -(pi/2)) %>%
    transpose_data(x_add = ((xmin+xmax)/2), y_add = ((ymin+ymax)/2))

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

  message(paste("If you are creating a square you might have wanted radius :\t",sqrt(2*(radius^2))))
  data.frame(x = radius * cos(point_angle),
             y = radius * sin(point_angle)) %>%
    sf::st_as_sf(coords=c("x","y"))%>%
    rotate_data(rotate_angle = rotation_per_point/2)%>%
    transpose_data(x_add = transpose[1], y_add = transpose[2]) %>%
    dplyr::summarise(geometry=st_combine(geometry)) %>%
    sf::st_cast("POLYGON")

}
