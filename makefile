# Notes: 
# - If run on unix system, use rm instead of del command in clean  
# - Careful with spaces! If use \ to split to multiple lines, cannot have a space after \ 

# OVERALL BUILD RULES
all: data_cleaned results paper audit
audit: gen/analysis/output/exploration.html
paper: gen/paper/output/paper.pdf
data_cleaned: gen/data-preparation/output/data_cleaned.RData
results: gen/analysis/output/model_results.RData
.PHONY: clean

# INDIVIDUAL RECIPES

# Generate paper/text
gen/paper/output/paper.pdf: gen/paper/output/table1.tex \
				src/paper/paper.tex
	pdflatex -interaction=batchmode -output-directory='gen/paper/output/' 'src/paper/paper.tex' 
	pdflatex -interaction=batchmode -output-directory='gen/paper/output/' 'src/paper/paper.tex' 
	pdflatex -output-directory='gen/paper/output/' 'src/paper/paper.tex' 
# Note: runs pdflatex multiple times to have correct cross-references

# Generate tables 
gen/paper/output/table1.tex: gen/analysis/output/model_results.RData src/paper/tables.R
	RScript src/paper/tables.R

# Run analysis  
gen/analysis/output/model_results.RData: gen/data-preparation/output/data_cleaned.RData \
						src/analysis/analyze.R
	RScript src/analysis/update_input.R
	RScript src/analysis/analyze.R

#Inspect data
gen/analysis/output/exploration.html: gen/data-preparation/temp/df_merged_airbnb.csv
	R -e "rmarkdown::render('src/data-preparation/Exploration.Rmd', output_file = '../../gen/analysis/output/exploration.html')"

# Clean data
gen/data-preparation/output/data_cleaned.RData: data/dataset1/dataset1.csv \
						data/dataset2/dataset2.csv \
						data/dataset3/listings.csv \
						data/dataset4/reviews.csv \
						src/data-preparation/merge_data.R \
						src/data-preparation/clean_data.R \
						gen/data-preparation/temp/df_merged_airbnb.csv
	RScript src/data-preparation/update_input.R
	RScript src/data-preparation/merge_data.R
	RScript src/data-preparation/clean_data.R 

# Download data
data/dataset1/dataset1.csv data/dataset2/dataset2.csv data/dataset3/listings.csv data/dataset4/reviews.csv: src/data-preparation/download_data.R 
	RScript src/data-preparation/download_data.R 

# Clean-up: Deletes temporary files
# Note: Using R to delete files keeps platform-independence. 
# 	    --vanilla option prevents from storing .RData output
clean: 
	RScript --vanilla src/clean-up.R
	
