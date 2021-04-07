#!/bin/bash

# Inspired from https://github.com/justinrummel/Random-Scripts/blob/master/VMWare/ubuntuSetup.sh

### Description
# Goal is to have a script that performs the basic setup needed for a Ubuntu server that will then be managed by Ansible.


# Base Variables. Creates Log files and sets date/time info
declare -x SCRIPTPATH="${0}"
declare -x RUNDIRECTORY="${0%/*}"
declare -x SCRIPTNAME="${0##*/}"

logtag="${0##*/}"
debug_log="disable"
logDate=`date "+%Y-%m-%d"`
logDateTime=`date "+%Y-%m-%d_%H:%M:%S"`
log_dir="/var/log/${logtag}"
LogFile="${logtag}-${logDate}.log"

# Script Functions
verifyRoot () {
    #Make sure we are root before proceeding.
    [ `id -u` != 0 ] && { echo "$0: Please run this as root."; exit 0; }
}

logThis () {
	# Output to stdout and LogFile.
    logger -s -t "${logtag}" "$1"
    [ "${debug_log}" == "enable" ] && { echo "${logDateTime}: ${1}" >> "${log_dir}/${LogFile}"; }
}

init () {
    # Make our log directory
    [ ! -d $log_dir ] && { mkdir $log_dir; }

    # Now make our log file
    if [ -d $log_dir ]; then
        [ ! -e "${log_dir}/${LogFile}" ] && { touch $log_dir/${LogFile}; logThis "Log file ${LogFile} created"; logThis "Date: ${logDateTime}"; }
    else
        echo "Error: Could not create log file in directory $log_dir."
        exit 1
    fi
    echo " " >> "${log_dir}/${LogFile}"
}

update() {
    logThis "Running apt-get update"
    getUpdates=$(sudo /usr/bin/apt-get -qy update > /dev/null)
    [ $? != 0 ] && { logThis "apt-get update had an error.  Stopping now!"; exit 1; } || { logThis "apt-get update completed successfully."; }
}

sshServer() {
	sshCheck=$(netstat -natp | grep [s]shd | grep LISTEN | grep -v tcp6)
	[ $? != 0 ] && { logThis "openssh-server is NOT installed."; installOpenssh; } || { logThis "openssh-server is running."; }
}

installOpenssh() {
	logThis "Installing openssh-server."
	installSSH=$(sudo /usr/bin/apt-get install openssh-server -qy)
	[ $? != 0 ] && { logThis "apt-get install openssh-server had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install openssh-server completed successfully."; }
}

curlCLI() {
	curlCheck=$(which curl)
	[ $? != 0 ] && { logThis "curl is NOT installed."; installCurl; } || { logThis "curl is available."; }
}

installCurl() {
	logThis "Installing curl."
	installSSH=$(sudo /usr/bin/apt-get install curl -qy)
	[ $? != 0 ] && { logThis "apt-get install curl had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install curl completed successfully."; }
}

python3() {
	curlCheck=$(which python3)
	[ $? != 0 ] && { logThis "python3 is NOT installed."; installPython3; } || { logThis "python is available."; }
}

installPython3() {
	logThis "Installing python3."
	installPython=$(sudo /usr/bin/apt-get install python3.9 -qy)
	[ $? != 0 ] && { logThis "apt-get install python3.9 had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install python3.9 completed successfully."; }
}

sshpass() {
	curlCheck=$(which sshpass)
	[ $? != 0 ] && { logThis "sshpass is NOT installed."; installSshpass; } || { logThis "sshpass is available."; }
}

installSshpass() {
	logThis "Installing sshpass."
	installsshpass=$(sudo /usr/bin/apt-get install sshpass -qy)
	[ $? != 0 ] && { logThis "apt-get install sshpass had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install sshpass completed successfully."; }
}

avahiDaemon() {
	curlCheck=$(which avahi-daemon)
	[ $? != 0 ] && { logThis "avahi-daemon is NOT installed."; installAvahiDaemon; } || { logThis "avahi-daemon is available."; }
}

installAvahiDaemon() {
	logThis "Installing avahi-daemon."
	installavahiDaemon=$(sudo /usr/bin/apt-get install avahi-daemon -qy)
	[ $? != 0 ] && { logThis "apt-get install avahi-daemon had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install avahi-daemon completed successfully."; }
}

verifyRoot
init
update
sshServer
curlCLI
python3
sshpass
avahiDaemon

exit 0