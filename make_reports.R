library(yaml)
library(rmarkdown)
student_df = readr::read_rds("student_df.rds")
names = student_df$name
name = names[1]
for (name in names) {
  res = readLines("cbds-report.Rmd")
  ind = grep("^-", res)[2]
  hdr = res[1:ind]
  yml = read_yaml(text = hdr)
  yml$params$name = name
  new_yaml = as.yaml(yml)
  tfile = tempfile()
  writeLines(new_yaml, tfile)
  reread = c("---", readLines(tfile), "---")
  
  res = c(reread, res[seq(ind + 1, length(res))])
  outfile = paste0("cbds-report-", name, ".Rmd")
  writeLines(res, outfile)
  rmarkdown::render(outfile)
}
# }
