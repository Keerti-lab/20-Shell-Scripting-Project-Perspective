#!bin/bash

SOURCE_DIR="/tmp/logs"

if [ ! -d $SOURCE_DIR ] # !=Not, -d=directory
then 
   echo "Source directory: $SOURCE_DIR doesn't exits"
fi

FILES_TO_DELETE=$(find /tmp/logs/ -type f -mtime +1 -name "*.log") #To find 14days older files 

while IFS= read -r line #read -r line = To read the del file output line by line and IFS=Interal field seperator
do 
 echo "Deleting file: $line"
 rm -rf $line
done <<< $FILES_TO_DELETE
