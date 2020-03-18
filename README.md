# Manuscript template

General publication latex template, with some quality-of-life features.

### Highlights

* A clean and modern paper template, which would not look out of
  place in a contemporary academic journal.

* Template options include:

    * One or two column display with the `twocolumn` switch.
    * The option to include a table of contents "highlight" image, 
      with the `toc` switch.
    * Academic affiliation in a footnote (standard) or below the 
      authors (with the `affiltop` switch).
    * Line numbering with the `lineno` switch.
    * An option to generate a Supplemental Information PDF, by
      creating a separate file and using the `SI` class switch.
      The figures and tables in the SI can then be referenced in
      the main manuscript, which is done using the xr package,
      and the `\externaldocument{}` command in the main document.
      **Warning: you should compile the SI first!**

* The default template can be seamlessly switched to standard
  templates for common journals (such as RSC, Elsevier and ACS).
  In the main file, the `\style{}` command can be changed to
  change template.

* A single place for all metadata `./setting/metadata`.
  Once declared here, the created commands can be used to customize
  individual templates.

* The project is logically split into multiple folders and files to
  encourage collaboration. Git can be used to keep track of everything.

* Finally python scripts are provided to consolidate the project in a
  single TEX file and then archive it, often the choice for most
  journals.

### Some details

The python scripts are not foolproof, but should work for most cases.
Three scripts are provided with the following roles:

* `condense` will join all files in a single TEX file,
  remove any non-essential code, then create a directory
  `./processed/` with the only the basic files needed
  to compile the PDF.
* `zip` will create an archive with the basic project 
  files in the `./processed/` directory.
  **No PDF files will be included!**
* `clean` will delete all the output of the above scripts.

A difference between revisions can be generated using 
[git-latexdiff](https://gitlab.com/git-latexdiff/git-latexdiff), which
is a layer of abstraction around `git` and `latexdiff`. For example:

```
git latexdiff master HEAD --main manuscript.tex --pdf-viewer sumatrapdf --latexmk
```

### FAQ

---
*Q: You could have done it this way / it is not efficient / it is not standard.*

A: Latex is a nightmare to code and I am not good at it.
Let me know if you have a better solution!

---
*Q: It doesn't work!.*

A: I would be surprised if it **does** work. Let me know what problems you find.

---
*Q: It erased my Nature paper!*

A: Backup? Also git.

---
*Q: Why python?*

A: Cross-compatible. Also, I know python.

---
*Q: Why use a custom solution and not latexpand?*

A: Expanding is just one of the steps, it was easier to code from scratch.

---
*Q: Why not code **this** feature ...*

A: [PRs welcome](http://makeapullrequest.com/)

---
