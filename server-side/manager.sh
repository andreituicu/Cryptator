#! /bin/bash

#This script should run at startup as root

while true; do
	
	# Handeling requests:

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

	#Parsing the request
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

	#Once the parsing si done, the request is removed
	rm -Rf ./requests/$request

	#Functionalities: 

	# 1) Creating an account
	###########################################################################
	if test "$what_to_do" == "Create account"; then
		echo "Creating account..."



	# 2) Adding a device to the account
	###########################################################################
	elif test "$what_to_do" == "Add device"; then
		cd $user > /dev/null

		if test $? -ne 0; then
			echo "No such user!"
			echo "User: $user Request type: $what_to_do" >> server_errors
			echo -n "From device: $computer_from " >> server_errors
			echo "For device: $computer_to" >>server_errors
			echo "ERROR 0: Unknown user!" >> server_errors
			echo >> server_errors
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
			rm -Rf authpasswd	
			cd $starting_point 
			continue
		fi

		if test $computer_to != $computer_from; then
			echo "Request not completed." >> request_history
			echo "ERROR 2: You can add a device from another!" >> request_history
			echo >> request_history	
			rm -Rf authpasswd
			cd $starting_point 
			continue
		fi

		if ls | grep -q $computer_to; then
			echo "Request not completed." >> request_history
			echo "ERROR 3: A device with the same name already exists!" >> request_history
			echo >> request_history	
			rm -Rf authpasswd
			cd $starting_point 
			continue
		fi
		
		mkdir $computer_to
		chmod 700 $computer_to
		echo "_CRYPT_" > ./$computer_to/files
		echo "_DELETE_" >> ./$computer_to/files
		echo "Request succesfully completed" >> request_history	
		echo >> request_history	

		rm -Rf authpasswd

		cd $starting_point 

	# 3) Adding new files to an account's device that should be crypted/deleted 
	#	  in case of an lockdown
	###########################################################################
	elif test $what_to_do == "Add files"; then 
		echo "Adding files..."

	# 4) Initiating a Lockdown for an account's device 
   ###########################################################################
	elif test $what_to_do == "Lockdown"; then 
		echo "Initiating lockdown..."

		cd $user &> /dev/null

		if test $? -ne 0; then
			echo "No such user!"
			echo "User: $user Request type: $what_to_do" >> server_errors
			echo -n "From device: $computer_from " >> server_errors
			echo "For device: $computer_to" >>server_errors
			echo "ERROR 0: Unknown user!" >> server_errors
			echo >> server_errors
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
			rm -Rf authpasswd	
			cd $starting_point 
			continue
		fi

		ls | grep -q $computer_to

		if test $? -ne 0; then 
			echo "Request not completed." >> request_history
			echo "ERROR 4: Unknown device \" $computer_to \" " >> request_history
			echo >> request_history
			rm -Rf authpasswd
			cd $starting_point
			continue
		fi

		if ls | grep "alarm-$computer_to"; then 
			echo "Request not completed." >> request_history
			echo "ERROR 5: Already initiated a lockdown/The device is locked!" >> request_history
			echo >> request_history
			rm -Rf authpasswd
			cd $starting_point
			continue
		fi

		rm -Rf unlock-$computer_to
		cat passwd $computer_to/files > alarm-$computer_to	
		
		rm -Rf authpasswd
		cd $starting_point

	# 5) Unlocking an account's device
	#############################################################################		
	elif test $what_to_do == "Unlock"; then 
 		echo "Unlocking..."

		cd $user &> /dev/null

		if test $? -ne 0; then
			echo "No such user!"
			echo "User: $user Request type: $what_to_do" >> server_errors
			echo -n "From device: $computer_from " >> server_errors
			echo "For device: $computer_to" >>server_errors
			echo "ERROR 0: Unknown user!" >> server_errors
			echo >> server_errors
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
			rm -Rf authpasswd	
			cd $starting_point 
			continue
		fi

		ls | grep -q $computer_to

		if test $? -ne 0; then 
			echo "Request not completed." >> request_history
			echo "ERROR 4: Unknown device \" $computer_to \" " >> request_history
			echo >> request_history
			rm -Rf authpasswd
			cd $starting_point
			continue
		fi

		if ls | grep "unlock-$computer_to"; then 
			echo "Request not completed." >> request_history
			echo "ERROR 6: Already initiated an unlock/The device is not locked!" >> request_history
			echo >> request_history
			rm -Rf authpasswd
			cd $starting_point
			continue
		fi

		rm -Rf alarm-$computer_to
		cat passwd $computer_to/files > unlock-$computer_to	
		
		rm -Rf authpasswd
		cd $starting_point


	# Handeling unknown request types
	###########################################################################
	else
			if cd $user; then
				echo "User: $user Request type: $what_to_do" >> request_history
				echo -n "From device: $computer_from " >> request_history
				echo "For device: $computer_to" >>request_history
				echo "ERROR 7: Unknown request type!" >> request_history
				echo >> request_history
				cd $starting_point
			fi

			echo "User: $user Request type: $what_to_do" >> server_errors
			echo -n "From device: $computer_from " >> server_errors
			echo "For device: $computer_to" >>server_errors
			echo "ERROR 7: Unknown request type!" >> server_errors
			echo >> server_errors
	fi

done 
