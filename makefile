all: student_df.rds cbds-report-*.html README.html 

student_df.rds: make_student_df.R
	Rscript make_student_df.R

cbds-report-*.html: cbds-report.Rmd make_reports.R datacamp/*.csv all_courses/*.csv
	Rscript make_reports.R

README.html: README.Rmd
	Rscript -e "rmarkdown::render('README.Rmd')"

clean: 
	rm -f cbds-report-*.html 
