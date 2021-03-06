% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bbox_functions.R
\name{create_boundary_shape}
\alias{create_boundary_shape}
\title{Create an sf polygon.}
\usage{
create_boundary_shape(vertices = 24, radius = 1)
}
\arguments{
\item{vertices}{Number of vertices on shape.}

\item{radius}{Distance from center to each tangent point.}
}
\value{
sf POLYGON
}
\description{
Create an sf Polygon of any regular shape.
}
