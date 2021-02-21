#!/bin/bash

host=127.0.0.1


function usage( )
	{
		echo "q"
	}


# CREATES A NEW USER
function newUser( )
	{
		database=$1
		user=$2
		passwd=$3

		command="CREATE USER ${user}@${host} IDENTIFIED BY ${passwd}; REVOKE ALL ON *.* FROM ${user}@${host}; GRANT ALL ON ${database}.* TO ${user}@${host}; FLUSH PRIVILEGES;"

		echo "${command}" | /usr/bin/mysql -u root -p

	}

# CREATES A NEW DATABASE
function newDB( )
	{
		database=$1
		user=$2
		passwd=$3

		command="CREATE DATABASE ${database};GRANT ALL ON ${database}.* TO ${user}@${host} IDENTIFIED BY ${passwd};FLUSH PRIVILEGES;"

		echo "${command}" | /usr/bin/mysql -u root -p
	}

# CREATE A NEW USER AND A NEW DATABASE
function newServ( )
	{
		database=$1
		user=$2
		passwd=$3

		command="CREATE DATABASE ${database};CREATE USER ${user}@${host} IDENTIFIED BY ${passwd};REVOKE ALL ON *.* FROM ${user}@${host};GRANT ALL ON ${database}.* TO ${user}@${host} IDENTIFIED BY ${passwd};FLUSH PRIVILEGES;"

		echo "${command}" | /usr/bin/mysql -u root -p
	}

# ASSIGNS AN USER TO A DATABASE
function userDB( )
	{
		database=$1
		user=$2
		passwd=$3

		command="GRANT ALL ON ${database}.* TO ${user}@${host} IDENTIFIED BY ${passwd};FLUSH PRIVILEGES;"

		echo "${command}" | /usr/bin/mysql -u root -p
	}


if [ $# -eq 1 ]; then
		if [ -n "$1" ]; then
			read -p "Database: " database
			read -p "User: " user
			read -sp "Password: " passwd 
			echo
			read -sp "Repeat Password: " rpasswd  
			echo
			
			if [[ $passwd == $rpasswd ]]; then
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
					;;
					*) 	echo -e "Option $1 not recognized"
							echo "Try '$0 -h' for more information."
					;;
				esac
			else
				echo -e "Passwords do not match\n"
				exit 1
			fi
		fi
	else
		echo "missing arguments" 
		echo "Try '$0 -h' for more information."
fi