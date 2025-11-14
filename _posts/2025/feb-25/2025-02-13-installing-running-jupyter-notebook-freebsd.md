---
title: Installing and Running Jupyter Notebook on FreeBSD
date: "2025-02-13 15:16:19 +0100"
updated: "2025-02-13 15:16:19 +0100"
id: installing-running-jupyter-notebook-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/freebsd-jupiter.jpg
toc: true
comments: true
published: true
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

![diagram jupyter notebook](/img/oct-25/freebsd-jupiter.jpg)

## 1. Install Dependencies Jupyter Notebook

Even though Jupyter Notebook is written in 3 programming languages, in general the Python language is more dominant than the Julia and R languages. So it is very natural that more Jupyter dependencies use the Pyrhon package. It could even be said that almost all installation and configuration work uses the Python language.  

Jupyter Notebook uses Python as its main language because it is used to connect with third party applications such as AWS, Digital Ocean and others. Python is also used to connect Jupyter with web browsers such as Google Chrome.  

On FreeBSD all Jupyter dependencies are available in the PKG or ports repository. You choose one to install the dependencies. In this article we will use PKG to install Jupyter dependencies, because apart from being fast PKG is very easy to use. Here is an example of installing Jupyter dependencies on FreeBSD.

```
root@ns3:~ # pkg install py311-setuptools desktop-file-utils py311-ipykernel py311-referencing py311-jsonschema-specifications py311-graphviz
root@ns3:~ # pkg install py311-jsonschema py311-nbformat py311-nbclient py311-nbconvert py311-maturin py311-pyzmq libzmq4 py311-twisted
```

## 2. Install Jupyter Notebook
After you have finished installing dependencies, the next step is to install Jupyter Notebook. the same as the dependencies above, the Jupyter Notebook repository is also available in the PKG package. Here is how to install Jupyter Notebook with PKG.

```
root@ns3:~ # pkg install py311-notebook
```

py39 means we install Jupyter Notebook with Python39, because on FreeBSD 13.3 the Jupyter application can only be installed with Python39.

## 3. Running Jupyter Notebook with root user
By default on FreeBSD, the Jupyter configuration files are located in `"/root"`.

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

## 4. Running Jupyter Notebook with other users
Apart from the root user, you can run Jupyter with other users.

### a. Create a new user
To run Jupyter other than the "root" user, you must create a new user. In this article example we will create a user with the name "steve".

```
root@ns3:~ # pw add user -n steve -m -s /bin/sh -c "Jupyter Notebook"
```

### b. Create Password to Login
After creating a user, continue by creating a password to log in to Jupyter.

```
root@ns3:~ # su - steve -c 'jupyter notebook password'
You can prevent the removal of a ZFS snapshot by using the hold subcommand.
For example, to prevent the snapshot called milestone from deletion, run the
following command:

# zfs hold milestone_hold mypool/projects@my_milestone

The "zfs holds" command will list all current snapshots that are protected
this way (-r for a recursive list):

# zfs holds -r mypool

The TIMESTAMP column in the output of the above command is from when the
hold was created, not the snapshot it holds. The "zfs destroy" command will
echo a "dataset is busy" message on the console when it encounters a hold.
Use "zfs release" to release the hold on the snapshot:

# zfs release milestone_hold mypool/projects@my_milestone

                -- Benedict Reuschling <bcr@FreeBSD.org>
Enter password:
Verify password:
[JupyterPasswordApp] Wrote hashed password to /home/steve/.jupyter/jupyter_server_config.json
```

### c. Create the file "jupyter_notebook_config.py"

```
root@ns3:~ # su - steve -c "jupyter notebook --generate-config"
```

After that, type the script below in the file `"/home/steve/.jupyter/jupyter_notebook_config.py"`.

```
c.NotebookApp.ip = '192.168.5.2'
c.NotebookApp.notebook_dir = '/tmp'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.ServerApp.password = 'argon2:$argon2id$v=19$m=10240,t=10,p=8$IMgu5gvf8+CgulbJQyVLTw$FxXNv9WMqONpPMRi9ia7ACb4ggIeWLfrKiky+dFBECo'
```

To get the password "argon2:$argon2id$v=19$m=10240,t=10,p=8$IMgu5gvf8+CgulbJQyVLTw$FxXNv9WMqONpPMRi9ia7ACb4ggIeWLfrKiky+dFBECo",
you can open the file `"/home/steve/.jupyter/jupyter_server_config.json"`.

### d. Running Jupyter with User `"steve"`

The final step is to run Jupyter with the user "steve".

```
root@ns3:~ # su - steve -c 'jupyter notebook'
You can permanently set environment variables for your shell by putting them
in a startup file for the shell.  The name of the startup file varies
depending on the shell - csh and tcsh uses .login, bash, sh, ksh and zsh use
.profile.  When using bash, sh, ksh or zsh, don't forget to export the
variable.
[I 2025-04-13 06:45:04.145 ServerApp] Extension package jupyter_lsp took 0.2221s to import
[I 2025-04-13 06:45:04.329 ServerApp] Extension package jupyter_server_terminals took 0.1837s to import
[I 2025-04-13 06:45:08.662 ServerApp] jupyter_lsp | extension was successfully linked.
[I 2025-04-13 06:45:08.669 ServerApp] jupyter_server_terminals | extension was successfully linked.
[I 2025-04-13 06:45:08.676 ServerApp] jupyterlab | extension was successfully linked.
[W 2025-04-13 06:45:08.679 JupyterNotebookApp] 'ip' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[W 2025-04-13 06:45:08.680 JupyterNotebookApp] 'notebook_dir' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[W 2025-04-13 06:45:08.680 JupyterNotebookApp] 'notebook_dir' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[W 2025-04-13 06:45:08.680 JupyterNotebookApp] 'port' has moved from NotebookApp to ServerApp. This config will be passed to ServerApp. Be sure to update your config before our next release.
[W 2025-04-13 06:45:08.684 ServerApp] ServerApp.password config is deprecated in 2.0. Use PasswordIdentityProvider.hashed_password.
[W 2025-04-13 06:45:08.684 ServerApp] notebook_dir is deprecated, use root_dir
[I 2025-04-13 06:45:08.685 ServerApp] notebook | extension was successfully linked.
[I 2025-04-13 06:45:08.686 ServerApp] Writing Jupyter server cookie secret to /home/steve/.local/share/jupyter/runtime/jupyter_cookie_secret
[I 2025-04-13 06:45:12.428 ServerApp] notebook_shim | extension was successfully linked.
[I 2025-04-13 06:45:12.776 ServerApp] notebook_shim | extension was successfully loaded.
[I 2025-04-13 06:45:12.780 ServerApp] jupyter_lsp | extension was successfully loaded.
[I 2025-04-13 06:45:12.781 ServerApp] jupyter_server_terminals | extension was successfully loaded.
[I 2025-04-13 06:45:12.807 LabApp] JupyterLab extension loaded from /usr/local/lib/python3.11/site-packages/jupyterlab
[I 2025-04-13 06:45:12.807 LabApp] JupyterLab application directory is /usr/local/share/jupyter/lab
[I 2025-04-13 06:45:12.808 LabApp] Extension Manager is 'pypi'.
[I 2025-04-13 06:45:16.420 ServerApp] jupyterlab | extension was successfully loaded.
[I 2025-04-13 06:45:16.426 ServerApp] notebook | extension was successfully loaded.
[I 2025-04-13 06:45:16.427 ServerApp] Serving notebooks from local directory: /tmp
[I 2025-04-13 06:45:16.427 ServerApp] Jupyter Server 2.15.0 is running at:
[I 2025-04-13 06:45:16.427 ServerApp] http://192.168.5.2:8888/tree
[I 2025-04-13 06:45:16.427 ServerApp]     http://127.0.0.1:8888/tree
[I 2025-04-13 06:45:16.427 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```

## 5. Test Jupyter Notebook

The final step of this article is etching. If there is no wrong configuration, your monitor screen will display the Login menu. Open Google Chrome, type "http://192.168.5.2:8888/", if successful it will appear as shown in the image below.

![token authentication jupyter notebook](/img/oct-25/test-jupiter.jpg)

In the image above there is a Password or token menu. To fill in the Password column, you can take it from the blue script above, when you run the command **"jupyter notebook --allow-root"**. The result of the command you get the token "e352ecf595618fb5ac6eaaeb849b0a1b60fa50b589f6986b".

If the Token you type matches the command above, it will appear as in the image below.

![folder list jupyter notebook](/img/oct-25/login-jupiter.jpg)

If it appears like the image above, you have successfully installed Jupyter Notebook on FreeBSD. Use Jupyter Notebook to increase productivity and gain deeper insights from data. Due to its interactive nature, language agnosticism, strong visualization capabilities, support for documentation, and increased reproducibility, Jupyter Notebook is currently the top choice for data developers.
