#!/usr/bin/env bash

# http://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue
 # two way
 # on server, use export LC_ALL
 # on client, This is a common problem if you are connecting remotely,
 #            so the solution is to not forward your locale.
 #            Edit /etc/ssh/ssh_config and comment out SendEnv LANG LC_* line.

 export LC_ALL="en_US.UTF-8"

function print_green {
  echo -e "\e[32m${1}\e[0m"
}
