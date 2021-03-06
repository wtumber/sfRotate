% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotting_functions.R
\name{geometry_to_lines}
\alias{geometry_to_lines}
\title{Convert geometry points to lines}
\usage{
geometry_to_lines(data, x_add = 0, y_add = 0)
}
\arguments{
\item{data}{sf geometry data.}

\item{x_add}{x value to extend the line by.}

\item{y_add}{y value to extend the line by.}
}
\value{
A data.frame.
}
\description{
Convert points in a geometry object to lines
accessible by ggplot2::geom_line.
}
