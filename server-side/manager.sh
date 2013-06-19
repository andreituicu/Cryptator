#! /bin/bash

#This script should run at startup

while true; do

	touch ./requests/NO_REQUEST 
	request=$(ls -tr1 ./requests | head -n 1)
	if test $request == "NO_REQUEST"; then
		echo "There is no request to handle"
		exit 0 #This line should not exist in the actual aplication
				 #It is just for testing
		sleep 2
		continue
	fi
	echo $request
	user=$(cat ./requests/$request |head -n 1)
	computer_from=$(cat ./requests/$request | head -n 2 | tail -n 1)
	computer_to=$(cat ./requests/$request | head -n 3 | tail -n 1)
	what_to_do=$(cat ./requests/$request | head -n 4 | tail -n 1)

	echo
	echo "User: $user"
	echo "From device: $computer_from"
	echo "For device: $computer_to"
	echo "Request type: $what_to_do"
	echo
	rm ./requests/$request

	if test $what_to_do == "Create account"; then
	
	else if test $what_to_do == "Add device"; then

	else if test $what_to_do == "Add files"; then

	else if test $what_to_do == "Lockdown"; then

	else if test $what_to_do == "Unlock"; then

	else 

	fi

done 
