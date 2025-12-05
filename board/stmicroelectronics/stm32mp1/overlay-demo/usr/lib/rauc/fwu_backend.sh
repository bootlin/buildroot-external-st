#/bin/bash

function get_state() {
	if [ "$1" = "A" ]; then
		/usr/sbin/fwumdata | grep -e "Bank 0: accepted" -e "Bank 0: valid" > /dev/null
	else
		/usr/sbin/fwumdata | grep -e "Bank 1: accepted" -e "Bank 1: valid" > /dev/null
	fi

	if [ "$?" = "0" ]; then
		echo "good"
	else
		echo "bad"
	fi

}

function set_state() {
	if [ "$1" = "A" ]; then
		bank=0
	else
		bank=1
	fi

	if [ "$2" = "good" ]; then
		/usr/sbin/fwumdata -s ${bank} accepted > /dev/null
	else
		/usr/sbin/fwumdata -s ${bank} invalid > /dev/null
	fi
}

function get_primary() {
	bank=$(/usr/sbin/fwumdata | grep "Active Index" | tail -c 2)
	if [ "$bank" = "1" ]; then
		echo B
	else
		echo A
	fi
}

function set_primary() {
	if [ "$1" = "A" ]; then
		/usr/sbin/fwumdata -a 0 -p 1 -s 0 valid > /dev/null
	else
		/usr/sbin/fwumdata -a 1 -p 0 -s 1 valid > /dev/null
	fi
}

function get_current() {
	cat /proc/cmdline | grep "rauc.slot=A" > /dev/null
	if [ "$?" = "0" ]; then
		echo "A"
	else
		echo "B"
	fi
}

if [ "$1" = "get-state" ]; then
	shift
	get_state "$@"
elif [ "$1" = "set-state" ]; then
	shift
	set_state "$@"
elif [ "$1" = "get-primary" ]; then
	shift
	get_primary "$@"
elif [ "$1" = "set-primary" ]; then
	shift
	set_primary "$@"
elif [ "$1" = "get-current" ]; then
	shift
	get_current "$@"
fi
