ARTICLE_FILE        = manuscript.md
TEX_FILE            = manuscript-pd.tex

CUSTOM_REFERENCE_PATH   = templates/pandoc/csl
TEMPLATE_FILE_HTML      = templates/pandoc/t-paper/html/template.html
TEMPLATE_STYLE_HTML     = templates/pandoc/t-paper/html/template.css
DOCX_REFERENCE_FILE     = templates/pandoc/t-paper/docx/template.docx
TEMPLATE_FILE_LATEX     = templates/pandoc/t-paper/tex/manuscript-pd.tex
CLASS_FILE_LATEX        = templates/pi/pi-article
PANDOC_SCHOLAR_PATH     = scripts/pandoc-scholar

PANDOC_READER_OPTIONS   = --data-dir=templates
# PANDOC_READER_OPTIONS  += --defaults=base

PANDOC_LATEX_OPTIONS    = --pdf-engine=xelatex
PANDOC_LATEX_OPTIONS   += --variable=documentclass:$(CLASS_FILE_LATEX)
PANDOC_LATEX_OPTIONS   += --natbib
PANDOC_LATEX_OPTIONS   += --filter=pandoc-citeproc

# PANDOC_HTML_OPTIONS     = --toc --self-contained
PANDOC_HTML_OPTIONS     = --toc
PANDOC_EPUB_OPTIONS     = --toc

DEFAULT_EXTENSIONS    ?= html doc tex pdf

include $(PANDOC_SCHOLAR_PATH)/Makefile

tex2md:
	pandoc -s $(TEX_FILE) -o $(ARTICLE_FILE) \
	--from latex \
	--to markdown+smart+grid_tables \
	--lua-filter=./scripts/pd-image-filter.lua \
	-H manuscript-pd-head.yaml --verbose --columns=100

# Must be prepended to the options, as has to come before citeproc
PANDOC_WRITER_OPTIONS := --filter=pandoc-xnos $(PANDOC_WRITER_OPTIONS)
PANDOC_WRITER_OPTIONS += --csl=$(CUSTOM_REFERENCE_PATH)/ieee.csl