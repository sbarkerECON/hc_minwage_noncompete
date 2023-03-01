
# ====================================
# Configuration file for Makefile.
# ====================================

## DIRECTORY STRUCTURE
CONFIG=.configmake
SRC=src
RAW_DATA=data/raw
GEN_DATA=data/generated
WRITEUP=tex
TABLES=$(shell find "$(WRITEUP)/tables/" -name *tex)
FIGURES=$(shell find "$(WRITEUP)/figures/" -name *png)
OUTPUT=$(shell find "$(WRITEUP)/output/" -name *sty)

## IMPORTANT FILES
DB=data/uncso.db

## CODE ENVIRONMENT
# R Environment
R=Rscript --no-save
# Python Environment
PYTHON=python3
# Julia Environment
JULIA_INIT=julia --project=src/jlenv
JULIA=julia --project=src/jlenv --sysimage "src/jlenv/serverjlenv.so"
# LaTeX Environment
LATEX=pdflatex --interaction=batchmode -output-directory=$(WRITEUP) 
LATEX_DIAG=pdflatex -output-directory=$(WRITEUP) 
