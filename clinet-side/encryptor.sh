#! /bin/bash

#parola=$(cat password)

tar -cf uncrypted $1
rm -rf $1
openssl enc -K $2 -iv $2 -aes-128-cbc -in uncrypted -out $1 
rm uncrypted
