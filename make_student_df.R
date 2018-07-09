library(dplyr)
library(readr)
library(googledrive)

fname = "student_df.rds"
if (!file.exists(fname)) {
  id = "1-AIVDl-f5xjGnPxlmnIgiUoibLtmJbHFXZ8Uhzfx3OA"
  dl = drive_download(file = as_id(id),
                      path = tempfile(fileext = ".csv")
                      )
  student_df = read_csv(dl$local_path)
  write_rds(student_df, fname)
}
