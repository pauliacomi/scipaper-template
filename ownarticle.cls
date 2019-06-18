%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ownarticle.cls, v1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ownarticle}[15/01/2019, v1]
\AtEndOfClass{\RequirePackage{microtype}}

% Option for line numbers
\newif\if@switchlineno
\DeclareOption{lineno}{\@switchlinenotrue}

% Option for SI
\newif\if@switchSI
\DeclareOption{SI}{\@switchSItrue}

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

%% Article meta data additional fields
\newcommand{\contact}[1]{\def\@contact{#1}}
\newcommand{\equalcontrib}[1]{\def\@equalcontrib{#1}}
\newcommand{\doi}[1]{\def\@doi{#1}}
\newcommand{\leadauthor}[1]{\def\@leadauthor{#1}}
\newcommand{\keywords}[1]{\def\@keywords{#1}}
\newcommand{\matmethods}[1]{\def\@matmethods{#1}}
\newcommand{\acknow}[1]{\def\@acknow{#1}}
\newcommand{\sep}[0]{; }

%%%%%%%%%%%%%%%%%%%%%% Fonts and language

\RequirePackage[utf8]{inputenc}
\RequirePackage[english]{babel}
% AMS maths packages
\RequirePackage{
    amsmath,
    amsfonts,
    amsthm,
    amssymb
}
\RequirePackage{lmodern}
\RequirePackage[scaled]{helvet}
\RequirePackage[TS1,T1]{fontenc}

%% Other packages
\RequirePackage{enumitem} % For reducing bullet list item separation

%%%%%%%%%%%%%%%%%%%%%% Graphics packages, tables and listings

\RequirePackage{graphicx}
\RequirePackage{colortbl}
\RequirePackage{changepage}
\RequirePackage{afterpage}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\RequirePackage[framemethod=tikz]{mdframed}

% Floats
\RequirePackage{float}
% For the floatbarrier macro
\RequirePackage[section]{placeins}
% Fixes for twocolumn floats
\RequirePackage{dblfloatfix}

% Better tables 
\RequirePackage{
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
\IfFileExists{refs/ownbib.bst}{
  \bibliographystyle{refs/ownbib}
}{
    \PackageWarning{ownbib}{refs/ownbib.bst not found; must specify manually}
}
\renewcommand\bibfont{\normalfont\sffamily\fontsize{6}{8}\selectfont} % set font to be sans serif

\renewcommand\@biblabel[1]{ #1.} % Remove brackets from label
\def\tagform@#1{\maketag@@@{\bfseries(\ignorespaces#1\unskip\@@italiccorr)}}
\renewcommand{\eqref}[1]{\textup{{\normalfont Eq.~(\ref{#1}}\normalfont)}}

%%%%%%%%%%%%%%%%%%%%%% References and bookmarks

% Xr:
% To reference another document, in this case the SI
\RequirePackage{xr, xr-hyper}

%% Hyperlinking
\RequirePackage[colorlinks=true, allcolors=blue]{hyperref}

%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%% Setup
%%%%%%%%%%%%%%%%%%%%%% General page setup

\RequirePackage[twoside,%
                letterpaper,includeheadfoot,%
                layoutsize={8.125in,10.875in},%
                layouthoffset=0.1875in,%
                layoutvoffset=0.0625in,%
                left=38.5pt,%
                right=43pt,%
                top=43pt,% 10pt provided by headsep
                bottom=32pt,%
                headheight=0pt,% No Header
                headsep=10pt,%
                footskip=25pt]{geometry}


%%%%%%%%%%%%%%%%%%%%%% General font setup

%% Set up main title page fonts 
\newcommand{\headerfont}{\normalfont\sffamily\fontsize{7}{9} \selectfont}
\newcommand{\footerfont}{\normalfont\sffamily\fontsize{7}{9} \selectfont}
\newcommand{\titlefont}{\fontfamily{lmss}\bfseries\fontsize{22pt}{24pt}\selectfont}
\newcommand{\subtitlefont}{\fontfamily{lmss}\bfseries\fontsize{15pt}{20pt}\selectfont}
\newcommand{\contactfont}{\itshape\sffamily\fontsize{7}{8}\selectfont}
\newcommand{\absfont}{\normalfont\sffamily\bfseries\fontsize{8}{11}\selectfont}
\newcommand{\keywordsfont}{\normalfont\rmfamily\fontsize{7}{10}\selectfont}

%% Set URL link color & font
\renewcommand\UrlFont{\color{black}\sffamily}

%% Add bolding to math where needed
\g@addto@macro\bfseries{\boldmath}

%%%%%%%%%%%%%%%%%%%%%% Author and affiliation

\RequirePackage{authblk}
\setlength{\affilsep}{8.5pt} % 16.5pts between base of author line and base of affil line
\renewcommand\Authfont{\color{color0}\normalfont\sffamily\bfseries\fontsize{9}{11}\selectfont}
\renewcommand\Affilfont{\color{color0}\normalfont\sffamily\fontsize{6}{8}\selectfont}
\renewcommand\AB@affilsepx{\newline\protect\Affilfont}
\renewcommand\Authands{, and }

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

%%%%%%%%%%%%%%%%%%%%%% Headers and footers

%% Fancyhdr styling
\RequirePackage{fancyhdr}  % custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
\pagestyle{fancy}          % Enables the custom headers/footers

\fancypagestyle{plain}{%
    \ifthenelse{\boolean{toprule}}{%
        \renewcommand{\headrulewidth}{3pt}%
    }{}
    \fancyfoot[R]{\footerfont \textit{Preprint} \hspace{7pt}|\hspace{7pt}\textbf{\today}\hspace{7pt}|\hspace{7pt}\textbf{\thepage\textendash\pageref{LastPage}}}
   \fancyfoot[L]{\footerfont\@ifundefined{@doi}{}{DOI: \@doi}}
}

% Headers
\fancyhead[LE,RO]{}
\fancyhead[LO,RE]{}

% Footers
\lfoot{}%
\cfoot{}%
\rfoot{}%
\fancyfoot[R]{\footerfont \textit{Preprint}\hspace{7pt}|\hspace{7pt}\textbf{\today}\hspace{7pt}|\hspace{7pt}\textbf{\thepage}}
\fancyfoot[L]{\footerfont\@ifundefined{@leadauthor}{}{\@leadauthor}\ifnum \value{authors} > 1\textit{ et al.}\fi}

\renewcommand{\headrulewidth}{0pt}% % No header rule
\renewcommand{\footrulewidth}{0pt}% % No footer rule

%%%%%%%%%%%%%%%%%%%%%% Line numbers

% Use footer routine for line numbers
\if@switchlineno
  \ifthenelse{\boolean{singlecolumn}}{
    % use lineno package if singlecolumn
    \RequirePackage{lineno}
    \linenumbers
  }{% use lineno in switch mode if doublecolumn
  \RequirePackage[switch]{lineno}
  \linenumbers
  }
\fi
\renewcommand\linenumberfont{\normalfont\tiny\sffamily}

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
\parbox{\dimexpr\linewidth}{%
    \vskip3pt%
	\absfont \theabstract
}%
}%
\vskip10pt%
\noindent
\@ifundefined{@abstractadd}{}{%
{%
\parbox{\dimexpr\linewidth}{%
 \abstractaddfont \@abstractadd}%
}%
\vskip10pt%
}%
\noindent
\@ifundefined{@keywords}{}{%
{%
\parbox{\dimexpr\linewidth}{%
 \keywordsfont %
 \textbf{Keywords:} \@keywords}%
}%
\vskip10pt%
}%
}

%% Manual adjustment to line up main content with line numbers
\newlength\vert@adjust
\newcommand\verticaladjustment[1]{\setlength{\vert@adjust}{#1}}

% %% Custom title page 
\renewcommand{\@maketitle}{%
\ifthenelse{\boolean{shortintro}}
{%
% patch command
\patchcmd{\@author}{\raggedright}{\centering}{}{}
%
\topskip0pt
\vspace*{\fill}%
{\centering\baselineskip= 24pt\subtitlefont Supplementary Information for\par}%
{\centering\baselineskip= 24pt\titlefont \@title\par}%
\vskip10pt% 21pts between base of title and base of author line
{\raggedright \@author \par}
\vskip8pt% 16pts between base of affiliations and base of contact line 
{\centering \headerfont \@ifundefined{@equalcontrib}{}{%
\dag~these authors contributed equally \@equalcontrib}\par}
{\centering \contactfont \@ifundefined{@contact}{}{* \@contact}\par}
\vspace*{\fill}%
}
{% else
%
\vskip10pt%
{\raggedright\baselineskip= 24pt\titlefont \@title\par}%
\vskip10pt% 21pts between base of title and base of author line
{\raggedright \@author\par}
\vskip8pt% 16pts between base of affiliations and base of contact line 
{\raggedright \headerfont \@ifundefined{@equalcontrib}{}{%
\dag~these authors contributed equally \@equalcontrib}\par}
{\raggedright \contactfont \@ifundefined{@contact}{}{* \@contact}\par}
\vskip12pt
{%
\abscontent
}%
\noindent\makebox[\linewidth]{\rule{\linewidth}{0.4pt}}%
\vskip15pt%
}%
\@ifundefined{vert@adjust}{}{\vskip\vert@adjust}%
}%

%% Footnotes set up
\RequirePackage[flushmargin,ragged,symbol*]{footmisc}
\renewcommand*{\footnotelayout}{\normalfont\sffamily\fontsize{6}{8}\selectfont} % set the footnote font
\renewcommand{\footnoterule}{% Set the footnote hrule style
  \kern -3pt
  {\color{black50} \hrule width 72pt height 0.25pt}
  \kern 2.5pt
}
