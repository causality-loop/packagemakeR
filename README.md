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
  - Only tested on Arch Linux!

## Workflow

### Install
```r
devtools::update_packages(upgrade = 'always')
devtools::install_github('causality-loop/packagemakeR')
```

### Dictionary
- Edit the dictionary to your liking and store in a convenient place
```sh
wget https://raw.githubusercontent.com/causality-loop/packagemakeR/master/inst/extdata/dictionary.R
nvim dictionary.R
```

### Create a package
```r
packagemakeR::make_package(
  source_directory = '~/source-dir/R', 
  package_directory = '~/package-dir',
  first_and_last_names = 'John Doe',
  github_username = 'john-doe',
  email = johndoe@email.com,
  package_description = 'My package description.',
  dictionary_file = '~/git/packagemakeR/inst/extdata/dictionary.R',
  repo_name = 'https://cran.seoul.go.kr/')
```

### Editing
- Edit the *roxygen2* headers for each file in the `R` directory
- Check `DESCRIPTION`
- Verify that other documentation is correct
- Complete `README.md`

### Push to GitHub
```sh
R -e "devtools::check()"
R -e "devtools::install()"
R -e "packagemakeR::push_package('~/some-dir', 'About my package.', 'john-doe')"
```
 
