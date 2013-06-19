#! /bin/bash

parola=$(cat password)

openssl enc -d -K $parola -iv $parola -aes-128-cbc -in $1 -out aux 
tar -xf aux
rm aux
