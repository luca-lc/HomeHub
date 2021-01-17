[1]: https://www.docker.com/
[2]: https://luca-lc.github.io/
[3]: https://plex.tv/ 

(under construction)

# HomeHub
<img src="./assets/img/HomeHub.png" width="300" align="right"/> 

#### Containerized online services 
![build](https://img.shields.io/badge/build-ContinuousIntegration-ff3030)
![status](https://img.shields.io/badge/status-Development-yellow)
![platform](https://img.shields.io/badge/platform-Docker-3285a8)
![version](https://img.shields.io/badge/version-alpha4-ff7300)

<p class="author">Author: <a href="https://luca-lc.github.io/">luca-lc</a></p>


## Introduction

*HomeHub* provides a containerized system to put some web services online. HomeHub is also a simple way to keep the entire system updated, maintained and isolated from underlying machine. Using HomeHub is also usefull to keep each container isolated for others, in this way if a fault is rised in one of them, the others continue to run. The system is based on the [Docker-CE*][1] engine.


### Description

HomeHub containes
- <u>[SQLHub](#SQLHub)</u>: a relational DBMS
- <u>[FTPHub](#FTPHub)</u>: a File Transfer Protocol server
- <u>[Plex*][3]</a></u>: a Media Server
- <u>[BoxHub](#BoxHub)</u>: a cloud service
- <u>[HostHub](#HostHub)</u>: a hosting for sites building, testing and presentation

All containers based on `HTTP` protocol are accessible using a ReverseProxy over SSL encryption but without registered certificate by CA.

<br/><br/>

#### _SQLHub_

SQLHub is a relational database management system based on `mariadb` engine. SQLHub is used by all others services communicating through underlying network provided by the docker engine, in this way all communications stay into the system and are not visible from outside. <br/>
At image building time, the system uses the root password and the new user credential saved in the `.env` file. This file has to be created before to runs the building process using this syntax:
```
ROOT_PSWD=<root password>
USR=<new username>
PSWD=<`USR` password>
```


#### _FTPHub_

The FTP server is based on `vsftpd` engine. At the image building time, the system copies the configuration files and the configuration script into the image.<br/>
Into `vsftpd.conf` configuration file are setted the environment variables, like the write permissions, users list and `chroot` to restrict users to thier home directory.<br/>
Instead, into the `configFile.conf` there are the users name and users password required to configure the entire system through `config.sh` script.<br/>
In the `vsftpd.userlist` there is a list of registered users with access permissions.

#### _BoxHub_


#### _HostHub_

---
<p class="footer">
(*) External link
</p>
