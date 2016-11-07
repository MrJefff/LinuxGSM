#!/bin/bash
# LGSM command_ts3_server_pass.sh function
# Author: Daniel Gibbs
# Contributor : UltimateByte
# Website: https://gameservermanagers.com
# Description: Changes TS3 serveradmin password.

local commandname="TS3-CHANGE-PASS"
local commandaction="TS3 Change Password"
local function_selfname="$(basename $(readlink -f "${BASH_SOURCE[0]}"))"


fn_serveradmin_password_prompt(){
	echo ""
	echo "${gamename} ServerAdmin Password Change"
	echo "================================="
	echo ""
	echo "Press \"CTRL+b d\" to exit console."
	fn_print_information_nl "You are about to change the ${gamename} ServerAdmin password."
	fn_print_warning_nl "${gamename} will restart during this process."
	echo ""
	while true; do
		read -e -i "y" -p "Continue? [Y/n]" yn
		case $yn in
		[Yy]* ) break;;
		[Nn]* ) echo Exiting; exit;;
		* ) echo "Please answer yes or no.";;
	esac
	done
	fn_script_log_info "Initiating ${gamename} ServerAdmin password change"
	read -p "Enter new password : " newpassword
}


fn_serveradmin_password_set(){
	fn_print_info_nl "Applying new password"
	fn_script_log_info "Applying new password"
	sleep 1
	# Start server in "new password mode"
	ts3serverpass="1"
	exitbypass="1"
	fn_print_info_nl "Starting server with new password"
	command_start.sh
	fn_print_ok_nl "Password applied"
	fn_script_log_pass "New ServerAdmin password applied"
	sleep 1
}

# Running functions
check.sh
fn_serveradmin_password_prompt
check_status.sh
exitbypass="1"
if [ "${status}" != "0" ]; then
	# Stop any running server
	command_stop.sh
	fn_serveradmin_password_set
	exitbypass="1"
	command_start.sh
	ts3serverpass="0"
	command_restart.sh
else
	fn_serveradmin_password_set
	command_stop.sh
fi
core_exit.sh