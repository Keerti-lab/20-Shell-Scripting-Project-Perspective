#!bin/bash

file=/etc/passwd

if [ ! -f $file ] # !=Not, -f=file
then 
   echo "Source directory: $file doesn't exits"
fi



while IFS=":" read -r  username password user_id group_id
do 
  echo "Username: $username"
  echo "password: $password"
  echo "ID: $user_id"
  echo "GroupID: $group_id"
done < $file

#IFS=Interanl Field Seperator
#Script to seperate the : and filter the username & password from /etc/passwd