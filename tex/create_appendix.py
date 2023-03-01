import os
import subprocess

# Set paths
HOME = "/proj/ncefi/uncso/projects/ncp_barker/tex"
tables = HOME+"/tables"
figures = HOME+"/figures"
write = HOME+"/sections"
write_main = HOME+"/main_write"

# Function to get list of tables with a certain ending.
def getTableList(ending):
    files = []
    for path in os.listdir(tables):
        if os.path.isfile(os.path.join(tables, path)) & path.endswith(ending):
            files.append(path) #.replace("_","\\_"))
    files.sort()
    return files
def getFigureList(ending):
    files = []
    for path in os.listdir(figures):
        if os.path.isfile(os.path.join(figures, path)) & path.endswith(ending):
            files.append(path) #.replace("_","\\_"))
    files.sort()
    files = [f[:-4] for f in files if f.endswith(".png")]
    return files
# Add tables to the tex.
def addTables(listTables):
        text = '\n'
        for table in listTables:
            text = text + "\\newpage\n"
            text = text + "\\begin{centering}\n"
            pathTable = '"'+"tex/tables/"+table + '"'
            text = text + "\\input{" + pathTable + "}\n"
            text = text + "\\end{centering}\n"
        return text
def addFigures(listFigures):
        text = '\n'
        for fig in listFigures:
            text = text + "\\newpage\n"
            text = text + "\\begin{figure}[h!]\n"
            text = text + "\\begin{centering}\n"
            pathFig = '"'+"tex/figures/"+fig+ '"'
            text = text + "\\includegraphics[scale=1]{" + pathFig + "}\n"
            text = text + "\\end{centering}\n"
            text = text + "\\end{figure}\n"
        return text

# Edit here:
texText = ""
texText = texText + "\n\\section{Summary Statistics}\n"
texText = texText + addTables(getTableList("SUMMARY.tex"))
texText = texText + "\n\\section{Simple DiD}\n"
texText = texText + addTables(getTableList("DID.tex"))
texText = texText + "\n\\section{Between Cohort Changes in STEM by Institution}\n"
texText = texText + addFigures(getFigureList("INSTITUTION_STEM.png"))
texText = texText + "\n\\section{STEM Changes During Enrollment Within NCP by Cohort}\n"
texText = texText + addFigures(getFigureList("CAREER_STEM.png"))

with open(write + "/appendix.tex", "w") as tex_file:
    tex_file.write(r"""
    \newpage
    \appendix
    """ + texText)
#os.chdir(write_main)
#subprocess.call(["pdflatex", "main.tex"])


