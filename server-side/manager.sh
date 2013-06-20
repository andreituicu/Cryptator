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
	starting_point=$(pwd)	

	echo
	echo "User: $user"
	echo "From device: $computer_from"
	echo "For device: $computer_to"
	echo "Request type: $what_to_do"
	echo
	rm -Rf ./requests/$request

	if test "$what_to_do" == "Create account"; then
		echo "Creating account..."
			
	elif test "$what_to_do" == "Add device"; then
		cd $user > /dev/null

		if test $? -ne 0; then
			echo "No such user!"
			continue
		fi
			
		echo "Request type: $what_to_do" >> request_history
		echo "From device: $computer_from" >> request_history
		echo "For device: $computer_to" >> request_history
		
		diff passwd authpasswd > /dev/null
		
		if test $? -ne 0; then
			echo "Incorect password!"
			echo "Request not completed." >> request_history
			echo "ERROR 1: Incorect password!" >> request_history
			echo >> request_history	
			cd $starting_point 
			continue
		fi

		if test $computer_to != $computer_from; then
			echo "Request not completed." >> request_history
			echo "ERROR 2: You can add a device from another!" >> request_history
			echo >> request_history	
			cd $starting_point 
			continue
		fi

		if ls | grep -q $computer_to; then
			echo "Request not completed." >> request_history
			echo "ERROR 3: A device with the same name already exists!" >> request_history
			echo >> request_history	
			cd $starting_point 
			continue
		fi
		
		mkdir $computer_to
		chmod 700 $computer_to
		echo "Request succesfully completed" >> request_history	
		echo >> request_history	

		rm -Rf authpasswd

		cd $starting_point 

	elif test $what_to_do == "Add files"; then 
		echo "Adding files..."

	elif test $what_to_do == "Lockdown"; then 
		echo "Initiating lockdown..."

	elif test $what_to_do == "Unlock"; then 
 		echo "Unlocking..."
	else 
		echo "Unknown request type"
	fi

done 
