[![Repo-GitHub](https://img.shields.io/badge/dynamic/xml?color=gold&label=GitHub%20module.xml&prefix=ver.&query=%2F%2FVersion&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fappmsw-sql2xlsx%2Fmaster%2Fmodule.xml)](https://raw.githubusercontent.com/sergeymi37/appmsw-sql2xlsx/master/module.xml)
 
![OEX-zapm](https://img.shields.io/badge/dynamic/json?url=https:%2F%2Fpm.community.intersystems.com%2Fpackages%2Fappmsw-sql2xlsx%2F&label=ZPM-pm.community.intersystems.com&query=$.version&color=green&prefix=appmsw-sql2xlsx)
 
[![Docker-ports](https://img.shields.io/badge/dynamic/yaml?color=blue&label=docker-compose&prefix=ports%20-%20&query=%24.services.iris.ports&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fappmsw-sql2xlsx%2Fmaster%2Fdocker-compose.yml)](https://raw.githubusercontent.com/sergeymi37/appmsw-sql2xlsx/master/docker-compose.yml)
 
## appmsw-sql2xlsx
 [![OEX](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/appmsw-sql2xlsx)
 <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/SergeyMi37/appmsw-sql2xlsx">
 
UI for demonstration [appmsw-sql2xlsx](https://openexchange.intersystems.com/package/appmsw-sql2xlsx)
 
## Installation with ZPM

If ZPM the current instance is not installed, then in one line you can install the latest version of ZPM.
```

```
If ZPM is installed, then `exchange-rate-cbrf-ui` can be set with the command
```
zpm:USER>install appmsw-sql2xlsx
```
## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/appmsw-sql2xlsx.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it
Open link: http://localhost:52663/appmswrest/a/rate&class=appmsw-sql2xlsx


![Link](https://raw.githubusercontent.com/sergeymi37/appmsw-sql2xlsx/master/doc/Screenshot_51.png)
