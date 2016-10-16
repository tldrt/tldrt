%% Generic Setup
\ProvidesClass{tldrt}[2016/10/13]
\NeedsTeXFormat{LaTeX2e}
\LoadClass[a4paper]{report}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{hyperref}
\AtBeginDocument{%
  \edef\hashsign{\string#}
  % \StrLeft{\mdfivesum{\@author\@title}}{6}[\hashcode]
  \def\@hashtag{\hashsign\@hashcode}
  \metadata%
}

%% Class Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{%
  family=tldrt,
  prefix=tldrt@,
}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{babel}}
\ProcessOptions*
\RequirePackage{babel}

%% Utility
\RequirePackage{ifthen}
\RequirePackage{xstring}

%% Font Related
\RequirePackage{fontspec}
\defaultfontfeatures{%
    Ligatures = TeX,
    Path % Causes font to be located using KPSEWHICH.
    % Path      = {./fonts/}
}
\RequirePackage{fontawesome}
\RequirePackage{bbding}
\RequirePackage{lettrine}
\tolerance=550
\input{ArtNouv.fd}
\newcommand*\initfamily{\usefont{U}{ArtNouv}{xl}{n}}
\renewcommand{\LettrineFontHook}{\initfamily}

%% Graphics
\RequirePackage{graphicx}
\RequirePackage{eso-pic}
\graphicspath{{./images/}}
\RequirePackage{tikz}
\RequirePackage{atbegshi}
\RequirePackage{ocgx2}
\AtBeginShipout{%
  \AtBeginShipoutAddToBox{%
    \begin{ocg}[printocg=never,showingui=never]{watermark}{watermark}{on}%
    \begin{tikzpicture}[overlay,remember picture]
      \node at (current page.center) {%
        \ifodd \thepage%
          \includegraphics[width=\paperwidth,height=\paperheight]{paper}%
        \else%
          \scalebox{-1}[1]{\includegraphics[width=\paperwidth,height=\paperheight]{paper}}%
        \fi%
      };
    \end{tikzpicture}%
    \end{ocg}%
  }%
}

%% Layout
\RequirePackage{epigraph}
\RequirePackage{fancyhdr}
\AtBeginDocument{%
  \Large%
  \header%
  \stamp%
}
\AtEndDocument{\par\bigskip\center{\vspace{0.5cm}\JackStar}}
\pagestyle{fancy}
\fancyhf{}
\rhead{\includegraphics[width=1cm]{logo}}
\lhead{\textsc{Possibly Immortal}}
\cfoot{\thepage}

%% Formatting
\RequirePackage[calc]{datetime2}
\DTMnewdatestyle{postdate}{%
  \renewcommand{\DTMdisplaydate}[4]{%
    \DTMshortmonthname{##2} ##1}%
  \renewcommand{\DTMDisplaydate}{\DTMdisplaydate}%
}
\DTMsetdatestyle{postdate}

%%%%%%%%%%%%%%%%%%%%
%%%%% Commands %%%%%
%%%%%%%%%%%%%%%%%%%%

%% Metadata
\newcommand{\hashcode}[1]{%
  \def\@hashcode{#1}
}

\newcommand*{\metadata}{%
  \fullexpandarg%
  \hypersetup{
    unicode        =true,
    pdfauthor      ={\@author},
    pdftitle       ={\@title},
    pdfsubject     ={\@title},
    pdfkeywords    ={\@author, \@title, \@hashtag, TLDRT},
    pdfproducer    ={TLDRT},
    pdfcreator     ={TLDRT},
    bookmarksopen  =false,
    bookmarksdepth =2,
    colorlinks     =true
  }
}

%% Generate Stamp
\newcommand{\stamp}{%
  % \immediate\write18{convert -antialias -size 512x320 stamp_bg.png -stroke none -fill '\@hashtag' -draw "rectangle 208,80 304,176" -fill \#503050 -font Shortcut -kerning 40 -pointsize 64 -gravity south -draw "text 0,0 '\@hashtag'" images/stamp.png}
  \AddToShipoutPictureFG*{% Insert stamp.
    \AtTextUpperLeft{%
      \makebox[4.5cm][r]{%
        \makebox[0cm][l]{%
          \raisebox{-2.0cm}{%
            \includegraphics[width=3cm,angle=20,origin=c]{\@hashcode}}}}}}
}

\newcommand{\attribution}[1]{%
  \def\@attribution{#1}
}

\newcommand{\epigram}[3][]{%
  \def\@epigs{#1}
  \def\@epiga{#2}
  \def\@epigq{#3}
}

%% Attribution
\newcommand{\attribute}{%
  %% Content attribution line.
  {\parindent0pt\vspace*{-40pt}%
    \linespread{1.1}\large%
    \scshape{\@author\ ---\ \@date\ \hfill \normalsize\faExternalLink\ \faTwitterSquare\ \faGithubSquare\ \faEnvelope}%
    \par\nobreak}
  \@afterheading%
  %% Chapter head image attribution as footnote without marker.
  \ifdefined\@attribution
  \let\svthefootnote\thefootnote%
  \let\thefootnote\relax\footnote{\@attribution}%
  \addtocounter{footnote}{-1}\let\thefootnote\svthefootnote%
  \else
  \vspace{0.7cm}
  \fi
}

%% Header
\newcommand*{\header}{
  % \shorthandoff{=} % In case babel turkish bugs.
  % \AddToShipoutPictureBG{\includegraphics[width=\paperwidth,height=\paperheight]{paper}} % Fallback paper pattern.
  \AddToShipoutPictureFG*{% Insert image.
    \AtTextUpperLeft{%
      \makebox[0.5cm][r]{%
        \makebox[0cm][l]{%
          \raisebox{-1.5cm}{%
            \includegraphics[width=6cm,origin=c]{ornament}}}}}}
  \chapter*{\@title}
  \attribute%
  \epigraphhead[35]{\epigraph{``\@epigq''}{\textsc{\@epiga\\\@epigs}}}%
}

%% Dropcap
\newcommand{\dropcap}[1]{%
  \StrLeft{#1}{1}[\initc]
  \StrGobbleLeft{#1}{1}[\rests]
  % \shorthandoff{=}%
  \lettrine[lines=3]{\initc}{\rests}%
  % \shorthandon{=}%
}
