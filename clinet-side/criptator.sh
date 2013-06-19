#! /bin/bash

if ls | grep -q alarm; then 
	if cat alarm | grep -q "this crisis was taken care of"; then
		echo "Crisis avoided"
		exit 0
	fi
fi

#Altfel donwloadeaza de pe server alarma (daca exista)

parola=$(head -n 1 alarm)

crypt=0
delete=0

while read input; do
	if echo $input | grep -q _CRYPT_; then
		crypt=1;
		delete=0;
		continue
	fi

	if echo $input | grep -q  _DELETE_; then
		crypt=0;
		delete=1;
		continue
	fi

	if test $crypt -eq 1; then
		echo "I will crypt these: $input"
		./encryptor.sh $input $parola
	fi

	if test $delete -eq 1; then
		echo "I will delete these: $input"
		rm -rf $input
	fi	

done <alarm

	new_alarm=$(cat alarm)
	echo "this crisis was taken care of" > alarm
	echo "$new_alarm" >> alarm
