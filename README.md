# Manuscript factory

General publication template, with some quality-of-life features. The main
objective is to easily interchange between:

1. The main manuscript/SI file, written in Latex
2. A host of other formats: 
    * PDF, compiling Latex for final manuscripts
    * DOCX, for sharing with collaborators
    * HTML, for online publishing on a static website

The Latex manuscript can also be stripped and simplified for a 1-file submission
to a journal accepting this format. Check out the PDF
[manuscript](./manuscript.pdf) and its [SI](./manuscript-SI.pdf).

### General overview

I wanted to have a way of sharing



### List of software required on path

* latexmk - for pdf compilation
* python3.6+ - for running consolidations scripts
* [git-latexdiff](https://gitlab.com/git-latexdiff/git-latexdiff) - for pdf diffs
* [pandoc](https://pandoc.org) - for conversion to html/docx/odt/md
* [inkscape](https://inkscape.org) - converting any svgs to png/pdf

### Project structure and commands

This project relies on the following folder organisation:

```
├─ Makefile             # makefile for building
├─ manuscript.tex       # manuscript file (!do not add content here)
├─ manuscript-si.tex    # SI manuscript file (!do not add content here)
├─ manuscript-pd.tex    # special pandoc manuscript file (!do not add content here)
│
├───docs                # main manuscript .tex files (!content goes here)
│   └───SI              # manuscript SI .tex files (!SI content goes here)
├───figs                # manuscript figures
├───refs                # bibtex references
├───scripts             # general scripts live here 
│   └───pandoc-scholar  # custom fork of `pandoc-scholar`
└───templates           # latex/doc templates
    ├───acs             # ACS Latex template
    ├───els             # Elsevier Latex template
    ├───pandoc          # pandoc templates
    ├───pi              # personal latex template
    └───rsc             # RSC Latex template
```

Following make commands are available:

`make build` : will use latexmk to compile the manuscript and SI
`make svg2fig` : will use inkscape to convert svg to png+pdf
`make tex2md` : convert tex manuscript to markdown for a pandoc
`make diff` : convert tex manuscript to markdown for a pandoc
`make submit-condense` : condense the manuscript into one single file/folder for journal submission
`make submit-zip` : zip all needed files from previous step
`make submit-clean` : delete all files from condensing command

### Latex template

A clean and modern paper template, which would not look out of place in a
contemporary academic journal. The template class itself is a submodule which
can be found in [another repo](https://github.com/pauliacomi/latex-paper-class)

Template options include:

* One or two column display with the `twocolumn` switch.
* Include a table of contents "highlight" image, with the `toc` switch.
* Academic affiliation in a footnote (standard) or below the 
  authors in the title, with the `affiltop` switch.
* Line numbering for revisions with the `lineno` switch.
* Format change for communication or review-type articles
  with the `commun` and `review` switches.
* An option to generate a Supplemental Information PDF, by creating a separate
  file and using the `SI` class switch. The figures and tables in the SI can
  then be referenced in the main manuscript. **Warning: you should compile the
  SI first!**

The default template can be switched to other templates for common journals
(such as RSC, Elsevier and ACS). In the `manuscript.tex` file, the `\style{}`
command controls this.

A single file exists for storing all metadata `./templates/metadata`. Once
declared here, they will be used in all individual templates.


### Consolidating project in one .tex file

Python scripts are provided to merge all latex files in a single file and then
archive it alongside data, figures and references, often the choice for most
journals. The scripts are not foolproof, but should work for most cases. Three
scripts are provided with the following roles:

* `condense` will join all files in a single TEX file, remove any non-essential
  code, then create a directory `./processed/` with the only the basic files
  needed to compile the PDF.
* `zip` will create an archive with the basic project files in the
  `./processed/` directory. **No PDF files will be included!**
* `clean` will delete all the output of the above scripts.

### Generating differences between revisions

PDFs which show differences between current and previous manuscript state can be
generated using
[git-latexdiff](https://gitlab.com/git-latexdiff/git-latexdiff), which is a
layer of abstraction around `git` and `latexdiff`. For example:

```
git latexdiff master HEAD --main manuscript.tex --pdf-viewer sumatrapdf --latexmk
```

### FAQ

---
*Q: You could have done it this way / it is not efficient / it is not standard.*

A: Latex is a nightmare to code and I am not good at it. Let me know if you have
a better solution!

---
*Q: It doesn't work!.*

A: I would be surprised if it **does** work.

---
*Q: It erased my Nature paper!*

A: Always have a backup.

---
*Q: Why python?*

A: Cross-compatible and easy. Also, I know python.

---
*Q: Why use a custom solution and not latexpand?*

A: Expanding is just one of the steps, it was easier to code from scratch.

---
*Q: Why not code **this** feature ...*

A: [PRs welcome](http://makeapullrequest.com/)

---
