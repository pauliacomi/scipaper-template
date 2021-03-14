---
author:
- Paul Iacomi:
    correspondence: yes
    email: mail\@pauliacomi.com
    equal_contributor: yes
    institute:
    - a
    - b
    orcid: 0000-0001-5477-1503
- Someone Else:
    equal_contributor: yes
    institute:
    - a
    orcid: 0000-0001-5124-7052
autoEqnLabels: true
bibliography:
- refs/biblio.bib
cref: false
institute:
- a:
    name: My current affiliation, with address and everything.
- b:
    name: Long address from someone else or other affiliation
link-citations: true
linkReferences: true
number-sections: true
project:
  title: project
title: This is the paper title
xnos-capitalise: true
xnos-number-by-section: false
---

# Abstract

# Introduction

Herein we refer to a table ([@tbl:example-table]), but also to a figure ([@fig:caption-1]) or a
latter equation ([@eq:example]). Finally, figures ([@fig:caption-si]) from the SI can also be
referenced. We can add citations as well [@example]. Units are inserted with the help of `siunitx`.
We can have some standard data 40 kJ/mol or ranges such as 20 Å--30 Å. Finally simple unit
typesetting is also possible MHz/kPa.

Chemistry is included by referring to the `mhchem` package. Simple molecules like $\ce{N2}$ and
$\ce{C2H4}$ should be easy to include. More complex formula typesetting is possible too:
$\ce{^{13}C}$ NMR, $\ce{CaCl2 * 12H2O}$ and $\ce{Fe^{II}Fe^{III}2O4}$.

Equations are in a standard Latex `equation` environment.

$$
    e^{i\pi} + 1 = 0$$ {#eq:example}

# Materials and methods

::: {#tbl:example-table}
                Head 1                 Head 2            Head 3
  ---------------------------------- ----------- -----------------------
              Content 1               Content 2      Long Content 2
              Content 4               Content 5   Even Longer Content 6
   \* Multicolmns are also possible              

  :  An example table, with caption on top.
:::

# Results and discussion

![ Example small figure and its caption. ](figs/example-image.png){#fig:caption-1
width="0.9\\linewidth"}

![ Example twocolumn large figure. ](figs/example-image.png){#fig:caption-2 width="0.9\\linewidth"}

# Conclusions

# Acknowledgements {#acknowledgements .unnumbered}

# Author contributions {#author-contributions .unnumbered}

# Supplementary Information

## SI section 1

Here is a citation. [@example]

![ Example caption. ](figs/example-image.png){#fig:caption-si width="0.9\\linewidth"}

## SI section 2

We are referring to previous [@fig:caption-si].

# References {#references .unnumbered}
