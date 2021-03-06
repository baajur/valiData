#' Checks If File Not Empty
#'
#' Checks If File Not Empty
#'
#' @param path path to file
#' @param \dots ignored.
#' @export
#' @rdname vf_non_empty
#' @examples
#' writeLines("", '~/filename.csv')
#' 		vf_non_empty('~/filename.csv') 		#  FALSE
#' writeLines("hi", '~/filename.csv')
#' 		vf_non_empty('~/filename.csv') 	#  TRUE
vf_non_empty <- function(path, ...){

    ten_lines <- paste(readLines(path, n=10), collapse="")
	if (ten_lines=="") {
		message <- sprintf(
			paste0(
			    header("File Empty Test"),
				"'%s' does not have any contents.\n",
				"Please either remove from upload\nor ensure required content is included.\n\n"
			),
			basename(path)
		)
    } else {
        message <- ''
    }

	non_empty <- list(
		valid = ten_lines != "",  ## logical did enough (proportion) elements validate
		call = "vf_non_empty",                      ## function name that was called
		file_name = basename(path),
	    message = message
	)

	class(non_empty) <- 'vf_non_empty'
	non_empty
}


#' Prints a vf_non_empty Object
#'
#' Prints a vf_non_empty object
#'
#' @param x A vf_non_empty object.
#' @param \ldots ignored.
#' @method print vf_non_empty
#' @export
print.vf_non_empty <- function(x, ...){

	if (!isTRUE(x[["valid"]])) {
		cat(x[['message']])
	}

}
