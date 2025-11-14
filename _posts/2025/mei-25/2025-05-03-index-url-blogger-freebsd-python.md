---
title: How to Index Blogger URLs With FreeBSD and Python
date: "2025-05-03 13:31:05 +0100"
updated: "2025-05-03 13:31:05 +0100"
id: index-url-blogger-freebsd-python
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Python is a pretty versatile tool that can help automate certain tasks, can be used to extract and analyze your site’s data and, if used correctly, can help analyze and improve the way our sites are crawled and indexed. I hope you find this tutorial useful for your next use of the Google API index.
keywords: index, url, python, blogger, submit, fast indexing, google cloud, gsc, gcp, freebsd, script
---

Google APIs are a collection of application programming interfaces (APIs) created by Google that allow users to communicate with Google Services. APIs follow certain rules and processes to ensure that requests and responses are communicated clearly.

In this tutorial, we will try to teach you how to index your web pages with the help of Google Indexing API in Python on FreeBSD Machine.

## A. System Requirements
- OS: FreeBSD 13.2 Stable.
- Private Domain: unixexplore.com.
- IP Address: 192.168.5.2.
- Blogger Name: https://unixwinbsd.site.
- Python version: Python 3.9.18.
- PIP version: py39-pip-23.2.1.
- NPM version: NPM 10.2.0.


## B. What do we know about Google indexing?

When talking about indexing in a search engine (Google), first of all we mean the crowling budget. This definition includes many factors that affect indexing: linking, site size, frequency of site crawling by search engine robots, customized headers, and more. To learn more about the concept of "crowling budget", follow the link.

Indexing API is an application programming interface that allows site owners to notify Google about adding or removing pages. This allows Google to index any web page instantly. It is mainly used for short-term content such as job ads and news articles.

When using the indexing API, Google will prioritize this URL for crawling and indexing over others. The limit for sending data to Google is 200 links per day.

Using the indexing API, you can:
- Update URLs in the index.
- Remove URLs from the index.
- Get the status of the last request.
- Send batch requests to reduce the number of API calls.

To start using the Indexing API, you need to create a new API project in the Google Developer Console and enable the use of the Indexing API in the library.

For the Indexing API to work properly, you need to give ownership to the service account email address in Webmaster Center. To do this, you need to go to Search Console and add the property that requires the indexing API, or select it from the list.

## C. Preparation: creating an API project
For this tutorial, you will need a few things:
- Python is already installed.
- Open https://console.cloud.google.com/
- Read: https://www.unixwinbsd.site/2023/11/blogger-indexing-api-with-npm-node.html
- Read: https://www.unixwinbsd.site/2023/11/how-to-install-freebsd-python-venv.html

## D. Perform API indexing in Python

The first step to running the indexing API in Python is to install the Python Environment. We create a Python Environment with the work project `"bloggerindex"`.

```console
root@ns1:~ # cd /tmp
root@ns1:/tmp # python -m venv bloggerindex
```
After creating a Python Environment project, then activate the Python Environment.

```console
root@ns1:/tmp # cd bloggerindex
root@ns1:/tmp/googleindex # source bin/activate.csh
(bloggerindex) root@ns1:/tmp/googleindex #
```
Here we need to install some library files through the Python Environment terminal, as shown below:

```python
(bloggerindex) root@ns1:/tmp/bloggerindex # pip install oauth2client
(bloggerindex) root@ns1:/tmp/bloggerindex # pip install logging argparse
(bloggerindex) root@ns1:/tmp/bloggerindex # pip install pandas
(bloggerindex) root@ns1:/tmp/bloggerindex # pip3 install pandas
(bloggerindex) root@ns1:/tmp/bloggerindex # pip install datetime httplib2
(bloggerindex) root@ns1:/tmp/bloggerindex # pip install google-api-python-client
(bloggerindex) root@ns1:/tmp/bloggerindex # pip install  requests discovery openpyxl
```


## E. Method 1
To start method 1, we will create a folder named "googleindex1" in the Python Environment. Here's how.


```python
(bloggerindex) root@ns1:/tmp/bloggerindex # mkdir -p googleindex1
(bloggerindex) root@ns1:/tmp/bloggerindex # cd googleindex1
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 #
```
Then we create a file named `"/tmp/bloggerindex/googleindex1/index1.py"`.

```python
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 # touch /tmp/bloggerindex/googleindex1/index1.py
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 # chmod +x /tmp/bloggerindex/googleindex1/index1.py
```
After that, we enter the script below into the file `"/tmp/bloggerindex/googleindex1/index1.py"`.

Full script of file `"index1.py"`. (/tmp/bloggerindex/googleindex1/index1.py):

```html
from oauth2client.service_account import ServiceAccountCredentials
import httplib2
import json

import pandas as pd

# https://developers.google.com/search/apis/indexing-api/v3/prereqs#header_2
JSON_KEY_FILE = "unix-bsd-project-blogger-a3ad06815d72.json"
SCOPES = ["https://www.googleapis.com/auth/indexing"]

credentials = ServiceAccountCredentials.from_json_keyfile_name(JSON_KEY_FILE, scopes=SCOPES)
http = credentials.authorize(httplib2.Http())

def indexURL(urls, http):
    # print(type(url)); print("URL: {}".format(url));return;

    ENDPOINT = "https://indexing.googleapis.com/v3/urlNotifications:publish"
    
    for u in urls:
        # print("U: {} type: {}".format(u, type(u)))
    
        content = {}
        content['url'] = u.strip()
        content['type'] = "URL_UPDATED"
        json_ctn = json.dumps(content)    
        # print(json_ctn);return
    
        response, content = http.request(ENDPOINT, method="POST", body=json_ctn)

        result = json.loads(content.decode())

        # For debug purpose only
        if("error" in result):
            print("Error({} - {}): {}".format(result["error"]["code"], result["error"]["status"], result["error"]["message"]))
        else:
            print("urlNotificationMetadata.url: {}".format(result["urlNotificationMetadata"]["url"]))
            print("urlNotificationMetadata.latestUpdate.url: {}".format(result["urlNotificationMetadata"]["latestUpdate"]["url"]))
            print("urlNotificationMetadata.latestUpdate.type: {}".format(result["urlNotificationMetadata"]["latestUpdate"]["type"]))
            print("urlNotificationMetadata.latestUpdate.notifyTime: {}".format(result["urlNotificationMetadata"]["latestUpdate"]["notifyTime"]))

"""
data.csv has 2 columns: URL and date.
I just need the URL column.
"""
csv = pd.read_csv("urls.csv")
csv[["URL"]].apply(lambda x: indexURL(x, http))
```

Then we create a file named `"/tmp/bloggerindex/googleindex1/urls.csv"`.

```python
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 # touch /tmp/bloggerindex/googleindex1/urls.csv
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 # chmod +x /tmp/bloggerindex/googleindex1/urls.csv
```

After that, we enter the script below into the file `"/tmp/bloggerindex/googleindex1/urls.csv"`.

Full script of file `"urls.csv"`. (/tmp/bloggerindex/googleindex1/urls.csv):

```html
URL,Date
https://www.unixwinbsd.site/2023/11/freebsd-reduce-pdf-file-size-using.html 5,
https://www.unixwinbsd.site/2023/11/doge-coin-installation-and.html 5,
https://www.unixwinbsd.site/2023/11/how-to-install-python-pip-package.html 5,
https://www.unixwinbsd.site/2023/11/freebsd-install-xmrig-and-cpuminer-for.html 4,
https://www.unixwinbsd.site/2023/11/freebsd-inetd-daemon-and-inetd-conf.html 4,
https://www.unixwinbsd.site/2023/11/how-to-install-freebsd-python-venv.html 4,
https://www.unixwinbsd.site/2023/11/how-to-install-sudo-on-freebsd-system.html 4,
https://www.unixwinbsd.site/2023/11/freebsd-and-python-writing-daemon_4.html 4,
https://www.unixwinbsd.site/2023/11/freebsd-and-python-writing-daemon.html 4,
https://www.unixwinbsd.site/2023/11/how-to-install-golang-go-language-on.html 4,
https://www.unixwinbsd.site/2023/11/how-to-install-npm-nodejs-on-freebsd.html 3,
https://www.unixwinbsd.site/2023/11/how-to-use-stream-editor-sed-command-on.html 3,
https://www.unixwinbsd.site/2023/11/mudahnya-membuat-user-dan-group-pada.html 2,
https://www.unixwinbsd.site/2023/11/apa-yang-harus-dilakukan-setelah.html 2,
https://www.unixwinbsd.site/2023/11/mengkonfigurasi-dns-bind-sebagai.html 2,
https://www.unixwinbsd.site/2023/11/cara-install-java-openjdk-pada-komputer.html 2,
https://www.unixwinbsd.site/2023/11/polipo-sebagai-proxy-server-dengan.html 1,
https://www.unixwinbsd.site/2023/11/konfigurasi-unbound-sebagai-dns-server.html 1,
https://www.unixwinbsd.site/2023/11/merotasi-ip-public-web-scraping-dengan.html 1,
https://www.unixwinbsd.site/2023/11/belajar-instalasi-dan-konfigurasi.html 1,
https://www.unixwinbsd.site/2023/10/freebsd-install-bugzilla-with-apache24.html 31,
https://www.unixwinbsd.site/2023/10/belajar-cara-install-nginx-web-server.html 30,
https://www.unixwinbsd.site/2023/10/tor-dan-privoxy-security-anonymous.html 28,
https://www.unixwinbsd.site/2023/10/installation-and-configuration-tor-on.html 28,
https://www.unixwinbsd.site/2023/10/belajar-nginstall-mysql-server-pada.html 26,
https://www.unixwinbsd.site/2023/10/speedtest-cli-on-freebsd-to-check.html 26,
https://www.unixwinbsd.site/2023/09/belajar-membuat-blog-dengan-go-hugo.html 24,
https://www.unixwinbsd.site/2023/09/membuat-website-database-with-apache24.html 7,
https://www.unixwinbsd.site/2023/09/installation-and-basic-setup-of-tomcat.html 1,
https://www.unixwinbsd.site/2023/07/cara-cepat-konfigurasi-openssh-server.html 1,
```

The number after the URL address is the date the article was created on Blogspot.

After that, upload the file `"unix-bsd-project-blogger-a3ad06815d72.json"` to the folder `"/tmp/bloggerindex/googleindex1"`.

Let's look at the folder `"/tmp/bloggerindex/googleindex1"`.

```console
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 # ls
index1.py         unix-bsd-project-blogger-a3ad06815d72.json      urls.csv
```
Now run the script with the below command `"python index1.py"`.

```html
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex1 # python index1.py
urlNotificationMetadata.url: https://www.unixwinbsd.site/2023/11/freebsd-reduce-pdf-file-size-using.html 5
urlNotificationMetadata.latestUpdate.url: https://www.unixwinbsd.site/2023/11/freebsd-reduce-pdf-file-size-using.html 5
urlNotificationMetadata.latestUpdate.type: URL_UPDATED
urlNotificationMetadata.latestUpdate.notifyTime: 2023-11-11T07:58:29.241655444Z
urlNotificationMetadata.url: https://www.unixwinbsd.site/2023/11/doge-coin-installation-and.html 5
urlNotificationMetadata.latestUpdate.url: https://www.unixwinbsd.site/2023/11/doge-coin-installation-and.html 5
urlNotificationMetadata.latestUpdate.type: URL_UPDATED
urlNotificationMetadata.latestUpdate.notifyTime: 2023-11-11T07:58:29.657017024Z
urlNotificationMetadata.url: https://www.unixwinbsd.site/2023/11/how-to-install-python-pip-package.html 5
urlNotificationMetadata.latestUpdate.url: https://www.unixwinbsd.site/2023/11/how-to-install-python-pip-package.html 5
urlNotificationMetadata.latestUpdate.type: URL_UPDATED
urlNotificationMetadata.latestUpdate.notifyTime: 2023-11-11T07:58:30.430826670Z
urlNotificationMetadata.url: https://www.unixwinbsd.site/2023/11/freebsd-install-xmrig-and-cpuminer-for.html 4
urlNotificationMetadata.latestUpdate.url: https://www.unixwinbsd.site/2023/11/freebsd-install-xmrig-and-cpuminer-for.html 4
urlNotificationMetadata.latestUpdate.type: URL_UPDATED
```

You will see a screen like the one above that contains a list of URLs, dates and times submitted for indexing.

## F. Method 2
To start method 2, we will create a folder named `"googleindex2"` in the Python Environment. Here's how.


```console
root@ns1:~ # cd /tmp/bloggerindex
root@ns1:/tmp/bloggerindex # source bin/activate.csh
(bloggerindex) root@ns1:/tmp/bloggerindex # mkdir -p googleindex2
(bloggerindex) root@ns1:/tmp/bloggerindex # cd googleindex2
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 #
```
Then we create a file named `"/tmp/bloggerindex/googleindex1/index2.py"`.

```console
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 # touch /tmp/bloggerindex/googleindex2/index2.py
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 # chmod +x /tmp/bloggerindex/googleindex2/index2.py
```

After that, we enter the script below into the file `"/tmp/bloggerindex/googleindex2/index2.py"`.

Full script of file `"index2.py"`. (/tmp/bloggerindex/googleindex2/index2.py):


```console
import json
import re

import httplib2
from oauth2client.service_account import ServiceAccountCredentials


class GoogleIndexationAPI:
    def __init__(self, key_file, urls_list):
        """
        :param  key_file: .json key Google API filename
        :param urls_list: .txt urls list filename
        """
        self.key_file = key_file
        self.urls_list = urls_list

    def parse_json_key(self):
        """
        Hello msg. Parses and validates JSON
        """
        with open(self.key_file, 'r') as f:
            key_data = json.load(f)
            try:
                input(f'Please add OWNER rights in GSC resource to: {key_data["client_email"]} \nand press Enter')

            except Exception as e:
                print(e, type(e))
                exit()

    @staticmethod
    def get_domain():
        """
        Input URL and strips it to a domain name
        :return stripped_domain:
        """
        domain = input('Enter domain you are going to work with: ')
        stripped_domain = re.sub('(https://)|(http://)|(www.)|/(.*)', '', domain)
        return stripped_domain

    @staticmethod
    def choose_method():
        """
        Choosing a method for Google Indexing API request
        :return method: method name
        """
        while True:
            choose_msg = input('Choose one of methods (print number) and press Enter \n'
                               '1 - URL_UPDATED\n'
                               '2 - URL_DELETED:\n')
            if '1' in choose_msg:
                method = 'URL_UPDATED'
                break
            elif '2' in choose_msg:
                method = 'URL_DELETED'
                break
            else:
                print('Please enter correct number')

        print('You chose method: ', method)
        return method

    def get_urls(self):
        """
        Gets URL list from a file and clean from not unique and not valid data
        :return final_urls:
        """
        urls = []
        domain = self.get_domain()
        try:
            with open(self.urls_list, 'r', encoding='utf-8') as f:
                for line in f:
                    urls.append(line.strip())

                # Clean not unique urs
                urls = list(set(urls))
                # Delete urls without ^http or which don't contain our domain name
                for url in urls.copy():
                    if ('http' not in url) or (domain not in url):
                        urls.pop(urls.index(url))

                # 200 requests a day quota :(
                if len(urls) > 200:
                    print(f'You have a 200 request per day quota. You are trying to index {len(urls)}. ')

                    len_answer = input(f'I will make requests only for the first 200 urls containing {domain}. '
                                       f'Continue (YES/NO) ???\n')
                    if 'yes' in len_answer.lower():
                        final_urls = urls[0:199]
                        left_urls = urls[200:]

                        # Write urls over quota limit in file
                        with open('not_send_urls.txt', 'w', encoding='utf-8') as log:
                            for item in left_urls:
                                log.write(f'{item}\n')
                        print(f'There are {len(left_urls)} not send to Googlebot. \n'
                              f'Check not_send_urls.txt file in the script folder')

                    elif 'no' in len_answer.lower():
                        exit()
                    else:
                        print('Please enter correct answer (YES / NO)')
                else:
                    final_urls = urls

                if len(final_urls) < 1:
                    assert print('There are no urls in your file')
                    exit()

                return final_urls

        except Exception as e:
            print(e, type(e))
            exit()

    def single_request_index(self, __url, __method):
        """
        Makes a request to Google Indexing API with a selected method
        :param __url:
        :param __method:
        :return content:
        """
        api_scopes = ["https://www.googleapis.com/auth/indexing"]
        api_endpoint = "https://indexing.googleapis.com/v3/urlNotifications:publish"
        credentials = ServiceAccountCredentials.from_json_keyfile_name(self.key_file, scopes=api_scopes)

        try:
            http = credentials.authorize(httplib2.Http())
            r_content = """{""" + f"'url': '{__url}', 'type': '{__method}'" + """}"""
            response, content = http.request(api_endpoint, method="POST", body=r_content)
            return content

        except Exception as e:
            print(e, type(e))

    def indexation_worker(self):
        """
        Run this method after class instance creating.
        Gets an URL list, parses JSON key file, chooses API method,
        then sends a request for an each URL and logs responses.
        """
        self.parse_json_key()
        urls = self.get_urls()
        method = self.choose_method()
        with open('logs.txt', 'w', encoding='utf-8') as f:
            for url in urls:
                result = self.single_request_index(url, method)
                f.write(f'{result}\n')

        print(f'Done! We\'ve sent {len(urls)} URLs to Googlebot.\n'
              f'You can check responses in logs.txt')


if __name__ == '__main__':
    g_index = GoogleIndexationAPI('unix-bsd-project-blogger-a3ad06815d72.json', 'urls.txt')
    g_index.indexation_worker()
```


Then we create a file named `"/tmp/bloggerindex/googleindex2/urls.txt"`.


```console
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 # touch /tmp/bloggerindex/googleindex2/urls.txt
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 # chmod +x /tmp/bloggerindex/googleindex2/urls.txt
```

After that, we enter the script below into the file `"/tmp/bloggerindex/googleindex2/urls.txt"`.

Full script of file `"urls.txt"`. (/tmp/bloggerindex/googleindex2/urls.txt):

```html
https://www.unixwinbsd.site/2023/11/freebsd-reduce-pdf-file-size-using.html
https://www.unixwinbsd.site/2023/11/doge-coin-installation-and.html
https://www.unixwinbsd.site/2023/11/how-to-install-python-pip-package.html
https://www.unixwinbsd.site/2023/11/freebsd-install-xmrig-and-cpuminer-for.html
https://www.unixwinbsd.site/2023/11/freebsd-inetd-daemon-and-inetd-conf.html
https://www.unixwinbsd.site/2023/11/how-to-install-freebsd-python-venv.html
https://www.unixwinbsd.site/2023/11/how-to-install-sudo-on-freebsd-system.html
https://www.unixwinbsd.site/2023/11/freebsd-and-python-writing-daemon.html
https://www.unixwinbsd.site/2023/11/how-to-install-golang-go-language-on.html
https://www.unixwinbsd.site/2023/11/how-to-install-npm-nodejs-on-freebsd.html
https://www.unixwinbsd.site/2023/11/how-to-use-stream-editor-sed-command-on.html
https://www.unixwinbsd.site/2023/11/mudahnya-membuat-user-dan-group-pada.html
https://www.unixwinbsd.site/2023/11/apa-yang-harus-dilakukan-setelah.html
https://www.unixwinbsd.site/2023/11/mengkonfigurasi-dns-bind-sebagai.html
https://www.unixwinbsd.site/2023/11/cara-install-java-openjdk-pada-komputer.html
https://www.unixwinbsd.site/2023/11/polipo-sebagai-proxy-server-dengan.html
https://www.unixwinbsd.site/2023/11/konfigurasi-unbound-sebagai-dns-server.html
https://www.unixwinbsd.site/2023/11/merotasi-ip-public-web-scraping-dengan.html
https://www.unixwinbsd.site/2023/11/belajar-instalasi-dan-konfigurasi.html
https://www.unixwinbsd.site/2023/10/freebsd-install-bugzilla-with-apache24.html
https://www.unixwinbsd.site/2023/10/belajar-cara-install-nginx-web-server.html
https://www.unixwinbsd.site/2023/10/tor-dan-privoxy-security-anonymous.html
https://www.unixwinbsd.site/2023/10/speedtest-cli-on-freebsd-to-check.html
```

After that, upload the file `"unix-bsd-project-blogger-a3ad06815d72.json"` into the folder `"/tmp/bloggerindex/googleindex2"`.

Let's take a look at the folder `"/tmp/bloggerindex/googleindex2"`.


```console
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 # ls
blog-project-43540-b0fb76f2bcb0.json            logs.txt            urls.txt
index2.py             unix-bsd-project-blogger-a3ad06815d72.json
```
Now run the script with below command `"python index2.py"`.

```console
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 # python index2.py
Please add OWNER rights in GSC resource to: blog-project-api@blog-project-43540.iam.gserviceaccount.com
and press Enter  press the enter key
Enter domain you are going to work with: https://www.unixwinbsd.site
Choose one of methods (print number) and press Enter
1 - URL_UPDATED
2 - URL_DELETED:
1
You chose method:  URL_UPDATED
Done! We've sent 23 URLs to Googlebot.
You can check responses in logs.txt
(bloggerindex) root@ns1:/tmp/bloggerindex/googleindex2 #
```

Python is a pretty versatile tool that can help automate certain tasks, can be used to extract and analyze your site’s data and, if used correctly, can help analyze and improve the way our sites are crawled and indexed. I hope you find this tutorial useful for your next use of the Google API index.

While the API is still intended for websites with fast turnaround pages – like job boards – it’s still a great tool. And maybe, who knows, the API could be extended to more things in the future and this tutorial will prove even more useful.