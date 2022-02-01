[![Repo-GitHub](https://img.shields.io/badge/dynamic/xml?color=gold&label=GitHub%20module.xml&prefix=ver.&query=%2F%2FVersion&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fexchange-rate-cbrf-ui%2Fmaster%2Fmodule.xml)](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/module.xml)
 
![OEX-zapm](https://img.shields.io/badge/dynamic/json?url=https:%2F%2Fpm.community.intersystems.com%2Fpackages%2Fexchange-rate-cbrf-ui%2F&label=ZPM-pm.community.intersystems.com&query=$.version&color=green&prefix=exchange-rate-cbrf-ui)
 
[![Docker-ports](https://img.shields.io/badge/dynamic/yaml?color=blue&label=docker-compose&prefix=ports%20-%20&query=%24.services.iris.ports&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fexchange-rate-cbrf-ui%2Fmaster%2Fdocker-compose.yml)](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/docker-compose.yml)
 
## exchange-rate-cbrf-ui
 [![OEX](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/exchange-rate-cbrf-ui)
 <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/SergeyMi37/exchange-rate-cbrf-ui">

## What's new
Added example [LOAD DATA](https://github.com/SergeyMi37/exchange-rate-cbrf-ui/blob/48acfe364a446f3c112d897ee49760607ea45cff/src/cls/appmsw/cbrf/rateinfo.cls#L268)

![Link](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/doc/Screenshot_82.png)

 
UI for demonstration [exchange-rate-cbrf](https://openexchange.intersystems.com/package/exchange-rate-cbrf)
 
## Installation with ZPM

If ZPM the current instance is not installed, then in one line you can install the latest version of ZPM.
```
set $namespace="%SYS", name="DefaultSSL" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name) set url="https://pm.community.intersystems.com/packages/zpm/latest/installer" Do ##class(%Net.URLParser).Parse(url,.comp) set ht = ##class(%Net.HttpRequest).%New(), ht.Server = comp("host"), ht.Port = 443, ht.Https=1, ht.SSLConfiguration=name, st=ht.Get(comp("path")) quit:'st $System.Status.GetErrorText(st) set xml=##class(%File).TempFilename("xml"), tFile = ##class(%Stream.FileBinary).%New(), tFile.Filename = xml do tFile.CopyFromAndSave(ht.HttpResponse.Data) do ht.%Close(), $system.OBJ.Load(xml,"ck") do ##class(%File).Delete(xml)
```
If ZPM is installed, then `exchange-rate-cbrf-ui` can be set with the command
```
zpm:USER>install exchange-rate-cbrf-ui
```
## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/exchange-rate-cbrf-ui.git
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
Open link: http://localhost:52663/apptoolsrest/a/rate&class=appmsw.cbrf.rateinfo&namespace=USER

![Link](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/doc/Screenshot_51.png)
