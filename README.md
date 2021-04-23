[1]: https://www.docker.com/
[2]: https://luca-lc.github.io/
[3]: https://plex.tv/ 
[4]: https://nextcloud.com/
[5]: https://openvpn.net/
[6]: https://mariadb.org/

# HomeHub

<p> Containerised online services</p>

<img src="./assets/img/HomeHub.png" width="300" align="right"/>

![status](https://img.shields.io/badge/status-running-green)
![platform](https://img.shields.io/badge/platform-Docker-3285a8)
![os](https://img.shields.io/badge/OS-linux-orange)

<br/>

## Contents

- [HomeHub](#homehub)
	- [Contents](#contents)
	- [Introduction](#introduction)
	- [Description](#description)
		- [_FTPHub_](#ftphub)
		- [_SQLHub_](#sqlhub)
		- [BoxHub](#boxhub)
	- [How To Install](#how-to-install)
		- [First Way: automatic installer](#first-way-automatic-installer)
		- [Second Way: "Handmade"](#second-way-handmade)
	- [How To Use](#how-to-use)
		- [FTPHub](#ftphub-1)
		- [SQLHub](#sqlhub-1)
		- [BoxHub](#boxhub-1)

<br/>

## Introduction

*HomeHub* provides a containerised system to put some web services online. HomeHub is also a simple way to keep the entire system updated, maintained and isolated from underlying machine. HomeHub is also useful to keep each container isolated from the others, so if a fault occurs in one of them, the others continue to run. The entire system is based on the [Docker-CE*][1].

<br/>

## Description

HomeHub containes
- <u>[FTPHub](#FTPHub)</u>: FTP server based on vsftpd
- <u>[Plex*][3]</a></u>: Media Server
- <u>[SQLHub](#SQLHub)</u>: relational DBMS based on [mariadb*][6]
- <u>[BoxHub](#BoxHub)</u>: cloud service based on [NextCloud*][4]
<!-- - <u>[HostHub](#HostHub)</u>: hosting for sites building, testing and presentation -->

All containers based on `HTTP` protocol are accessible using a **ReverseProxy** over SSL encryption but without registered certificate by CA.

### _FTPHub_

The FTPHub is based on `vsftpd` engine. At the image building time, the system copies the configuration files and the configuration script into the container.<br/>
Into `vsftpd.conf` configuration file are set the environment variables, like the writing permissions, users list and `chroot` to restrict users to their home directory.<br/>
Instead, into the `configFile.conf` there are the users name and users password required to configure the entire system through `config.sh` script launched at building time.<br/>
In the `vsftpd.userlist` there is a list of registered users with permission to use this service. This file is useful if you want to disable a user from logging in.

### _SQLHub_

SQLHub is a relational database management system based on `mariadb` engine. SQLHub is used by all others services that need a db and communicate with it through underlying network provided by Docker, in this way all communications stay into the system and are not visible from outside and more important the DBMS cannot be reached directly from outside the host system. <br/>
At image building time, the system uses the custom _root_ password saved in the `.env` file otherwise it creates the _root_ account with the temp password written into the Dockerfile.<br/> `.env` has to be created before to run the building process and the variable has to be written using this syntax:

```
ROOT_PSWD=<root password>
```

### BoxHub

<br/>

## How To Install

To install the services there are two ways: the first easier, the second more complicated.

### First Way: automatic installer

Inside the project root directory there is a script known as **[install.sh](https://github.com/luca-lc/HomeHub/blob/master/install.sh)** that can be executed using that command:
```
$ sudo /path/to/proj/install.sh
```
It requires a root capabilities so it can be run from standard Linux user using `sudo` command or directly as *root* user.

It provides to install and update the firewalls for all services opening the needed ports and installing the *AppArmor* profiles.
Then, asks the user to insert the accounts number, their names and passwords to use in FTPHub. After insertion it requires to user to check the accounts correctness.

To complete the installation, the process asks the user if the *[docker-compose.yml](https://github.com/luca-lc/HomeHub/blob/master/docker-compose.yml)* is complete and correct and if you want to start the services after the installation.

At the end it cleans the environment and shows the status of services.


### Second Way: "Handmade"

To build the services it can be done using a simple command:
```
$ sudo docker-compose up --build -d
```
It compiles the services and start them in detached mode, obviously, it needs the root capabilities.

Before to run it, you need to create the `FTPHub/conf/configFile.conf` with the accounts' names and passwords like this:
```
uname1=<name1>
upass1=<password1>

uname<N>=<name<N>>
upass<N>=<password<N>>

nusers=N  	#users number
```

,insert the correct firewall rules into the iptables (using also the *UFW* software as into the *install.sh*) and compile the *AppArmor* profiles that are inside the `apparmor` directory.

For more info you can check:

- [UFW](https://manpages.ubuntu.com/manpages/precise/man8/ufw.8.html)
- [AppArmor](https://gitlab.com/apparmor/apparmor/-/wikis/home)

<br/>

## How To Use

### FTPHub

After the installation the server can be used with any FTP client with _insecure_ login, it means that the server can not be used with TLS/SSL. All files are saved in the directory configured in *docker-compose*.

### SQLHub

Inside the container there is a script to help manage the databases: help you to create a new user, a new db or both. This file is executable with this command:

```
$ sudo docker exec -it <container-name> /handler.sh -<option>
```

The possible handler options are

```
-nu: to create a new user for an already existing database
-nd: to create a new database for an already existing user
-nn: to create a new database and its admin user
-ud: to assign an already existing user to an already existing database
-h:  to display this help
```

An advice for a safer service is use for each new database a new user.

<u>waiting for a fixing update</u>:<br/>
To improve the security it's recommended to clean the `MYSQL_ROOT_PASSWORD` variable 	from container shell using this command:

```
$ sudo docker exec -it <container-name> /bin/bash #to access the container from host

$ MYSQL_ROOT_PASSWORD='' #launch it insde the container to clean the variable
```

### BoxHub

<br/>

---

<p class="footer">
(*) External link
</p>
