# ==============================================
# Makefile
# AUTHOR: 				Samuel Barker
# EMAIL: 				sbarker@unc.edu
# INSTITUTION: 			UNC Chapel Hill
# ==============================================

# ------------------------
# (0) Setup
# ------------------------
# Set configuration:
# 	directory structure
# 	program versions
# 	options for each program
include config.mk

NCEFI_RAWDATA_PATH = "/proj/ncefi/uncso/rawdata-stata/new_uncso_data/"
NCEFI_RAWDATA=$(shell find $(NCEFI_RAWDATA_PATH) -name *.dta)

GEN_DB_DO=$(shell find src/00managedb/ -name *.do)
GEN_DB_PY=$(shell find src/00managedb/ -name *.py)
GEN_DB=$(GEN_DB_DO) $(GEN_DB_PY)


## "make all" to run entire project.
all : $(WRITEUP)/main.pdf

# Compile LaTeX Document -- Main output
$(WRITEUP)/main.pdf : $(WRITEUP)/main.tex $(OUTPUT) $(TABLES) $(FIGURES)
	$(LATEX) $(WRITEUP)/main.tex


# DATABASE
database : $(DB)
$(DB): $(GEN_DB) $(NCEFI_RAWDATA)
	$(PYTHON) $(filter %.py, $^)


# ------------------------
# (1) The Project
# ------------------------
# Create list of key files (NEED TO DO THIS IN A SEPARATE PYTHON LIST!!!)
#GEN_FILES=$(GEN_DATA)/class_1st.csv $(GEN_DATA)/class_2nd.csv $(GEN_DATA)/class_3rd.csv


all : output.txt

# REMOVE??
output.txt : $(CONFIG)/raw_data_list.txt
	rm output.txt
	touch output.txt

# This is to check if there are new data, but without actually needing to open EVERY time?
$(CONFIG)/raw_data_list.txt : $(CONFIG)/raw_data_list.sh $(CONFIG)/raw_data_list.py $(NCEFI_RAWDATA)
	bash $(CONFIG)/raw_data_list.sh


### "make all" to run entire project.
#all : $(WRITEUP)/main.pdf
#
## Compile LaTeX Document -- Main output
#$(WRITEUP)/main.pdf : $(WRITEUP)/main.tex $(OUTPUT)/numbers.sty
#	$(LATEX) $(WRITEUP)/main.tex
#
## Update input for LaTeX.
#$(OUTPUT)/numbers.sty : $(SRC)/main.py $(SRC)/programs.py $(GEN_FILES)
#	$(PYTHON) $(SRC)/main.py
#
## Clean data using Julia.
#$(GEN_FILES) : $(SRC)/main.jl $(RAW_DATA)/titanic.csv
#	$(JULIA) $(SRC)/main.jl
#
## Set Julia environment.
#$(SRC)/main.jl : $(SRC)/jlenv/serverjlenv.so
#$(SRC)/jlenv/serverjlenv.so : $(SRC)/jlenv/initjl.jl
#	$(JULIA_INIT) $(SRC)/jlenv/initjl.jl
#
## Download data using R script.
#$(RAW_DATA)/titanic.csv : $(RAW_DATA)/get_data.r
#	$(R) $(RAW_DATA)/get_data.r
#
#
## ------------------------
## (99) Independent options
## ------------------------
.PHONY : help HARD_RESET clean tex update setup
## "make help" to print out headings of each section.
help : Makefile
	@sed -n 's/^##//p' $<
## "make HARD_RESET" to delete raw data and restart.
HARD_RESET:
	$(PYTHON) $(RAW_DATA)/clean.py
## "make clean" to delete generated data.
clean : 
	$(PYTHON) $(GEN_DATA)/clean.py
## "make update" to update LaTeX inputs and compile LaTeX.
update :
	$(PYTHON) $(SRC)/main.py
	$(LATEX) $(WRITEUP)/main.tex
## "make tex" to compile LaTeX.
tex : 
	$(PYTHON) $(WRITEUP)/create_appendix.py
	$(LATEX) $(WRITEUP)/main.tex
texdiag : 
	$(PYTHON) $(WRITEUP)/create_appendix.py
	$(LATEX_DIAG) $(WRITEUP)/main.tex
setup : 
	bash $(CONFIG)/loadpackages.sh
	(source $(CONFIG)/loadpackages.sh)

# I want a section that just builds the database ... make database
