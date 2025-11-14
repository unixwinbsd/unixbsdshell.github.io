---
title: Use Python Poetry on FreeBSD to Quickly Index Blogger URLs
date: "2025-09-19 07:45:51 +0100"
updated: "2025-09-19 07:45:51 +0100"
id: python-poetry-on-freebsd-index-url
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-10.jpg
toc: true
comments: true
published: true
excerpt: Python Poetry provides a solution to this challenge. Poetry is a package manager for Python that allows developers to manage dependencies, create virtual environments, and deploy them using just one command-line tool.
keywords: venv, env, python, poetry, freebsd, installation, configuration, unix, openbsd
---

Python is a versatile language used for a wide variety of applications. However, managing dependencies and finding the right Python packages for a specific task is complex. With the rapid growth of the Python ecosystem, developers are required to be able to manage all Python packages and dependencies appropriately, ensuring they are compatible with their projects and are compatible with each other.

Python Poetry provides a solution to this challenge. Poetry is a package manager for Python that allows developers to manage dependencies, create virtual environments, and deploy them using just one command-line tool.

In this tutorial, you will learn the basics of using Poetry to index Blogger URLs for quick submission to Google Search Console. In this article, we used a FreeBSD server to practice using Poetry as a Blogger indexer.


## 1. What is Python Poetry?

Python Poetry is a tool for dependency management and packaging in Python. The Python Poetry module allows you to declare the libraries your project relies on, and the module will manage (install/update) those libraries for you.

This module helps simplify and organize your projects by addressing the complexity of dependencies within your project and managing installations and updates for you. To handle messy projects, Poetry comes with a single file, `pyproject.toml`, to manage all dependencies. In other words, Poetry uses pyproject.toml to replace `setup.py`.

As a Python project management tool, py-poetry provides the following features:

- Automatic management of virtual environments.
- Fast creation and publishing.
- Dependency management tools with reproducible installation and conflict resolver.
- Simplify projects by addressing dependency complexity.
- Commands for managing, setting up, running, and deploying projects.
- Poetry will help us organize and tidy up our projects.


In addition, Python Poetry also has several benefits:

- Admins have full control over dependencies because dependency files are locked.
- Ensure dependency versions are compatible with the project.
- Easy to use, install, and set up new virtual environments.
- Very simple file structure.
- Easy to add new dependencies to the project.
- Easy to access and understand project metadata from pyproject.toml.

## 2. Python Poetry Installation Process

Poetry is designed to be compatible with a wide range of platforms, including FreeBSD, DragonFly, macOS, Linux, and Windows. Since FreeBSD 13.2, py-poetry only runs with `python310`. Follow the steps below to install `py-poetry`.

```yml
root@ns6:~ # pkg install lang/python310
```

Since py-poetry runs on Python 310, the first thing we need to do is install Python. Once Python 310 is successfully installed, we can proceed to install py-poetry and its supporting libraries.

To install py-poetry with PuTTY, open the Windows Command Line and run the following command:

```yml
root@ns6:~ # pkg install py39-poetry-core py39-poetry-dynamic-versioning py39-poetry-semver py39-poetry-types py39-poetry2setup
```

Once all the above dependencies are installed, we'll proceed to install py-poetry. We recommend using the ports system to ensure all libraries are installed correctly.

Enter the following command in the PuTTY `command-line` shell.

```yml
root@ns6:~ # cd /usr/ports/devel/py-poetry
root@ns6:/usr/ports/devel/py-poetry # make install clean
```

To make FreeBSD detect `Python310` immediately, we create a symlink file, here's how.

```yml
root@ns6:/usr/ports/devel/py-poetry # rm -R -f /usr/local/bin/python
root@ns6:/usr/ports/devel/py-poetry # ln -s /usr/local/bin/python3.10 /usr/local/bin/python
root@ns6:/usr/ports/devel/py-poetry # reboot
```


## 3. Create a py-poetry Virtual Environment

On FreeBSD, py-poetry is strongly recommended to be run in a Python Virtual Environment. Before continuing with this article, you should read the previous articles on PIP and VENV.


[Enabling the Python WSGI Module for Apache on a FreeBSD Server](https://unixwinbsd.site/freebsd/python-script-apache-mod-wsgi-freebsd14)


In this article, we won't explain Python VENV and PIP; you can simply read the article above. We'll jump straight to the main topic: Blogger's URL index.

In general, to create a py-poetry Virtual Environment, you can follow these steps.


```yml
root@ns6:~ # mkdir -p /root/.cache
root@ns6:~ # cd /root/.cache
root@ns6:~/.cache # python -m venv pypoetry
root@ns6:~/.cache # cd pypoetry
root@ns6:~/.cache/pypoetry # source bin/activate.csh
```

You are now active in the py-poetry Virtual Environment.


## 4. py-poetry Search Engine Indexing Tool

In this article, we'll look at how to use Python's py-poetry to create a script to send bulk index requests for your site's URLs to search engines and also prompt them to crawl your pages faster.

Okay, let's assume you've installed Python VENV and PIP on your FreeBSD server. The first thing we need to do is enter the Python Virtual Environment. Type the following command into the py-poetry Virtual Environment.

```yml
(pypoetry) root@ns6:~/.cache/pypoetry # curl -sSL https://install.python-poetry.org | python3 -
(pypoetry) root@ns6:~/.cache/pypoetry # poetry self update
(pypoetry) root@ns6:~/.cache/pypoetry # poetry new index
(pypoetry) root@ns6:~/.cache/pypoetry # poetry init
(pypoetry) root@ns6:~/.cache/pypoetry # poetry add requests
(pypoetry) root@ns6:~/.cache/pypoetry # poetry install --no-root
```

### a. Google Indexing API

The Google Indexing API is a Google search engine tool that allows site owners to send notifications directly to search engines about the addition or removal of pages from Google's search engine. The Google Indexing API allows you to submit up to 200 pages per day for subsequent scanning and indexing (up to a maximum of 100 pages per iteration).

To use the Google Indexing API, you need to have a JSON file that can be created in Google Cloud Platform. Read the previous article on how to create a JSON file.

Cara Instal NPM NodeJS di FreeBSD

Before continuing, you should read the two articles above and practice them on your FreeBSD server.

Copy the Jason file to the `"/root/.cache/pypoetry/index"` folder. We'll use WINSCP to copy the file. See the image below. In the image below, the JSON file is named `"blog-project-43540-d31ba843867c.json"`.

<br/>
<img alt="freeBSD Python Poetry" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-10.jpg' | relative_url }}">
<br/>

After that, we create a file called `"/root/.cache/pypoetry/index/api.py"`. Inside the `"api.py"` file, we include the script below.

```console
(pypoetry) root@ns6:~/.cache/pypoetry/index # ee api.py

import csv
import json
import time

import httplib2
from loguru import logger
from oauth2client.service_account import ServiceAccountCredentials


class GoogleIndexationAPI:
    def __init__(self, key_files: list[str], urls_file_path: str):
        self.key_files = key_files
        self._key_file_index = 0
        self.urls_list = urls_file_path
        self._urls_processed = 0

    @property
    def key_file(self):
        return self.key_files[self._key_file_index]

    @property
    def urls_processed(self):
        return self._urls_processed

    @urls_processed.setter
    def urls_processed(self, value):
        self._urls_processed = value

    def update_key_file_index(self):
        self._key_file_index += 1
        logger.warning('Key file updated')
        if self._key_file_index > len(self.key_files) - 1:
            logger.error("Key files are ended. Start the script tomorrow.")
            raise StopIteration()
        logger.error("Sleeping for 5 seconds.")
        time.sleep(5)

    def get_urls(self):
        try:
            with open(self.urls_list, 'r', encoding='utf-8') as f:
                urls = [line.strip() for line in f]
            return urls
        except Exception as e:
            logger.error(f'Error while reading urls from file ::: {e}')
            exit()

    def send_request(self, url):
        """
        Makes a request to Google Indexing API
        :return: Content: Response from API
        """
        api_scopes = ["https://www.googleapis.com/auth/indexing"]
        api_endpoint = "https://indexing.googleapis.com/v3/urlNotifications:publish"
        credentials = ServiceAccountCredentials.from_json_keyfile_name(self.key_file, scopes=api_scopes)
        method = 'URL_UPDATED'
        try:
            http = credentials.authorize(httplib2.Http())
            r_content = json.dumps({"url": url, "type": method}).encode('utf-8')
            response, content = http.request(api_endpoint, method="POST", body=r_content)
            log = [url, method, response.status, content.decode('utf-8')]
            return log
        except Exception as e:
            logger.error(f'{e}, {type(e)}')
            return None

    def parse_response(self, content):
        """Parses error response"""
        try:
            json_line = json.loads(content)
            result = [json_line['error']['message'], json_line['error']['status'], self.key_file]
        except Exception as e:
            result = ['API response parse error', e]
        return result

    def indexation_worker(self):
        logger.info('Processing... Please wait')

        urls = self.get_urls()

        with open('report_log.csv', 'w', encoding='utf-8', newline='') as f:
            my_csv = csv.writer(f, delimiter='\t')
            header = ['URL', 'METHOD', 'STATUS_CODE', 'ERROR_MESSAGE', 'ERROR_STATUS', 'KEY FILE']
            my_csv.writerow(header)

            for url in urls:
                logger.debug(f'Sending {url}')
                result = self.send_request(url)
                if not result:
                    logger.info('Empty response, skipping the url')
                    continue

                log = result[0:3]

                if result[2] == 200:
                    self.urls_processed += 1
                elif result[2] == 429:
                    self.update_key_file_index()

                if result[2] != 200:
                    log.extend(self.parse_response(result[3]))

                my_csv.writerow(log)
                logger.debug(log)


def index_api():
    # NOTE: add ALL your account credits json files
    key_files = [
        'blog-project-43540-d31ba843867c.json',
    ]

    # NOTE: put your urls that you want to index to the file
    urls_file = 'urls.txt'

    api = GoogleIndexationAPI(key_files=key_files, urls_file_path=urls_file)
    try:
        api.indexation_worker()
    except StopIteration:
        logger.error("Exiting...")

    logger.info(f"Done! We've sent {api.urls_processed} URLs to Googlebot. You can check report in report_log.csv")


if __name__ == '__main__':
    index_api()
```

Create another file called `"/root/.cache/pypoetry/index/urls.txt"`. In the `"urls.txt"` file, you add the URLs that will be indexed by Google Search Console, as in the example below.

```yml
https://www.unixwinbsd.site/2023/12/quick-way-to-configure-openssh-server.html
https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go_0385964493.html
https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go_0324087457.html
https://www.unixwinbsd.site/2023/12/freebsd-openssh-key-authentication-ssh.html
https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go.html
https://www.unixwinbsd.site/2023/12/quick-start-guide-to-pandoc-file.html
https://www.unixwinbsd.site/2023/12/implementing-apache-web-socket-on.html
https://www.unixwinbsd.site/2023/12/ansible-on-freebsd-faster-setup.html
https://www.unixwinbsd.site/2023/12/freebsd-practical-instructions-for.html
https://www.unixwinbsd.site/2023/12/installing-freebsd-dhcp-server-with-pf.html
https://www.unixwinbsd.site/2023/11/how-to-install-gimp-on-ghostbsd-freebsd.html
https://www.unixwinbsd.site/2023/11/how-to-copy-move-remove-files-and.html
https://www.unixwinbsd.site/2023/11/download-video-youtube-with-freebsd.html
https://www.unixwinbsd.site/2023/11/implementing-dokuwiki-on-freebsd.html
https://www.unixwinbsd.site/2023/11/internet-router-gateway-with-freebsd-pf.html
https://www.unixwinbsd.site/2023/11/nextcloud-installation-on-freebsd-with.html
https://www.unixwinbsd.site/2023/11/implementing-python-modules-for-unbound.html
https://www.unixwinbsd.site/2023/11/how-to-create-freebsd-ipfw-firewall.html
```

After that, install the Google indexing API dependencies.

```yml
(pypoetry) root@ns6:~/.cache/pypoetry/index # pip install loguru
(pypoetry) root@ns6:~/.cache/pypoetry/index # pip install httplib2
(pypoetry) root@ns6:~/.cache/pypoetry/index # pip install oauth2client
```

Once you have finished configuring everything, run the indexing command `"poetry run python api.py"`.

```console
(pypoetry) root@ns6:~/.cache/pypoetry/index # poetry run python api.py
2023-12-10 09:02:43.914 | INFO     | __main__:indexation_worker:76 - Processing... Please wait
2023-12-10 09:02:43.915 | DEBUG    | __main__:indexation_worker:86 - Sending https://www.unixwinbsd.site/2023/12/quick-way-to-configure-openssh-server.html
2023-12-10 09:02:45.731 | DEBUG    | __main__:indexation_worker:103 - ['https://www.unixwinbsd.site/2023/12/quick-way-to-configure-openssh-server.html', 'URL_UPDATED', 200]
2023-12-10 09:02:45.732 | DEBUG    | __main__:indexation_worker:86 - Sending https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go_0385964493.html
2023-12-10 09:02:47.097 | DEBUG    | __main__:indexation_worker:103 - ['https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go_0385964493.html', 'URL_UPDATED', 200]
2023-12-10 09:02:47.097 | DEBUG    | __main__:indexation_worker:86 - Sending https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go_0324087457.html
2023-12-10 09:02:48.458 | DEBUG    | __main__:indexation_worker:103 - ['https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go_0324087457.html', 'URL_UPDATED', 200]
2023-12-10 09:02:48.458 | DEBUG    | __main__:indexation_worker:86 - Sending https://www.unixwinbsd.site/2023/12/freebsd-openssh-key-authentication-ssh.html
2023-12-10 09:02:49.814 | DEBUG    | __main__:indexation_worker:103 - ['https://www.unixwinbsd.site/2023/12/freebsd-openssh-key-authentication-ssh.html', 'URL_UPDATED', 200]
2023-12-10 09:02:49.814 | DEBUG    | __main__:indexation_worker:86 - Sending https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go.html
2023-12-10 09:02:51.156 | DEBUG    | __main__:indexation_worker:103 - ['https://www.unixwinbsd.site/2023/12/how-to-learn-to-create-blog-with-go.html', 'URL_UPDATED', 200]
2023-12-10 09:04:45.648 | INFO     | __main__:index_api:121 - Done! We've sent 105 URLs to Googlebot. You can check report in report_log.csv
```

Congratulations, you have successfully indexed 105 URLs to Googlebot, you can check the report in `report_log.csv`.

### b. Ping Sitemap

You may have submitted your sitemap to Google Search Console. If so, rest assured that the search engine knows you have one. Refresh your sitemap at least once a day, or perhaps several times a day.

To do this, create a file named `/root/.cache/pypoetry/index/ping.py`, and insert the script below into `ping.py`.

```console
(pypoetry) root@ns6:~/.cache/pypoetry/index # ee ping.py

from time import sleep

import requests
from loguru import logger


def ping():
    urls = [
        'https://www.unixwinbsd.site/sitemap.xml',
    ]
    base = 'https://www.google.com/ping?sitemap='

    for url in urls:
        url = f'{base}{url}'
        logger.info(f'Requesting url {url}')
        r = requests.get(url)
        if r.status_code == 200:
            logger.info(f'\t >>> Good. Sitemap sent.')
        else:
            logger.warning(f'Bad request. Status code: {r.status_code}')
        sleep(0.2)  # sleep for 0.2 seconds to be less spammy


if __name__ == '__main__':
    ping()
```

Replace `"https://www.unixwinbsd.site/sitemap.xml"` with your website's domain name. Then, run the ping command `"poetry run python ping.py"`.

```console
(pypoetry) root@ns6:~/.cache/pypoetry/index # poetry run python ping.py
2023-12-10 10:02:26.089 | INFO     | __main__:ping:15 - Requesting url https://www.google.com/ping?sitemap=https://www.unixwinbsd.site/sitemap.xml
2023-12-10 10:02:26.340 | INFO     | __main__:ping:18 -          >>> Good. Sitemap sent.
```

I think we've covered enough about Python Poetry. From setting up the project structure, managing dependencies with poetry, and linking to Google Search Console. Now all you have to do is wait for GoogleBot to crawl your site and index your Blogger or website URLs.