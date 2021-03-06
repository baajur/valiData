#' Creates Dictionary Mapping
#'
#' Creates Dictionary Mapping as List of Lists of Functions
#'
#' @param dict_list dictionary list produced by import()
#' @export
#' @examples
#' \dontrun{
#' ll <- import("~/Desktop/Dictionary.xlsx")
#' ll <- mapper(ll)
#' }
mapper <- function(dict_list){
    map <- mapper_table_files(dict_list[["tfdct"]])
    map$table$required_columns <- mapper_required_columns(dict_list[["coldct"]])
    map$column <- mapper_columns(dict_list[["coldct"]])
    stats::setNames(map, c("file_level", "table_level", "column_level") )
}

mapper_table_files <- function(tfdct){
    tt <- split(tfdct, tfdct$level)
    lapply(tt, function(x){
        tf <- x[c("rule", "condition")]
        l <- as.list(trimws(tf$condition))
        stats::setNames(ifelse(tolower(l)=="true", TRUE, ifelse(tolower(l)=="false", FALSE, l)), trimws(tf$rule))
    })
}


mapper_required_columns <- function(d){
    dd <- split(d, d[["file"]])
    lapply(dd, function(x){
        x[tolower(x$required)=="yes", "variable"]
    })
}



mapper_columns <- function(coldct) {
    dd <- split(coldct, coldct[["file"]])
    lapply(dd, function(x){
        # browser()
        field <- trimws(x[["variable"]])
        unique_funs <- ifelse(tolower(x[["unique"]])=="yes", "vc_unique()", NA)
        type_funs <- paste0("vc_type(\"", x[["type"]], "\")")
        rule_funs <- apply(x, 1,
                           function(z) ifelse(z[["rule"]]=="nchar"
                                              , paste0("vc_nchar(", gsub("\r|\n","", z[["condition"]]), ")")
                                              , paste0("vc_categories(c("
                                                       , paste( shQuote(strsplit(
                                                           gsub("\r|\n","", z[["condition"]])
                                                           , "\\s*,\\s*")[[1]]), collapse=",")
                                                       , "))")     ) )
        compare_funs <- unlist(lapply(x[["compare"]], compare_compiler))
        lapply(split(
            cbind( unique_funs, type_funs, rule_funs, compare_funs)
            , field), function(x) c(stats::na.omit(x)))
    })
}

compare_compiler <- function(x){
    if (grepl("<|>=|<=|>|==|!=|~=",x)){
        objects <- trimws(strsplit(x, "<|>=|<=|>|==|!=|~=")[[1]])
        comparison <- trimws(gsub(paste(objects,collapse ="|"),"", x))
        dateop <- ifelse(any(grepl("date",tolower(objects))),TRUE, FALSE)
        paste0('vc_compare('
               ,paste(shQuote(objects[2]),collapse=", ")
               ,", "
               ,paste0(shQuote(comparison))
               ,', date=',dateop,')')
    } else {
        NA
    }
}



