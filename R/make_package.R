#' @title make_package
#' @description Adds *roxygen2* headers and creates many of the files needed for an R package.
#' @param source_directory character, the full path of the source directory (the directory containing .R files in which work has been done to develop the package)
#' @param package_directory character, the full path of the package directory
#' @param first_and_last_names character, your first and last names, separated by a space
#' @param github_username character, your username on GitHub
#' @param email character, your email address
#' @param package_description character, description of the package which will be written in `DESCRIPTION`
#' @param dictionary_file character, the location of the dictionary file (please indicate full file path)
#' @param repo_name character, the preferred CRAN repo used to update R packages, Default: 'https://cran.seoul.go.kr/'
#' @details Makes DESCRIPTION and NAMESPACE files.  Handles licensing and documentation.  Creates an roxygen2 header for each function using a custom parameter dictionary.
#' @note Adding entries into the custom dictionary file (specified with the `dictionary_file` param) will automatically fill in parameters in the roxygen2 header.
#' @references [R Bloggers](https://www.r-bloggers.com/2017/05/sinew-a-r-package-to-create-self-populating-roxygen2-skeletons)
#' \cr [rdrr.io](https://rdrr.io/github/yonicd/sinew/man/makeOxyFile.html)
#' \cr [Sinew GitHub](https://github.com/yonicd/sinew)
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  packagemakeR::make_package(
#'    source_directory = '~/source-dir/R', 
#'    package_directory = '~/package-dir',
#'    first_and_last_names = 'John Doe',
#'    github_username = 'john-doe',
#'    email = johndoe@email.com,
#'    package_description = 'My package description.',
#'    dictionary_file = '~/git/packagemakeR/inst/extdata/dictionary.R',
#'    repo_name = 'https://cran.seoul.go.kr/')
#'  }
#' }
#' @export 
#' @importFrom utils person install.packages
#' @importFrom devtools update_packages install_github document
#' @importFrom sinew make_import
#' @importFrom usethis create_package use_gpl3_license use_pipe
make_package <- function(source_directory,
                         package_directory,
                         first_and_last_names,
                         github_username,
                         email,
                         package_description,
                         dictionary_file,
                         repo_name = 'https://cran.seoul.go.kr/')
{

  # adjust directory names
  adj_path <- function(path) paste(unlist(strsplit(path, '/')),collapse='/')

  source_directory <- adj_path(source_directory)
  package_directory <- adj_path(package_directory)

  # adds period to package_description
  last_char <- package_description %>% substr(., nchar(.), nchar(.))
  if (last_char != '.') package_description <- paste0(package_description, '.')

  # stops if first_and_last_names contains more/less than two words
  if (lengths(strsplit(first_and_last_names, " ")) != 2)
    stop('Please enter a first and last name, separated by a space')

  # options
  split_name <- unlist(strsplit(first_and_last_names, ' '))
  package_title <- unlist(strsplit(package_directory, '/')) %>% .[length(.)]

  op <- options(tab.width = 2,
          repos = c(CRAN = repo_name),
          menu.graphics = FALSE,
          usethis.full_name = first_and_last_names,
          usethis.protocol  = 'ssh',
          usethis.destdir = package_directory,
          usethis.overwrite = TRUE,
          usethis.description = list(
            'Authors@R' = utils::person(
              split_name[1], split_name[2],
              email = email,
              role = c('aut', 'cre')),
            Title = package_title,
            Description = package_description,
            Version = '0.0.0.9000',
            Maintainer = paste0(first_and_last_names, ' <', email, '>'),
            URL = file.path('https:/', 'github.com', github_username, 
              package_title),
            BugReports = file.path('https:/', 'github.com', github_username, 
              package_title, 'issues')))

  on.exit(options(op))

  # install packages
  if (length(find.package('devtools')) == 0) 
    utils::install.packages('devtools')

  devtools::update_packages(upgrade = 'always')

  # make package
  usethis::create_package(package_directory, check_name = FALSE)
  setwd(package_directory)

  # license
  usethis::use_gpl3_license()

  # copy files
  file.copy(
    list.files(source_directory, full.names = TRUE, all.files = TRUE, 
      recursive = TRUE), 
    file.path(package_directory, 'R'), 
    recursive = TRUE
  )

  for (i in list.files('R', full.names = TRUE)) {
    make_pretty_headers(i)

    # completes 'Imports' section of DESCRIPTION
    sinew::make_import(i, cut = 5, print = FALSE, 
      format = 'description', desc_loc = package_directory)
  }

  usethis::use_pipe()
  devtools::document()
  file.create('README.md')
  add_header('README.md', paste0('# ', package_title))

}

