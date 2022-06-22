add_header <- function(filename, header) 
{
  existing <- brio::readLines(filename)
  sink(filename)
  cat(header, '\n')
  cat(existing, sep = '\n')
  sink()
}
