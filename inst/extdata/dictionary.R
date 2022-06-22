#' @param \dots additional parameters passed to \code{somePackage}
#' @param asset_info a character vector of asset symbols or a list of character vectors containing symbol and date info (see *Note*)
#' @param deploy boolean, TRUE if the model should be deployed in a live trading environment, FALSE if it's just being used for testing/research, Default: TRUE
#' @param dictionary_file character, the location of the dictionary file (please indicate full file path)
#' @param email character, your email address
#' @param file_name character, the file name relative to the work directory or, if none, the full path to the file
#' @param first_and_last_names character, your first and last names, separated by a space
#' @param fork character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'true'
#' @param from_date a character (representing a date in YYYY-MM-DD format) which fills in missing values for the start of each date range
#' @param from_date a character (representing a date in YYYY-MM-DD format) which is passed to `quantmod::getSymbols()`
#' @param github_username character, your username on GitHub
#' @param has_downloads character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'true'
#' @param has_issues character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'true'
#' @param has_pages character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param has_projects character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param has_wiki character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param homepage character, either 'null' or the project URL which will be shown on GitHub as the project homepage, Default: 'null'
#' @param model_units, how many units to allocate to this model
#' @param package_description character, description of the package which will be written in `DESCRIPTION`
#' @param package_description character, the package description which will be on GitHub
#' @param package_directory character, the full path of the package directory
#' @param private character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param repo_name character, the preferred CRAN repo used to update R packages, Default: https://cran.seoul.go.kr/
#' @param source_directory character, the full path of the source directory (the directory containing .R files in which work has been done to develop the package)
