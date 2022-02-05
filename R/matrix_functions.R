#' Shear data
#'
#' Shear data using the shear angle defined.
#'
#' @param data
#' @param shear_angle
#'
#' @return
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
#' use a value half that of the shear angle if they are used in
#' conjunction.
#'
#' @param data
#' @param rotate_angle
#'
#' @return
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
#' @param data
#' @param x_add
#' @param y_add
#'
#' @return
#' @export
transpose_data <- function(data,x_add=0, y_add=0) {
  data %>%
    dplyr::mutate(
      geometry = .$geometry + c(x_add,y_add)
    )
}

