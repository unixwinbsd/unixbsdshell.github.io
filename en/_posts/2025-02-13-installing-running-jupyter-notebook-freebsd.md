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

## 1. Install Dependencies Jupyter Notebook
Even though Jupyter Notebook is written in 3 programming languages, in general the Python language is more dominant than the Julia and R languages. So it is very natural that more Jupyter dependencies use the Pyrhon package. It could even be said that almost all installation and configuration work uses the Python language.  

Jupyter Notebook uses Python as its main language because it is used to connect with third party applications such as AWS, Digital Ocean and others. Python is also used to connect Jupyter with web browsers such as Google Chrome.  

On FreeBSD all Jupyter dependencies are available in the PKG or ports repository. You choose one to install the dependencies. In this article we will use PKG to install Jupyter dependencies, because apart from being fast PKG is very easy to use. Here is an example of installing Jupyter dependencies on FreeBSD.

```
root@ns3:~ # pkg install py39-setuptools desktop-file-utils py39-ipykernel py39-referencing py39-jsonschema-specifications py39-graphviz
root@ns3:~ # pkg install py39-jsonschema py39-nbformat py39-nbclient py39-nbconvert py39-maturin py39-pyzmq libzmq4 py39-twisted
```

## 2. Install Jupyter Notebook
After you have finished installing dependencies, the next step is to install Jupyter Notebook. the same as the dependencies above, the Jupyter Notebook repository is also available in the PKG package. Here is how to install Jupyter Notebook with PKG.

```
root@ns3:~ # pkg install py39-notebook
```

py39 means we install Jupyter Notebook with Python39, because on FreeBSD 13.3 the Jupyter application can only be installed with Python39.

We will create a Jupyter configuration file, in this way Generate initial configuration. This configuration file has the extension *.py and is used to manage all Jupyter Notebook functions and features. Run the command below to generate a *.py configuration file.

```
root@ns3:~ # jupyter notebook --generate-config
Writing default config to: /root/.jupyter/jupyter_notebook_config.py
```

If you want to adapt the configuration to your FreeBSD server specifications, open the "jupyter_notebook_config.py" file. Change only a few scripts like the example below.

```
root@ns3:~ # cd /root/.jupyter
root@ns3:~/.jupyter # ee jupyter_notebook_config.py
c.NotebookApp.ip = '192.168.5.2'
c.NotebookApp.notebook_dir = '/tmp'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
```

192.168.5.2 is the FreeBSD server's private IP (match your FreeBSD IP) and port 8888 is the port used to open Jupyter Notebook in a web browser. The next step, run Jupyter Notebook.

```
root@ns3:~/.jupyter # jupyter notebook --allow-root
[I 09:50:39.420 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 09:50:45.584 NotebookApp] Serving notebooks from local directory: /tmp
[I 09:50:45.584 NotebookApp] Jupyter Notebook 6.4.13 is running at:
[I 09:50:45.584 NotebookApp] http://192.168.5.2:8888/?token=e352ecf595618fb5ac6eaaeb849b0a1b60fa50b589f6986b
[I 09:50:45.584 NotebookApp]  or http://127.0.0.1:8888/?token=e352ecf595618fb5ac6eaaeb849b0a1b60fa50b589f6986b
[I 09:50:45.585 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 09:50:45.618 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-2370-open.html
    Or copy and paste one of these URLs:
        http://192.168.5.2:8888/?token=e352ecf595618fb5ac6eaaeb849b0a1b60fa50b589f6986b
     or http://127.0.0.1:8888/?token=e352ecf595618fb5ac6eaaeb849b0a1b60fa50b589f6986b
```

## 3. Test Jupyter Notebook
The final step of this article is etching. If there is no wrong configuration, your monitor screen will display the Login menu. Open Google Chrome, type "http://192.168.5.2:8888/", if successful it will appear as shown in the image below.





