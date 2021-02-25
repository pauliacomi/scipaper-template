# References to main files
TEX_FILE_MASTER     = manuscript.tex
TEX_FILE_SI         = manuscript-si.tex
TEX_FILE_PANDOC     = manuscript-pd.tex
ARTICLE_FILE        = manuscript.md

# Programs used
TEX_ENGINE 	        = xelatex
TEX                 = latexmk -$(TEX_ENGINE) -interaction=nonstopmode -file-line-error -pdf
PYTHON 	            = python

# Paths to templates
CUSTOM_REFERENCE_PATH   = templates/pandoc/csl
TEMPLATE_FILE_HTML      = templates/pandoc/t-paper/html/template.html
TEMPLATE_STYLE_HTML     = templates/pandoc/t-paper/html/template.css
DOCX_REFERENCE_FILE     = templates/pandoc/t-paper/docx/template.docx
TEMPLATE_FILE_LATEX     = templates/pandoc/t-paper/tex/manuscript-pd.tex
CLASS_FILE_LATEX        = templates/pi/pi-article
PANDOC_SCHOLAR_PATH     = scripts/pandoc-scholar

# Options for pandoc-scholar
PANDOC_READER_OPTIONS   = --data-dir=templates
PANDOC_READER_OPTIONS  += --defaults=templates/pandoc/defaults/base

PANDOC_LATEX_OPTIONS    = --pdf-engine=$(TEX_ENGINE)
PANDOC_LATEX_OPTIONS   += --variable=documentclass:$(CLASS_FILE_LATEX)
PANDOC_LATEX_OPTIONS   += --natbib
PANDOC_LATEX_OPTIONS   += --citeproc

# PANDOC_HTML_OPTIONS     = --toc --self-contained
PANDOC_HTML_OPTIONS     = --toc
PANDOC_EPUB_OPTIONS     = --toc

# Filter for converting chemical formulas
PANDOC_DOCX_OPTIONS	   := --lua-filter=./scripts/pd-chem-filter.lua $(PANDOC_WRITER_OPTIONS)

OUTFILE_PREFIX          = index
DEFAULT_EXTENSIONS     ?= html doc

include $(PANDOC_SCHOLAR_PATH)/Makefile

# Must be prepended to the options, as has to come before citeproc
# PANDOC_WRITER_OPTIONS := --filter=pandoc-xnos $(PANDOC_WRITER_OPTIONS)
PANDOC_WRITER_OPTIONS := --filter=./scripts/pandoc-crossref $(PANDOC_WRITER_OPTIONS)
PANDOC_WRITER_OPTIONS += --lua-filter=./scripts/pd-image-filter.lua
PANDOC_WRITER_OPTIONS += --csl=$(CUSTOM_REFERENCE_PATH)/ieee.csl

# Building with latexmk
.PHONY: build
build: $(TEX_FILE_SI) $(TEX_FILE_MASTER)
	$(TEX) $(TEX_FILE_SI)
	$(TEX) $(TEX_FILE_MASTER)

# Converting all svgs to png using inkscape
SVGS = $(wildcard figs/*.svg)

.PHONY: svg2fig
svg2fig: $(SVGS)
	$(PYTHON) ./scripts/inkscape-convert.py $(SVGS)

# Building with latexmk
.PHONY: tex2md
tex2md:
	$(PYTHON) ./scripts/pd-meta.py
	pandoc -s $(TEX_FILE_PANDOC) -o $(ARTICLE_FILE) \
	--from latex \
	--to markdown+smart+grid_tables \
	--default-image-extension=".png" \
	--citeproc \
	--lua-filter=./scripts/pd-image-filter.lua \
	--lua-filter=./scripts/pd-chem-filter.lua \
	--lua-filter=./scripts/pd-ref-filter.lua \
	-H ./templates/metadata-pd.yaml \
	--verbose --columns=100

# Making a diff of the manuscript with latexdiff
.PHONY: diff
diff:
	git latexdiff HEAD -- --main $(TEX_FILE_MASTER) \
	--no-view --latexmk --ignore-makefile \
	--packages=amsmath,hyperref,siunitx,cleveref,mhchem \
	--exclude-safecmd=pubSI -o manuscript-diff.pdf --verbose

# Custom make commands for pandoc-scholar
tex:	$(addprefix $(OUTFILE_PREFIX).,latex)
pdf:	$(addprefix $(OUTFILE_PREFIX).,pdf)
docx:	$(addprefix $(OUTFILE_PREFIX).,docx)
html:	$(addprefix $(OUTFILE_PREFIX).,html)
epub:	$(addprefix $(OUTFILE_PREFIX).,epub)

# Submission scripts
.PHONY: submit-condense
submit-condense:
	$(PYTHON) ./scripts/condense.py

.PHONY: submit-zip
submit-zip:
	$(PYTHON) ./scripts/zip.py

.PHONY: submit-clean
submit-clean:
	$(PYTHON) ./scripts/clean.py