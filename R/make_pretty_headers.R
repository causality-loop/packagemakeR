#' @title make_pretty_headers
#' @description Adds *roxygen2* headers to new functions added.
#' @param file_name character, the file name relative to the work directory or, if none, the full path to the file
#' @param dictionary_file character, the location of the dictionary file (please indicate full file path)
#' @details Creates an roxygen2 header for each function using a custom parameter dictionary.
#' @references [R Bloggers](https://www.r-bloggers.com/2017/05/sinew-a-r-package-to-create-self-populating-roxygen2-skeletons)
#' \cr [rdrr.io](https://rdrr.io/github/yonicd/sinew/man/makeOxyFile.html)
#' \cr [Sinew GitHub](https://github.com/yonicd/sinew)
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  packagemakeR::make_pretty_headers(
#'    file_name = '~/git/demo/my_new_fun.R',
#'    dictionary_file = '~/git/packagemakeR/inst/extdata/dictionary.R')
#'  }
#' }
#' @export 
#' @importFrom devtools install_github
#' @importFrom sinew sinew_opts makeOxyFile pretty_namespace
#' @importFrom brio readLines
make_pretty_headers <- function(
  file_name, dictionary_file = '~/git/packagemakeR/inst/extdata/dictionary.R')
{

  if (length(find.package('sinew')) == 0) 
    devtools::install_github('yonicd/sinew')

  # sinew options
  sinew::sinew_opts$set(list(add_fields = c(
    'details', 'author', 'references', 'examples', 'export')))

  # makes roxygen2 headers
  # the manual says that you can use a path here, but it doesn't work :(
  sinew::makeOxyFile(file_name, overwrite = TRUE, verbose = FALSE, cut = 5, 
    use_dictionary = dictionary_file)

  # if you forget *::* it puts it in for you!
  try(sinew::pretty_namespace(file_name, overwrite = TRUE))

  # magrittr/data.table imports
  has_apipe <- length(grep('%<>%', brio::readLines(file_name))) > 0
  has_tpipe <- length(grep('%T>%', brio::readLines(file_name))) > 0
  has_epipe <- length(grep('%\\$%', brio::readLines(file_name))) > 0
  has_dt <- length(grep('data.table', brio::readLines(file_name))) > 0 
  has_abr <- length(grep(':=', brio::readLines(file_name))) > 0 

  add_header(file_name, '')

  if (has_abr)
    add_header(file_name, '#\' @importFrom data.table \':=\'')

  if (has_apipe & has_tpipe)
    add_header(file_name, '#\' @importFrom magrittr \'%<>%\' \'%T>%\'')
  else if (has_apipe & !has_tpipe)
    add_header(file_name, '#\' @importFrom magrittr \'%<>%\'')
  else if (!has_apipe & has_tpipe)
    add_header(file_name, '#\' @importFrom magrittr \'%T>%\'')

  add_header(file_name, '')

  if (has_dt & has_epipe) {
    add_header(file_name, '#\' @importFrom magrittr \'%$%\'')
    add_header(file_name, '')
    add_header(file_name, 
      '  utils::globalVariables(c(\'.\'), utils::packageName())')
    add_header(file_name, 'if (getRversion() >= \'2.15.1\')')
    add_header(file_name, '.datatable.aware = TRUE')
  } else if (!has_dt & has_epipe) {
    add_header(file_name, '#\' @importFrom magrittr \'%$%\'')
    add_header(file_name, '')
    add_header(file_name, 
      '  utils::globalVariables(c(\'.\'), utils::packageName())')
    add_header(file_name, 'if (getRversion() >= \'2.15.1\')')
  } else if (has_dt & !has_epipe) {
    add_header(file_name, 
      '  utils::globalVariables(c(\'.\'), utils::packageName())')
    add_header(file_name, 'if (getRversion() >= \'2.15.1\')')
    add_header(file_name, '.datatable.aware = TRUE')
  }

}

