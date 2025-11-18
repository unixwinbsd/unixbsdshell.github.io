---
title: How to Use Pandoc File Converter on FreeBSD
date: "2025-11-17 21:39:21 +0000"
updated: "2025-11-17 21:39:21 +0000"
id: install-bittorrent-utorrent-for-high-speed-anonymous-file-download
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTPpAJ1SrvxAeVWkTUUJIQp7u9qbsXWuIeBw&s
toc: true
comments: true
published: true
excerpt: On FreeBSD, you can install Pandoc with the FreeBSD Package pkg or the FreeBSD ports repository. In this article, we'll try installing Pandoc via pkg. Besides being easy, pkg also offers a faster installation without compromising the application's required repositories.
keywords: freebsd, openbsd, netbsd, bsd, unix, pandoc, file, converter, shell, command
---

Pandoc is a command line tool for converting files from one markup language to another. Markup languages ​​use tags to annotate parts of a document. Commonly used markup languages ​​include Markdown, ReStructuredText, HTML, LaTex, ePub, and Microsoft Word DOCX.

Pandoc is an open source command line utility that functions as a format converter, converting files between markup languages. This tool was created in 2006 by John MacFarlane and written in Haskell. This tool is compatible with Windows, CentOS, and most Unix-like systems. A markup language is an annotation system used to format text in a visually distinct way. In short, markup language is very important to beautify the Internet.

Markup languages ​​use tags to annotate parts of a document. Commonly used markup languages ​​include Markdown, ReStructuredText, HTML, LaTex, ePub, and Microsoft Word DOCX. In plain English, Pandoc lets you convert multiple files from one markup language to another. Common examples include converting Markdown files to presentations, LaTeX, PDF, or even ePub.

Here are some examples of markup languages:

- HTML
- XML
- Markdown (considered lightweight markup)

## A. How to Install Pandoc

Pandoc is a utility or application used when handling multiple files with different formats. Pandoc's purpose is to convert the markup of any document without changing its source content. This article will provide an overview of how to install Pandoc on FreeBSD 13.2 Stable.

On FreeBSD, you can install Pandoc with the FreeBSD package (pkg) or the FreeBSD ports repository. In this article, we will install Pandoc via pkg. Besides being easy, pkg also offers a fast installation without compromising the repository requirements of the application.

To run Pandoc on a FreeBSD system, you must install several applications that Pandoc requires to run on a FreeBSD system. You can use the following script to install Pandoc on FreeBSD.

```yml
root@router2:~ # pkg update
root@router2:~ # pkg upgrade -y
```
<br/>

```yml
root@router2:~ # pkg install ghc
root@router2:~ # pkg install hs-cabal-install
```

Other Pandoc dependencies you'll need to install are `tex-xetex and texlive-full`. These dependencies are used by Pandoc to run `Latex and the xelatex pdf-engine`.

```yml
root@router2:~ # pkg install texlive-full
root@router2:~ # pkg install print/tex-xetex
```

Once the supporting applications are installed, proceed with installing Pandoc. To install Pandoc, follow the steps below.

```yml
root@router2:~ # pkg install hs-pandoc
```

Once Pandoc is installed on your FreeBSD system, it's ready to be used to convert files.

## B. How to Use Pandoc File Converter

Below, we'll provide some examples of how to use Pandoc as a file converter. Create a biblio.bib file in the `/root` folder. We'll convert this file to an HTML file and name it `example24a.html`. The script below is an example of a `biblio.bib` file.

```console
@Book{item1,
author="John Doe",
title="First Book",
year="2005",
address="Cambridge",
publisher="Cambridge University Press"
}

@Article{item2,
author="John Doe",
title="Article",
year="2006",
journal="Journal of Generic Studies",
volume="6",
pages="33-34"
}

@InCollection{item3,
author="John Doe and Jenny Roe",
title="Why Water Is Wet",
booktitle="Third Book",
editor="Sam Smith",
publisher="Oxford University Press",
address="Oxford",
year="2007"
}
```

To convert files with bib extension to html format, use the following script.

```yml
root@router2:~ # pandoc biblio.bib --citeproc -s -o biblio.html
```

Below you will be given some examples of Pandoc scripts to convert several types of file formats, you can practice these scripts directly.

```yml
root@router2:~ # pandoc MANUAL.txt -o example1.html
root@router2:~ # pandoc -s MANUAL.txt -o example2.html
root@router2:~ # pandoc -s --toc -c pandoc.css -A footer.html MANUAL.txt -o example3.html
root@router2:~ # pandoc -s MANUAL.txt -o example4.tex
root@router2:~ # pandoc -s example4.tex -o example5.text
root@router2:~ # pandoc -s -t rst --toc MANUAL.txt -o example6.text
root@router2:~ # pandoc -s MANUAL.txt -o example7.rtf
root@router2:~ # pandoc -t beamer SLIDES -o example8.pdf
root@router2:~ # pandoc -s -t docbook MANUAL.txt -o example9.db
root@router2:~ # pandoc -s -t man pandoc.1.md -o example10.1
root@router2:~ # pandoc -s -t context MANUAL.txt -o example11.tex
root@router2:~ # pandoc -s -r html http://www.gnu.org/software/make/ -o example12.text
root@router2:~ # pandoc MANUAL.txt --pdf-engine=xelatex -o example13.pdf
root@router2:~ # pandoc example15.md -o example15.ipynb
root@router2:~ # pandoc math.text -s -o mathDefault.html
root@router2:~ # pandoc math.text -s -o mathDefault.html
```

To make it easier for you to learn Pandoc, we've prepared several files stored in the `/usr/local/www/data` directory. Use the ls command to view the entire file's contents.

```console
root@router2:/usr/local/www/data # ls
MANUAL.txt      README.md       Result          index.html      run.txt         sample.odt      sample1.epub    samplepaper.tex
```

### a. convert html file to docx

```yml
root@router2:/usr/local/www/data # pandoc -s -f html -t docx -o /usr/local/www/data/Result/unixBSDfile.docx http://www.baidu.com
```

### b. Convert html files to markdown

```console
root@router2:/usr/local/www/data # pandoc -f html -t markdown -o /usr/local/www/data/Result/unixBSDfile1.md https://www.unixwinbsd.site/2024/01/google-indexing-api-with-go-lang-for.html
root@router2:/usr/local/www/data # pandoc -f html -t markdown -o /usr/local/www/data/Result/unixBSDfile2.md index.html
```

### c. Convert markdown files to mediawiki

```yml
root@router2:/usr/local/www/data # pandoc -f markdown -t mediawiki -o /usr/local/www/data/Result/unixBSDfile.wiki README.md
```

### d. Convert txt/tex files to json

```yml
root@router2:/usr/local/www/data # pandoc run.txt -f latex+raw_tex -o /usr/local/www/data/Result/unixBSDfileTXT.json
root@router2:/usr/local/www/data # pandoc samplepaper.tex -f latex+raw_tex -o /usr/local/www/data/Result/unixBSDfileTEX.json
```

### e. Convert epub files to pdf

```yml
root@router2:/usr/local/www/data # pandoc -f epub sample1.epub -t latex -s -o /usr/local/www/data/Result/unixBSDfile.pdf --pdf-engine=xelatex
```

### f. Convert txt file to db

```yml
root@router2:/usr/local/www/data # pandoc -s -t docbook MANUAL.txt -o /usr/local/www/data/Result/unixBSDfile.db
```

### g. Convert odt to markdown md

```yml
root@router2:/usr/local/www/data # pandoc -o /usr/local/www/data/Result/unixBSDfile.odt -t markdown README.md
```

Let's take a look at the directory contents of the conversion results above.

```console
root@ns7:/usr/local/www/data # cd Result
root@ns7:/usr/local/www/data/Result # ls
unixBSDfile.db          unixBSDfile.pdf         unixBSDfile1.md         unixBSDfileTEX.json
unixBSDfile.docx        unixBSDfile.wiki        unixBSDfile2.md         unixBSDfileTXT.json
```

Often defined as a universal document converter, Pandoc is an open-source software program for file conversion. If you need to convert files from any imaginable format to another, Pandoc is the answer. Pandoc is best used to convert file types like Markdown, Microsoft Word (.docx), and XML into more user-friendly documents and markup languages, including PDF and HTML.

For more information on how to use Pandoc, you can visit the official website: https://pandoc.org/demos.html.
