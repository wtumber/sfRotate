#' Shear data
#'
#' Shear data using the shear angle defined.
#'
#' @param data sf geometry data.
#' @param shear_angle Shear angle, in Radians.
#'
#' @return sf geometry data.
#' @export
shear_data <- function(data, shear_angle = pi/4) {

  shear_matrix <- matrix(c(1,cos(shear_angle),0,sin(shear_angle)),2,2)

  data %>%
    dplyr::mutate(
      geometry = .$geometry * shear_matrix
    )
}


#' Rotate data
#'
#' Rotate sf data by the angle defined. You will likely want to
#' use a value half that of the shear angle.
#'
#' @param data sf geometry data.
#' @param rotate_angle Angle of rotation, in Radians.
#'
#' @return sf geometry data.
#' @export
rotate_data <- function(data,rotate_angle = pi/4) {

  rotate_matrix <- matrix(c(cos(rotate_angle),sin(rotate_angle),-sin(rotate_angle),cos(rotate_angle)),2,2)

  data %>%
    dplyr::mutate(
      geometry = .$geometry * rotate_matrix
    )
}


#' Transpose data
#'
#' Transpose an sf object by (x_add, y_add).
#'
#' @param data sf geometry data.
#' @param x_add Value to transpose data by, on the x-axis.
#' @param y_add Value to transpose data by, on the y-axis.
#'
#' @return sf geometry data.
#' @export
transpose_data <- function(data,x_add=0, y_add=0) {
  data %>%
    dplyr::mutate(
      geometry = .$geometry + c(x_add,y_add)
    )
}
