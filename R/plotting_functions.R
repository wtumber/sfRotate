#' Geometry to points
#'
#' Converts sf geometry to a data.frame.
#' Wrapper of the sf::st_coordinates function.
#'
#' @param data sf geometry data.
#'
#' @return A data.frame.
#' @export
geometry_to_points <- function(data) {
  data.frame(sf::st_coordinates(data))
}


#' Convert geometry points to lines
#'
#' Convert points in a geometry object to lines
#' accessible by ggplot2::geom_line.
#'
#' @param data sf geometry data.
#' @param x_add x value to extend the line by.
#' @param y_add y value to extend the line by.
#'
#' @return A data.frame.
#' @export
geometry_to_lines <- function(data,x_add=0,y_add=0) {

  data_lines <- data.frame(sf::st_coordinates(data)) %>%
    dplyr::mutate(group = dplyr::row_number())

  data_lines2  <- data_lines %>%
    dplyr::mutate(X = X + x_add,
                  Y = Y + y_add)

  dplyr::bind_rows(data_lines,data_lines2)
}




