% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vc_missing.R
\name{vc_missing}
\alias{vc_missing}
\title{Checks For Missing Elements In Vector}
\usage{
vc_missing(data, x, prop.acceptable = 0, missing = c("", "NULL", "NA",
  "N/A", "na", "n/a"), required = FALSE, ...)
}
\arguments{
\item{data}{A data frame.}

\item{x}{Column name from \code{data} (character string).}

\item{prop.acceptable}{proportion of allowable missing.}

\item{missing}{values that missing can take.}

\item{required}{whether the vector in the table is required.}

\item{\dots}{ignored.}
}
\description{
Checks For Missing Elements In Vector
}
\examples{
set.seed(10)
dat <- data.frame(x = sample(c(NA, rep(LETTERS[1:10])), 10000, TRUE))
vc_missing(dat, 'x')
vc_missing(dat, 'x', prop.acceptable = .1)
}

