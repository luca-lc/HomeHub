[1]: https://www.docker.com/
[2]: https://luca-lc.github.io/
[3]: https://plex.tv/

# PiNe
<img src="./assets/img/PiNe.png" width="300" align="right"/> 

#### Containerized online services 
![build](https://img.shields.io/badge/build-inTest-ff3030)
![status](https://img.shields.io/badge/status-Debug-yellow)
![platform](https://img.shields.io/badge/platform-Docker-3285a8)
![version](https://img.shields.io/badge/version-3.5-ff7300)

Author: [luca-lc][2]{:target="_blank"}


### Introduction

PiNe provides a containerized system to put some web services online. PiNe is also a simple way to keep the entire system updated, maintained and isolated from underlying system. Using PiNe is also usefull to keep each contaier isolated for others, in this way if a fault is rised in one of them, the others continue to run. The system is based on the [Docker-CE][1] engine from a maintainer idea after struggling with the same services hosted directetly on the OS.


### Description

PiNe containes
- PiNeFTP: a File Transfer Protocol server
- [Plex][3]: a Media Server
- PiNeBox: a cloud service
- PiNeSites: a hosting for sites building, testing and presentation
- PiNeSQL: a relational DBMS

All containers are accessible using a ReverseProxy.