library(yaml)
library(rmarkdown)
library(httr)
# try muschelli's branch on github
library(slackr)

student_df = readr::read_rds("student_df.rds")
for (m in 1:nrow(student_df)) {
  res = readLines("cbds-report.Rmd")
  ind = grep("^-", res)[2]
  hdr = res[1:ind]
  yml = read_yaml(text = hdr)
  yml$params$name = student_df$name[m]
  new_yaml = as.yaml(yml)
  tfile = tempfile()
  writeLines(new_yaml, tfile)
  reread = c("---", readLines(tfile), "---")
  
  res = c(reread, res[seq(ind + 1, length(res))])
  outfile = paste0("cbds-report-", student_df$name[m], ".Rmd")
  writeLines(res, outfile)
  rmarkdown::render(outfile)
  
  # post as a private slack message to student
  slackr_upload(
    filename = paste0("./cbds-report-", student_df$name[m], ".html"),
    channels = student_df$slack_id[m],
    api_token = Sys.getenv("SLACK_API_TOKEN"))
  
  # post to dailycheckings private channel
  slackr_upload(
    filename = paste0("./cbds-report-", student_df$name[m], ".html"),
    channels = "dailycheckins",
    api_token = Sys.getenv("SLACK_API_TOKEN"))
}



