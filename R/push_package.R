if (getRversion() >= '2.15.1')
  utils::globalVariables(c('.'), utils::packageName())

#' @title push_package
#' @description Puts a package on GitHub.
#' @note Only tested on Arch Linux.
#' @note Your GitHub OAuth token should be in your password store under `github/oauth-token`.
#' @param package_directory character, the full path of the directory containing the package
#' @param package_description character, the package description which will be on GitHub
#' @param github_username character, your username on GitHub
#' @param homepage character, either 'null' or the project URL which will be shown on GitHub as the project homepage, Default: 'null'
#' @param private character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param fork character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'true'
#' @param has_downloads character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'true'
#' @param has_issues character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'true'
#' @param has_projects character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param has_wiki character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @param has_pages character, a boolean 'true' or 'false' value (but inputted as a character in lowercase letters) which indicates a GitHub repo option, Default: 'false'
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  packagemakeR::push_package(
#'    package_directory = '~/package-dir', 
#'    package_description = 'This is the description seen on GitHub.', 
#'    github_username = 'john-doe',
#'    homepage = 'null',
#'    private = 'false',
#'    fork = 'true',
#'    has_downloads = 'true',
#'    has_issues = 'true',
#'    has_projects = 'false',
#'    has_wiki = 'false',
#'    has_pages = 'false')
#'  }
#' }
#' @export 
push_package <- function(package_directory, 
                         package_description, 
                         github_username,
                         homepage = 'null',
                         private = 'false',
                         fork = 'true',
                         has_downloads = 'true',
                         has_issues = 'true',
                         has_projects = 'false',
                         has_wiki = 'false',
                         has_pages = 'false')
{

  optq <- function(option_name) {
    paste0('"', deparse(substitute(option_name)), '": "', option_name, '", ')
  }

  optnq <- function(option_name) {
    paste0('"', deparse(substitute(option_name)), '": ', option_name, ', ')
  }

  optend <- function(option_name) {
    paste0('"', deparse(substitute(option_name)), '": ', option_name)
  }

  adj_path <- function(path) paste(unlist(strsplit(path, '/')),collapse='/')
  package_directory <- adj_path(package_directory)

  package_name <- unlist(strsplit(package_directory, '/')) %>% .[length(.)]
  str1 <- paste0('curl -u ', github_username, ':$(pass github/oauth-token) ')
  str2 <- 'https://api.github.com/user/repos -d \'{'

  default_branch <- 'master'
  name <- package_name
  description <- package_description

  curl_cmd <- paste0(str1, str2, optq(name), optq(description), 
    optq(default_branch), optnq(homepage), optnq(private), optnq(fork), 
    optnq(has_downloads), optnq(has_issues), optnq(has_projects), 
    optnq(has_wiki), optend(has_pages), "}'")

  system(curl_cmd)
  setwd(package_directory)
  system('git init')
  system('git add -A')
  system('git commit -m "first commit"')
  system(paste0('git remote add origin git@github.com:', github_username, '/', 
    package_name, '.git'))
  system('git push -u origin master')

}

