# Knit the HTML version
rmarkdown::render("joeroe_cv.Rmd",
                  params = list(pdf_mode = FALSE),
                  output_file = "joeroe_cv.html")

# Knit & print the PDF version
tmp_html_cv_loc <- fs::file_temp(ext = ".html")
rmarkdown::render("joeroe_cv.Rmd",
                  params = list(pdf_mode = TRUE),
                  output_file = tmp_html_cv_loc)
pagedown::chrome_print(input = tmp_html_cv_loc,
                       output = "joeroe_cv.pdf")
