---
title: Complete Guide to Using IPYNB Files - Jupyter Notebook Files
date: "2025-09-20 09:11:21 +0100"
updated: "2025-09-20 09:11:21 +0100"
id: complete-guid-using-ipynb-jupyter-notebook
lang: en
author: Iwan Setiawan
robots: index, follow
categories: Linux
tags: WebServer
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-12.jpg
toc: true
comments: true
published: true
excerpt: IPYNB files serve as a complete computational record of a session and include information such as computational input and output, mathematical functions, and rich representations of the resulting objects, such as images and explanatory text
keywords: file, ipynb, jupyter notebook, jupyter, freebsd, linux, ubuntu, debian, guide
---

Jupyter Notebook is a software that has become extremely popular in recent years. Most readers probably use it daily. However, some may be new to it and unfamiliar with it. Or perhaps even just heard of it. Don't worry, this article will introduce you to Jupyter Notebook from scratch to a more advanced level.

IPYNB files serve as a complete computational record of a session and include information such as computational input and output, mathematical functions, and rich representations of the resulting objects, such as images and explanatory text.

IPYNB files are stored internally in JSON file format, an open standard file format for data sharing. For this reason, IPYNB files are human-readable and easy to understand. JSON also makes it easy to share these files with others.

<br/>

<img alt="Complete Gitea" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-12.jpg' | relative_url }}">

<br/>

## 1. What is Jupyter Notebook and Why is it so Popular?

[Jupyter](https://jupyter.org/) is a non-profit organization dedicated to developing interactive software in various programming languages. Notebooks are software developed by Jupyter, an open-source web application that allows you to create and share interactive documents containing live code, equations, visualizations, and rich narrative text.

The explanation above may be unclear. Here's an illustration. In the past, we used to share code and documents separately. We bundled our code into a library/application/project (Visual Studio, Eclipse, etc.), and created documents using a Word editor. In these documents, you could display code snippets, output results, and other visualizations of our programs.

Well, Jupyter Notebook brings all of this together—text/narrative, live code, equations, results displays, static images, and graphical visualizations—in a single interactive file. And, another advantage, the notebook can be rerun by anyone who opens it, allowing for more code execution within it.

An example is this document itself. This document was originally a Jupyter Notebook. You may have read it on the IndoML blog, as this notebook has been converted into a WordPress blog using the nb2wp utility. You can view the original file on GitHub, and it will look the same.

Now, what's special about this document is its ability to bring in code directly. As shown below.


```
import datetime
import matplotlib.pyplot as plt

now = datetime.datetime.now()
print('Hello friends. The time now is {}'.format(now))
```

The code above isn't just a snippet of code from the documentation, but rather live code. If you view this post on the IndoML blog or on GitHub, you'll see a static view of the last execution when this notebook was saved. It's like viewing a document. The view won't change. However, if you run this notebook file in your Jupyter installation, you can run the code above, and a different timeline will appear!

Supported code output isn't limited to simple text like the one above. It can also be a graph like this:


```
import numpy as np

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))
fig.suptitle('Examples of Some Random Graphics')
rng = np.random.RandomState(0)
x = rng.randn(100)
y = rng.randn(100)
colors = rng.rand(100)
sizes = 1000 * rng.rand(100)

ax1.scatter(x, y, c=colors, s=sizes, alpha=0.3, cmap='viridis')
ax1.set_xlabel('Axis X')
ax1.set_ylabel('Axis Y')

x = np.linspace(0, 10, 30)
y = np.sin(x)
ax2.plot(x, y, '-ok')
ax2.set_xlabel('Axis X')
ax2.set_ylabel('Axis Y')

fig.tight_layout(rect=[0, 0.03, 1, 0.97])
plt.show()
```

<br/>

<img alt="ipynb jupyter notebook" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-13.jpg' | relative_url }}">

<br/>

You can also display a pandas table/DataFrame like this, for example:

```
import pandas as pd

df = pd.DataFrame({
        'name':['joni','meri','peter','jhon','bob','lisa'],
        'age':[23,78,22,19,12,33],
        'province':['New York','Arizona','Sanfransisco','Bali','Miami','Washington']
     })
df
```

Many other media types can be displayed directly, such as Markdown, HTML, audio, video, JavaScript, and so on.

With the rich interactivity provided by Jupyter Notebook, you can see its potential uses, especially for research and collaboration. I myself have often encountered Jupyter Notebooks, for example, in online courses (MOOCs) as a platform for students to program on Kaggle, and many researchers share their work in notebook form.


## 2. Is Jupyter Notebook Only for Python?

No. Although Jupyter notebooks are written in Python, the ability to support programming languages ​​in notebooks is implemented modularly in the form of kernels. Currently, there are over 130 kernels supporting nearly 100 programming languages, for example:
`bash, C, C++, C#, Clojure, Common LISP, Erlang, F#, Go, J, Java, Julia, livescript, Lua, Matlab, NodeJS, Perl, PHP, Prolog, Python, Q, R, Ruby, Scala, SQL, Tcl, dan Zsh.`

For a complete list, please see the Jupyter Kernels page.

Hopefully, you're interested in trying Jupyter Notebook. Let's install it.


## 3. Share Notebooks

Now it's time to share your brilliant notebook creations with others! There are many ways to share notebooks.

### a. Static with Export File

You can share your notebook as a PDF, HTML, Latex, Rst, or Markdown file by selecting File -> Download as. This method is suitable if the recipient is less technically savvy, such as your boss.

### b. Static/Dynamic with GitHub/GitLab

If your work is hosted on GitHub or GitLab, you can simply share a link to the notebook file on GitHub/GitLab. For example, you can view this notebook file at this link. Recipients can preview your notebook from there, or download it and run it on their own computers.

I find this to be the most convenient way to share notebooks with your colleagues.

### c. Dynamically with Google Colab

[Google Colab](https://colab.research.google.com) is a free service for collaborating on Jupyter notebooks. Just as Google Docs is used for collaborative document editing, Google Colab is used for collaborative Jupyter notebook editing.

Colab also provides free GPU execution for your notebooks, which is very useful for training your machine learning models.

Colab can open your notebooks from GitHub, but if your notebook requires other files (such as image files or Python files imported by your notebook), there may be additional steps you need to take (I haven't tried this much).

### d. Static with Nbviewer

[Nbviewer](https://nbviewer.jupyter.org/) is a service for statically viewing notebooks. If your notebook is accessible by URL, simply provide that URL to Nbviewer to view it. For example, you can view this notebook in nbviewer at this link.

This method is similar to viewing a notebook with GitHub/GitLab. However, GitHub sometimes has issues displaying notebooks, so this method can be an alternative.

### e. Sharing Notebook Files and Requirements

You can also share the notebook file directly with your colleagues. If you want your colleagues to be able to run the notebook, don't forget to include the files the notebook requires (such as image files or Python files imported by your notebook). However, if your colleagues just want to see the visuals, then simply share the notebook itself.

This method is only effective if your notebook doesn't depend on other files.

There are many more interesting aspects and features of Jupyter notebooks that could be discussed, but this article is already quite long.

Hopefully, this article inspires you to use Jupyter notebooks. If you have questions or need help, please leave a comment.