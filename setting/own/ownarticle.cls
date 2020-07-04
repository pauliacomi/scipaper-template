%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ownarticle.cls, v3.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ownarticle}[17/03/2020, v3.1]

% Option for SI
\newif\if@switchSI
\DeclareOption{SI}{\@switchSItrue}

% Option for line numbers
\newif\if@switchlineno
\DeclareOption{lineno}{\@switchlinenotrue}

% Option for affiliation
\newif\if@switchaffil \@switchaffilfalse
\DeclareOption{affiltop}{\@switchaffiltrue}

% Option for toc image
\newif\if@switchtoc \@switchtocfalse
\DeclareOption{toc}{\@switchtoctrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions*\relax
\LoadClass{extarticle}

%% Options for element switching
\RequirePackage{xifthen}
\newboolean{shortintro}
\newboolean{singlecolumn}
\newboolean{toprule}
\setboolean{toprule}{true}

% Switch for SI
\if@switchSI
\setboolean{toprule}{false}
\setboolean{shortintro}{true}
\setboolean{singlecolumn}{true}
\def\thepage{S\arabic{page}}
\renewcommand*\thefigure{S\arabic{figure}}
\renewcommand*\thetable{S\arabic{table}}
\renewcommand*\theequation{S\arabic{equation}}
\AtBeginDocument{%
    \renewcommand*\citenumfont[1]{S#1}%
    \renewcommand*\bibnumfmt[1]{(S#1)}%
}
\fi

%%%%%%%%%%%%%%%%%%%%%% Fonts and language

% Fonts
\RequirePackage{lmodern}
\RequirePackage[scaled]{helvet}

% Microtype
\AtEndOfClass{\RequirePackage{microtype}}

% AMS maths packages
\RequirePackage{
  amsmath,
  amsfonts,
  amsthm,
  amssymb
}

% Encodings
\usepackage{ifxetex,ifluatex}
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \RequirePackage[TS1,T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
\else % if luatex or xelatex
  \ifxetex
    \usepackage{mathspec}
  \else
    \usepackage{fontspec}
  \fi
  \defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
\fi

% Language
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \RequirePackage[english]{babel}
\else
  \usepackage{polyglossia}
  \setmainlanguage[]{english}
\fi

%%%%%%%%%%%%%%%%%%%%%% Graphics packages, tables and listings

\RequirePackage{graphicx}
\RequirePackage{colortbl}
\RequirePackage{changepage}
\RequirePackage{afterpage}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\usetikzlibrary{svg.path}
\usetikzlibrary{calc}
\RequirePackage[framemethod=tikz]{mdframed}

% Floats
\RequirePackage{float}
% For the floatbarrier macro
\RequirePackage[section]{placeins}
% Fixes for twocolumn floats
\RequirePackage{dblfloatfix}

% Better tables 
\RequirePackage{
  longtable,
  booktabs,
  makecell,
  array,
  multirow,
  tabularx
}

% Better captions 
\RequirePackage[labelfont={bf,sf},%
                labelsep=period,%
                figurename=Fig.]{caption}

% For subfigures
\RequirePackage{subcaption}

%% For sidecaptions
\RequirePackage[rightcaption]{sidecap}

% For code snippets
\RequirePackage{listings}

% Lists
\RequirePackage{enumitem} % For reducing bullet list item separation

% Todo notes
\RequirePackage{todonotes}

%%%%%%%%%%%%%%%%%%%%%% Science-related packages

% In-line fractions
\RequirePackage{xfrac}

% The SIunitx package enables the \SI{}{} command.
\RequirePackage{siunitx}
\sisetup{detect-weight=true, detect-family=true}

% The mchem package for formula subscripts using \ce{}
\RequirePackage[version=4]{mhchem}

%%%%%%%%%%%%%%%%%%%%%% Bibliography packages and settings

% Natbib package for text references
\RequirePackage[
    numbers,
    merge,
    % round,
    super,
    sort&compress
]{natbib}
    
%% Moves references after punctuation
\RequirePackage{natmove}
\renewcommand*{\natmovechars}{.}
    
%% Use ownbib.bst if available else fall back to unsrtnat
\setlength{\bibsep}{0.0pt}
\IfFileExists{setting/own/ownbib.bst}{
  \bibliographystyle{setting/own/ownbib}
}{
  \IfFileExists{ownbib.bst}{
  \bibliographystyle{ownbib}
}{
    \PackageWarning{ownbib}{setting/own/ownbib.bst not found; must specify manually}
}}
\renewcommand\bibfont{\normalfont\sffamily\fontsize{6}{8}\selectfont} % set font to be sans serif

\renewcommand\@biblabel[1]{ #1.} % Remove brackets from label
\def\tagform@#1{\maketag@@@{\bfseries(\ignorespaces#1\unskip\@@italiccorr)}}
\renewcommand{\eqref}[1]{\textup{{\normalfont Eq.~(\ref{#1}}\normalfont)}}

%%%%%%%%%%%%%%%%%%%%%% References and bookmarks

% Xr:
% To reference another document, in this case the SI
\RequirePackage{xr, xr-hyper}

%% Hyperlinking
\RequirePackage[
  colorlinks=true, 
  allcolors=blue,
  pagebackref=false
]{hyperref}

\RequirePackage{doi}

%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%% Setup
%%%%%%%%%%%%%%%%%%%%%% General page setup

\RequirePackage[
  a4paper,includeheadfoot,%
  % showframe,showcrop,%
  top=45pt,bottom=35pt,%
  left=55pt,right=55pt,%
  marginparsep=5pt,%
  marginparwidth=2cm,%
  headheight=0pt,% No Header
  headsep=10pt,%
  footskip=25pt]{geometry}


%%%%%%%%%%%%%%%%%%%%%% General font setup

%% Set up main title page fonts 
\newcommand{\headerfont}{\fontfamily{lmss}\color{gray}\bfseries\sffamily\fontsize{16pt}{20pt}\selectfont}
\newcommand{\footerfont}{\normalfont\sffamily\fontsize{7pt}{9pt}\selectfont}
\newcommand{\titlefont}{\fontfamily{lmss}\bfseries\fontsize{22pt}{24pt}\selectfont}
\newcommand{\subtitlefont}{\fontfamily{lmss}\bfseries\fontsize{15pt}{20pt}\selectfont}
\newcommand{\contactfont}{\itshape\sffamily\fontsize{7pt}{9pt}\selectfont}
\newcommand{\absfont}{\normalfont\sffamily\bfseries\fontsize{8pt}{11pt}\selectfont}
\newcommand{\keywordsfont}{\normalfont\sffamily\fontsize{8pt}{11pt}\selectfont}
\newcommand{\footnotefont}{\normalfont\sffamily\fontsize{7}{9}\selectfont}

%% Set URL link color & font
\renewcommand\UrlFont{\color{black}\sffamily}

%% Add bolding to math where needed
\g@addto@macro\bfseries{\boldmath}

%%%%%%%%%%%%%%%%%%%%%% Author and affiliation

% Keeps footnotes where they should be
\RequirePackage{titling}
\setlength\thanksmarkwidth{0em}
\setlength\thanksmargin{-\thanksmarkwidth}

% Typesetting for authors/affiliations
\RequirePackage{authblk}
\setlength{\affilsep}{8.5pt} % 16.5pts between base of author line and base of affil line
\renewcommand\Authfont{\color{color0}\normalfont\sffamily\bfseries\fontsize{9}{11}\selectfont}
\renewcommand\Affilfont{\color{color0}\footnotefont}
\renewcommand\AB@affilsepx{\newline\protect\Affilfont}
\renewcommand\Authands{, and }

%%%%%%%%%%%%%%%%%%%%%% Footnotes

\RequirePackage[flushmargin,ragged,symbol*]{footmisc}
\renewcommand*{\footnotelayout}{\footnotefont}
\renewcommand{\footnoterule}{% Set the footnote hrule style
  \kern -3pt
  {\color{black50} \hrule width 72pt height 0.25pt}
  \kern 2.5pt
}

%%%%%%%%%%%%%%%%%%%%%% Graphics, tables etc

%% Graphics, tables and other formatting
\setlength{\columnsep}{13.5pt} % Distance between the two columns of text
\setlength{\parindent}{12pt} % Paragraph indent

%% Set document color scheme
\definecolor{black50}{gray}{0.5} % 50% black for hrules
\definecolor{color0}{RGB}{0,0,0} % Base
\definecolor{color1}{RGB}{59,90,198} % author email, doi

%% Figure caption style
\DeclareCaptionFormat{fmt}{\normalfont\sffamily\fontsize{7}{9}\selectfont#1#2#3}
\captionsetup*{format=fmt}

%% Table style
\RequirePackage{etoolbox}
\captionsetup*[table]{labelfont+={small},textfont+={small,sf,bf},skip=10pt,position=above}
% booktabs provide nice spacing, but rule widths and distances need fixing
\setlength{\heavyrulewidth}{0.5pt}
\setlength{\lightrulewidth}{0.5pt}
\setlength{\aboverulesep}{1.5pt}
\setlength{\belowrulesep}{1.5pt}
\setlength{\belowbottomsep}{10pt}
\AtBeginEnvironment{tabular}{
\sffamily\fontsize{7.5}{10}\selectfont
}
\newcommand{\addtabletext}[1]{{\setlength{\leftskip}{9pt}\fontsize{7}{9}\selectfont#1}}

%% Equation numbering - use square brackets
\renewcommand\tagform@[1]{\maketag@@@ {[\ignorespaces #1\unskip \@@italiccorr ]}}

%% For numbering just one line of an equation
\newcommand\numberthis{\addtocounter{equation}{1}\tag{\theequation}}

%% ORCID logo
\definecolor{orcidlogocol}{HTML}{A6CE39}
\tikzset{
  orcidlogo/.pic={
    \fill[orcidlogocol] svg{M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z};
    \fill[white] svg{M86.3,186.2H70.9V79.1h15.4v48.4V186.2z}
                 svg{M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z}
                 svg{M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z};
  }
x}

%% Article meta data additional fields
\newcommand{\contact}[1]{\def\@contact{#1}}
\newcommand{\equalcontrib}[1]{\def\@equalcontrib{#1}}
\newcommand{\pubdoi}[1]{\def\@pubdoi{#1}}
\newcommand{\leadauthor}[1]{\def\@leadauthor{#1}}
\newcommand{\keywords}[1]{\def\@keywords{#1}}
\newcommand{\matmethods}[1]{\def\@matmethods{#1}}
\newcommand{\acknow}[1]{\def\@acknow{#1}}
\newcommand{\orcid}[1]{
  \href{https://orcid.org/#1}{\mbox{
    \begin{tikzpicture}[overlay,remember picture]
      \coordinate (A);
      \coordinate (B) at ($(A)-(6pt,-8pt)$);
    \end{tikzpicture}
    \begin{tikzpicture}[overlay,remember picture,yscale=-0.04,xscale=0.04,transform shape]
      \pic at (B) {orcidlogo};
    \end{tikzpicture}
    }{}}}
\newcommand{\sep}[0]{; }

%%%%%%%%%%%%%%%%%%%%%% Headers and footers

%% Fancyhdr styling
\RequirePackage{fancyhdr}  % custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
\pagestyle{fancy}          % Set pagestyle to all 

% Clear everything
\fancyhf{}

% Headers
\renewcommand{\headrulewidth}{0pt}% % No header rule
% \fancyhead[]{} %etc

% Footers
\renewcommand{\footrulewidth}{0pt}% % No footer rule
\fancyfoot[R]{
  \footerfont\textit{Preprint}\hspace{7pt}|%
  \hspace{7pt}\textbf{\today}\hspace{7pt}|%
  \hspace{7pt}\textbf{\thepage}}
\fancyfoot[L]{\footerfont\@ifundefined{@leadauthor}{}{\@leadauthor}\ifnum \value{authors} > 1\textit{ et al.}\fi}

% Redefining plain style (for title page)
\fancypagestyle{plain}{%
    \fancyhf{}
    \ifthenelse{\boolean{toprule}}{%
        \renewcommand{\headrulewidth}{3pt}%
    }{}
    \fancyfoot[R]{
      \footerfont\textit{Preprint}\hspace{7pt}|%
      \hspace{7pt}\textbf{\today}\hspace{7pt}|%
      \hspace{7pt}\textbf{\thepage\textendash\pageref{LastPage}}}
    \fancyfoot[L]{\footerfont\@ifundefined{@pubdoi}{}{DOI: \@pubdoi}}
}

%%%%%%%%%%%%%%%%%%%%%% Line numbers

% Use footer routine for line numbers
\if@switchlineno
  \ifthenelse{\boolean{singlecolumn}}{
    \RequirePackage{lineno}
  }{% use lineno in switch mode if doublecolumn
    \RequirePackage[switch]{lineno}
  }
  \renewcommand\linenumberfont{\normalfont\tiny\sffamily}
  \linenumbers
\fi

%%%%%%%%%%%%%%%%%%%%%% Typesetting

%% Section/subsection/paragraph set-up
\RequirePackage[explicit]{titlesec}
\setcounter{secnumdepth}{5}
% \renewcommand{\thesubsection}{\Alph{subsection}}

\titleformat{\section}
  {\large\sffamily\bfseries}
  {\thesection.}
  {0.5em}
  {#1}
  []
\titleformat{name=\section,numberless}
  {\large\sffamily\bfseries}
  {}
  {0em}
  {#1}
  []  
\titleformat{\subsection}[runin]
  {\sffamily\bfseries}
  {\thesubsection.}
  {0.5em}
  {#1. }
  []
\titleformat{\subsubsection}[runin]
  {\sffamily\small\bfseries}
  {\thesubsubsection.}
  {0.5em}
  {#1. }
  []
\titleformat{\paragraph}[runin]
  {\sffamily\small\bfseries}
  {}
  {0em}
  {#1} 
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{2pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{2pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{12pt}

%% Abstract formatting
\def\xabstract{abstract}
\long\def\abstract#1\end#2{\def\two{#2}\ifx\two\xabstract 
\long\gdef\theabstract{\ignorespaces#1}
\def\go{\end{abstract}}\else
\typeout{^^J^^J PLEASE DO NOT USE ANY \string\begin\space \string\end^^J
COMMANDS WITHIN ABSTRACT^^J^^J}#1\end{#2}
\gdef\theabstract{\vskip12pt BADLY FORMED ABSTRACT: PLEASE DO
NOT USE {\tt\string\begin...\string\end} COMMANDS WITHIN
THE ABSTRACT\vskip12pt}\let\go\relax\fi
\go}

% Define an environment with abstract content and styling
\newcommand{\abscontent}{
  \noindent
  {%
    \vskip3pt%
    \if@switchtoc
      \begin{minipage}{0.59\linewidth}
        \absfont \theabstract
      \end{minipage}
      \begin{minipage}[L]{0.4\linewidth}
        \raggedleft
        \IfFileExists{figs/toc.png}{% no good way of checking for extension
        \includegraphics[width=0.9\linewidth]{figs/toc}}
        {\IfFileExists{figs/toc.bmp}{
        \includegraphics[width=0.9\linewidth]{figs/toc}}
        {\IfFileExists{figs/toc.pdf}{
        \includegraphics[width=0.9\linewidth]{figs/toc}}
        }{\includegraphics[width=0.9\linewidth]{example-image}}}
      \end{minipage}
    \else
      \begin{minipage}{\linewidth}
        \absfont \theabstract
      \end{minipage}
    \fi
  }%
  \vskip10pt%
  \noindent
  \@ifundefined{@abstractadd}{}{%
  {%
    \parbox{\linewidth}{%
    \abstractaddfont \@abstractadd}%
  }%
  \vskip10pt%
  }%
  \noindent
  \@ifundefined{@keywords}{}{%
  {%
    \parbox{\linewidth}{%
    \keywordsfont %
    \textbf{Keywords:} \@keywords}%
  }%
  \vskip10pt%
  }%
}

%% Manual adjustment to line up main content with line numbers
\newlength\vert@adjust
\newcommand\verticaladjustment[1]{\setlength{\vert@adjust}{#1}}

%% Command to define an affiliation list in a footnote
\def\authaffil{%
  \if@switchaffil
    \@author\par%
    \vskip2pt
  \else
    \AB@authlist\par
    \protected@xdef\@thanks{\@thanks\protect\footnotetext[\the\c@footnote]{\AB@affillist\newline}}%
  \fi
}

%% Command to define a contact email switch
\def\contactswitch{%
  \contactfont\@ifundefined{@contact}{}{\textbf{\normalfont*}~E-Mail:~\@contact}\par%
  %
  \vskip3pt
}

%% Command to define an "equal contribution" switch
\def\equalcontribswitch{
  \footerfont\@ifundefined{@equalcontrib}{}{\textsuperscript{\textbf{\dag}}~These authors contributed equally}\par%
  %
  \vskip3pt
}


%%%% Custom title page
\renewcommand{\@maketitle}{%
\ifthenelse{\boolean{shortintro}}
{% if short intro i.e. SI
  % patch command to center section
  \patchcmd{\@author}{\raggedright}{\centering}{}{}
  %
  \topskip0pt
  \vspace*{\fill}%
  %
  {\centering\baselineskip=24pt\subtitlefont Supplementary Information for\par}%
  {\centering\baselineskip=24pt\titlefont \@title\par}%
  %
  \vskip10pt
  %
  {\centering\authaffil{}}
  %
  \vskip8pt
  %
  % equal contribution switch
  {\centering\equalcontribswitch{}}
  % contact switch
  {\centering\contactswitch{}}
  %
  \vspace*{\fill}%
}
{% else if complete paper
  %
  \vskip10pt%
  %
  {\raggedright\baselineskip=24pt\titlefont \@title\par}%
  %
  \vskip10pt
  %
  \authaffil{}
  %
  \vskip3pt
  %
  % equal contribution switch
  \equalcontribswitch{}
  % contact switch
  \contactswitch{}
  % Abstract
  {\abscontent{}}
  %
  \noindent\makebox[\linewidth]{\rule{\linewidth}{0.4pt}}%
  %
  \vskip15pt%
}%
\@ifundefined{vert@adjust}{}{\vskip\vert@adjust}%
}%
