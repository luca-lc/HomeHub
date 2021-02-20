#!/bin/bash

host=localhost
database=''
user=''
passwd=''
rootpswd=''


function usage( )
	{
		echo "q"
	}


function getVar( )
	{
		echo "w"
	}


function newUser( )
	{
		getVar
		command="CREATE USER '${user}'@'${host}' IDENTIFIED BY '${passwd}'; REVOKE ALL ON * FROM '${user}'@'${host}'; GRANT ALL privileges ON \`${database}\`.* TO '${user}'@'${host}';FLUSH PRIVILEGES;"

		echo "${commands}" | /usr/bin/mysql -u root -p
	}

function newDB( )
	{
		echo "e"
	}

function newServ( )
	{
		echo "r"
	}


if [ $# -eq 1 ]; then
		if [ -n "$1" ]; then
			case "$1" in
				-nu) newUser
				;;
				-nd) newDB
				;;
				-nn) newServ
				;;
				-h) usage
				;;
				*) 	echo -e "Option $1 not recognized"
						echo "Try '$0 -h' for more information."
				;;
			esac	
		fi
	else
		echo "missing arguments" 
		echo "Try '$0 -h' for more information."
fi