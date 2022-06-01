# packagemakeR

## Description
- An R package that makes R packages
- Creates `DESCRIPTION`, `NAMESPACE`, and all other documentation
- Adds *roxygen2* header to each function, with special attention given to *magrittr* and *data.table* functions
- Puts the package on GitHub

## Requirements

### For `push_package()`
  - Set up an OAuth token on GitHub and verify that you can create repos via the terminal
  - Set up *pass* and store your GitHub OAuth token in `github/oauth-token` in your password store
  - Only tested on Arch Linux, however system-related code should also work on MacOS

## Install
- After running the below, you will be prompted to update your packages; please update them
- If updating packages yields errors, try again without a system or directory-specific `.Rprofile`
```r
devtools::install_github('causality-loop/packagemakeR')
```

## Dictionary
- The parameter (@param) dictionary can be referenced by `make_package()` to auto-code *roxygen2* headers
- Edit to your liking, then store in a safe place
```sh
wget https://raw.githubusercontent.com/causality-loop/packagemakeR/master/inst/extdata/dictionary.R
```

## Workflow

### Create a package
```r
packagemakeR::make_package(
  source_directory = '~/mypackage-draft/funs', 
  package_directory = '~/git/myPackage',
  first_and_last_names = 'John Doe',
  github_username = 'john-doe',
  email = 'johndoe@email.com',
  package_description = 'My package description.',
  dictionary_file = '~/git/packagemakeR/inst/extdata/dictionary.R',
  repo_name = 'https://cran.seoul.go.kr/')
```

### Edit
#### For each function in the `R` directory
- Edit the *roxygen2* headers
- Check `globalVariables` for correctness, or let errors be caught by `devtools::check()` later

#### Documentation
- Check `DESCRIPTION` and other documentation for correctness
- Complete `README.md`

#### Base package reference
- Sometimes *base* must be specified when calling certain functions
- For each function, remove any lines containing `base` (eg `#' '@importFrom base someFun`) from the *roxygen2* header
- For `DESCRIPTION` and `NAMESPACE`, do the same
- Rerun `devtools::check()`

### Push to GitHub
- Run `devtools::document()` only if you get a `check() will no re-document this package` warning when running `devtools::check()`, then rerun `devtools::check()` after doing so
```sh
R -e "devtools::document()"
R -e "devtools::check()"
R -e "devtools::install()"
R -e "packagemakeR::push_package('~/some-dir', 'About my package.', 'john-doe')"
```
 
