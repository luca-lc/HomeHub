#!/bin/bash

host='%.homehub_frontend'

database=''
user=''
passwd=''
query=''



function getVar( )
	{
		read -p "Database: " database
		read -p "User: " user
		read -sp "Password: " passwd 
		echo
		read -sp "Repeat Password: " rpasswd  
		echo

		if [[ $passwd != $rpasswd ]]; then
			echo -e "Passwords do not match\n"
			exit 1
		fi
	}


function usage( )
	{
		echo -e "Usage: $0 [OPTION]"
		echo
		echo -e "'handlare' helps to manage the database."
		echo -e "By default the host is 'localhost'"
		echo 
		echo -e "It requires one of the following OPTIONS\n"
		echo -e " -nu\t: to create a new user for an already exisiting database"
		echo -e " -nd\t: to create a new database for an already existing user"
		echo -e " -nn\t: to create a new database and its admin user"
		echo -e " -ud\t: to assign an already existing user to an already existing database"
		echo -e " -h\t: to display this help"
		echo
	}


# CREATES A NEW USER
function newUser( )
	{
		getVar

		query="CREATE USER IF NOT EXISTS '${user}'@'${host}' IDENTIFIED BY '${passwd}'; REVOKE ALL ON *.* FROM '${user}'@'${host}'; GRANT ALL ON ${database}.* TO '${user}'@'${host}'; FLUSH PRIVILEGES;"
	}

# CREATES A NEW DATABASE
function newDB( )
	{
		getVar

		query="CREATE DATABASE IF NOT EXISTS ${database};GRANT ALL ON ${database}.* TO '${user}'@'${host}';FLUSH PRIVILEGES;"
	}

# CREATE A NEW USER AND A NEW DATABASE
function newServ( )
	{
		getVar
		
		query="CREATE DATABASE IF NOT EXISTS ${database};CREATE USER IF NOT EXISTS '${user}'@'${host}' IDENTIFIED BY '${passwd}';REVOKE ALL ON *.* FROM '${user}'@'${host}';GRANT ALL ON ${database}.* TO '${user}'@'${host}';FLUSH PRIVILEGES;"
	}

# ASSIGNS AN USER TO A DATABASE
function userDB( )
	{
		getVar

		query="GRANT ALL ON ${database}.* TO '${user}'@'${host}';FLUSH PRIVILEGES;"

	}


if [ $# -eq 1 ]; then
		if [ -n "$1" ]; then
				case "$1" in
					-nu) newUser $database $user $passwd
					;;
					-nd) newDB $database $user $passwd
					;;
					-nn) newServ $database $user $passwd
					;;
					-ud) userDB $database $user $passwd
					;;
					-h) usage
					exit 1
					;;
					*) 	echo -e "Option $1 not recognized"
							echo "Try '$0 -h' for more information."
							exit 1
					;;
				esac

				/usr/bin/mysql -u root -p -e "${query}"
				# echo "${query}"
		fi
	else
		echo "missing arguments" 
		echo "Try '$0 -h' for more information."
fi