---
title: Installing and Running Jupyter Notebook on FreeBSD
date: "2025-02-13 15:16:19 +0100"
id: installing-running-jupyter-notebook-freebsd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: Jupyter is an abbreviation of three programming languages, namely Julia (Ju), Python (Py), and R.
keywords: jupyter, notebook, python, google, freebsd, openbsd, unix, running, install
---


To become a reliable data scientist, Jupyter is an important application to master. Data scientists are tasked with exploring data and turning problems into advantages. Then tools like Jupyter can help. So, what is Jupyter and why is it so important?.

Jupyter is an abbreviation of the three programming languages Julia (Ju), Python (Py), and R. These three programming languages are something important for a data scientist. Jupyter is a free web application used to create and share documents that have code, calculation results, visualizations, and text.

Jupyter functions to help you create computational narratives that explain the meaning of the data in it and provide insight into the data. Apart from that, Jupyter also makes collaboration between engineers and data scientists easier because of its ease in writing and sharing text and code.

For this reason, Jupyter makes it easier for data scientists to collaborate with other data scientists, data researchers or data engineers. Basically, Jupyter has three main structures in it. Each structure has its own function, including:
- Front-end notebook.
- Jupyter server.
- Protokol kernel.

According to Nature, Jupyter is the gold standard for organizing data because of its speed. Jupyter can also help you connect topics, theories, data, and the results you have. Using Jupyter, you can:
- Record the research you do in document form and share it quickly.
- Explore the data.

Data exploration using Jupyter provides a computational narrative, a document to which can be added the analysis, hypotheses, and decisions made by a data scientist. Well, you can learn more about Jupyter in Glints ExpertClass. Come on, click here to add and hone your skills to become a reliable data scientist.

**1. Install Dependencies Jupyter Notebook**

Even though Jupyter Notebook is written in 3 programming languages, in general the Python language is more dominant than the Julia and R languages. So it is very natural that more Jupyter dependencies use the Pyrhon package. It could even be said that almost all installation and configuration work uses the Python language.  

Jupyter Notebook uses Python as its main language because it is used to connect with third party applications such as AWS, Digital Ocean and others. Python is also used to connect Jupyter with web browsers such as Google Chrome.  

On FreeBSD all Jupyter dependencies are available in the PKG or ports repository. You choose one to install the dependencies. In this article we will use PKG to install Jupyter dependencies, because apart from being fast PKG is very easy to use. Here is an example of installing Jupyter dependencies on FreeBSD.

