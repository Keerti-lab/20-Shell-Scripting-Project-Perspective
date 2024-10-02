
## Shell Scripting

- Keep all the commands inside a script and execute the script inside the server
- Shell is native scripting in Linux
- To do some automations with:
  - internal system: prefer Shell scripting
  - external system: prefer Python scripting
- There are 2 types of coding:
  1. Programming: Development i.e. less time, more performance, less resources etc using DSA, Design Patterns etc
  2. Scripting: Automation insted of Manual tasks
- With in coding, we have:
  1. Variables
  2. Data Types
  3. Conditions
  4. Loops
  5. Functions

## Shell Scripting

- Shell script files are saved with `.sh` extension
- The first line inside shell script is: `#!/bin/bash` which is called as shebang i.e. to inform linux kernel on how to run this script
- To print to the console: `echo` command
- We should never edit scripts inside the server, rather edit them in the editor and push them to the sever
- To execute a bash script, we use: `bash <filename>.sh`
- In programming, we use: DRY (Don't repeat yourself) principle

### Variables

- If a value is repeated multiple times inside a script, define a variable and declare that value to it
- And replace the value with that variable at each occurrence

```bash
PERSON1="Ramesh"
PERSON2="Suresh"
echo "Hello $PERSON1 and $PERSON2"
```

- Shell script at runtime fetches the actual values of the variables and executes the script
- Variables can be defined in multiple ways:
  1. Inside the script
  2. From command line

- Shell script executes the command inside `$()` and store its output in a variable as shown below

```bash
DATE=$(date)
echo "Today's date is $DATE"
```

- We can accept values to the variables using command line `bash 01-vars.sh Ram Raheem` and fetch them using `$1....$9`
- To get all the variables, we can use: `$@`
- To get the count of no: of variables passed: `$#`
- To get the name of the script: `$0`
- For e.g. Perform addition of 2 numbers that are provided at run-time

`01-vars.sh`

```bash
PERSON1=$1
PERSON2=$2
echo "Hello $PERSON1 and $PERSON2"

num1=$1
num2=$2
sum=$((num1 + num2))
echo "Sum of $num1 and $num2 is $sum"
```

- With the above script, we cannot perform string concatenation
- Let's say, we want to get the password information from the user inorder to connect to a database
- In this case, we can prompt the user to enter a password using:
- To hide something on the terminal when user is typing, we can use: `-s` option

```bash
echo "Please enter your username"
read USERNAME

echo "Please enter your password"
read -s PASSWORD

echo "Username: $USERNAME, Password: $PASSWORD"
```

### Data types in shell scripting

1. Number
2. Boolean
3. Arrays e.g. `PERSONS=("Ramesh" "Suresh" "Sachin")`

```bash
PERSONS=("Ramesh" "Suresh" "Sachin")
echo "First Person: ${PERSONS[0]}"
# Prints all persons
echo "Persons: ${PERSONS[@]}"
```


## Continuation with Shell Scripting

### Conditions

- Ex 1: Given a number in realtime check if its greater than 10 or not

```bash
NUMBER=$1
if [ $NUMBER -gt 10 ]
then
  echo "Number is greater than 10"
else
  echo "Number is less than 10"
fi
```

- Ex 2: Check if MySQL is installed or not
- Steps to solve this:
  1. Check if the user who is executing the script is a root user or not
      - This we can get using `id -u` command
      - For a root user, the result would be 0
      - For non-root user, it will be non-zero
      - If its non-zero, we should stop executing further statements in the script using: `exit 1`
  2. If its a success, we install MySQL using: `yum install mysql -y`

- **Note: Shell script doesn't stop if it encounters an error by default, therefore its the developers responsibility to handle it properly**
- We can get the status of the execution of a statement using: `$?`

```bash
USERID=$(id -u)
if [ $USERID -ne 0 ]
then
  echo "Error :: Please run the script with root privileges"
  exit 1 # 1 - 127 indicates its a failure
fi

yum install mysql -y

if [ $? -ne 0 ]
then
  echo "Installation of MySQL package is unsuccessful"
else
  echo "Installation of MySQL package is successful"
fi

yum install postfix -y

if [ $? -ne 0 ]
then
  echo "Installation of postfix package is unsuccessful"
else
  echo "Installation of postfix package is successful"
fi
```

### Functions

- Using Functions, we can keep some lines of code inside a block and call it when ever we need it
- Syntax:

```bash
FUNCTION_NAME(){

}
FUNCTION_NAME
```

```bash
check_status(){
  if [ $1 -ne 0 ]
  then
    echo "$2 ... FAILURE"
  else
    echo "$2 ... SUCCESS"
  fi
}

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
  echo "Error :: Please run the script with root privileges"
  exit 1 # 1 - 127 indicates its a failure
fi

yum install mysql -y
check_status $? "Installing MySQL"

yum install postfix -y
check_status $? "Installing postfix"
```

- When scripting, its always import to maintain persistent logs i.e. will remain on harddisk until we delete it to debug the issues instead of printing it to console

#### Redirections

- `ls -l 1> ls.log` or `ls -l > ls.log` - To store the output of the command `ls -l` inside ls.log file
  - `1>` - Only redirects outputs with exit status 0 i.e. success
  - `2>` - Only redirects outputs with exit status other than 0 i.e. Failure
  - `>` - Replaces the previous content with the current content
  - `&>>` - Redirect both success and failure outputs
- `date +%F` - Returns the date in YYYY-MM-DD format
- `date +%F-%H-%M-%S` - Returns the date and time in YYYY-MM-DD-HH-MM-SS format

```bash
DATE=$(date +%F)
SCRIPT_NAME=$0
LOG_FILE=/tmp/$SCRIPT_NAME-$DATE.log

check_status(){
  if [ $1 -ne 0 ]
  then
    echo "$2 ... FAILURE"
  else
    echo "$2 ... SUCCESS"
  fi
}

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
  echo "Error :: Please run the script with root privileges"
  exit 1 # 1 - 127 indicates its a failure
fi

yum install mysql -y &> LOG_FILE
check_status $? "Installing MySQL"

yum install postfix -y &> LOG_FILE
check_status $? "Installing postfix"
```

#### Colors in shell scripting

- For Red: `echo -e "\e[31m Hello World"`
  - `-e` - Enabling colors
- For Green: `echo -e "\e[32m Hello World"`
- For White: `echo -e "\e[0m Hello World"`

```bash
DATE=$(date +%F)
SCRIPT_NAME=$0
LOG_FILE=/tmp/$SCRIPT_NAME-$DATE.log

# COLORS
R="\e[31m"
G="\e[32m"
W="\e[0m"

check_status(){
  if [ $1 -ne 0 ]
  then
    echo -e "$2 ... $R FAILURE $W"
  else
    echo -e "$2 ... $G SUCCESS $W"
  fi
}

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
  echo "Error :: Please run the script with root privileges"
  exit 1 # 1 - 127 indicates its a failure
fi

yum install mysql -y &> LOG_FILE
check_status $? "Installing MySQL"

yum install postfix -y &> LOG_FILE
check_status $? "Installing postfix"
```

### Loops

- Syntax:

  ```bash
  for i in {1..100}
  do
    echo $i
  done
  ```

- Installing list of packages at runtime:

  ```bash
  for i in $@
  do
    yum install i -y
  done
  ```

- How do we decide which instance type to choose?
  - Ans: Based on the benchmark tests such as how much load the instance can handle etc
  - We can use some tools such as Apache Benchmark testing tool which sends 10K requests at one time
- To perform reverse search, we can use: `ctrl + r`

- Task 1: Install multiple packages through command line
- Steps to solve this task:
  1. User should have root access
  2. While installing store the logs
  3. Implement colors for user experience
  4. Before installing it is always good to check whether package is already installed or not
      - If installed skip, otherwise proceed for installation
  5. Check successfully installed or not

  ```bash
  #!/bin/bash

  DATE=$(date +%F)
  LOGSDIR=/home/centos/shellscript-logs
  # Logfile name format: /home/centos/shellscript-logs/script-name-date.log
  SCRIPT_NAME=$0
  LOGFILE=$LOGSDIR/$0-$DATE.log
  USERID=$(id -u)
  R="\e[31m"
  G="\e[32m"
  N="\e[0m"
  Y="\e[33m"

  if [ $USERID -ne 0 ];
  then
      echo -e "$R ERROR:: Please run this script with root access $N"
      exit 1
  fi

  check_status(){
      if [ $1 -ne 0 ];
      then
          echo -e "Installing $2 ... $R FAILURE $N"
          exit 1
      else
          echo -e "Installing $2 ... $G SUCCESS $N"
      fi
  }

  # all args are in $@
  for i in $@
  do
      yum list installed $i &>>$LOGFILE
      if [ $? -ne 0 ]
      then
          echo "$i is not installed, let's install it"
          yum install $i -y &>>$LOGFILE
          check_status $? "$i"
      else
          echo -e "$Y $i is already installed $N"
      fi
  done
  ```

- Task 2: Delete Log files older than 2 weeks inside the following Logs directory: /home/centos/app-logs
- Note: only .log files should be deleted, dont delete any other files
- Steps to solve this task:
  Step 1: go to the folder,  get all the log files with extension of .log
  Step 2: check the file modification date
  Step 3: If modification date is more than 2 weeks old, delete the files
- To create files with older date: `touch -d 20230801 cart-2023-08-01.log`, using this a file with the name cart-2023-08-01.log is created with the modification date as Aug 1st 2023
- To find files that are 2 weeks older: `find /var/log -name "*.log" -type f -mtime +14`
  - `+14` indicates 14 days

  ```bash
  #!/bin/bash

  APP_LOGS_DIR=/home/centos/app-logs

  DATE=$(date +%F-%H-%M-%S)
  LOGSDIR=/home/centos/shellscript-logs
  # /home/centos/shellscript-logs/script-name-date.log
  SCRIPT_NAME=$0
  LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

  FILES_TO_DELETE=$(find $APP_LOGS_DIR -name "*.log" -type f -mtime +14)

  echo "script started executing at $DATE" &>>$LOGFILE
  while read line
  do
      echo "Deleting $line" &>>$LOGFILE
      rm -rf $line
  done <<< $FILES_TO_DELETE
  ```

- To read line by line from a variable, we use `<<<`
- A shell script can be executed in multiple ways:
  - `bash <script-name>` --> for this no need of execute permission
  - `./<script-name>` --> it should have execute permission which can be given using: `chmod +x <script-name>`
- To schedule a script to run, we use `crontab` in edit mode: `crontab -e`
  - `* * * * * <absolute-file-path>`
  - Note: **In crontab, we should only specify absolute filepath**
- We can also view the crontab logs inside `/var/log/cron` file

- Task 3: write a shell script that should check disk usage every one hour, and send alert email if it is consuming more than 80%
- Steps:
  1. check disk memory
  2. compare with threshold (10%)
  3. if more than threshold trigger alert email
- `df -hT` --> to check disk memory
- `df -hT | grep -v tmpfs` - Returns the entries that doesn't have tmpfs in it
- To apply OR condition: `df -hT | grep -vE 'tmpfs|FileSystem'`
- When mounting an extra partition to the instance, we should ensure that its in the same AZ as our instance to which it needs to be attached

## SED Editor

- Streamline Editor i.e. running version of the editor
- By default: SED makes temporary changes to the file
- To create a line: `sed -e '1 a Good morning' <filename>`
  - `a` - append
  - `1` - after 1st line
- To insert a text before line 1: `sed -e '1 i Good morning' <filename>`
  - `i` - insert
- To make permanent changes, we use `-i` option
  - `sed -i '1 i Good morning' <filename>`
- To search a word and replace it with another word: `sed -e 's/<word-to-find>/<word-to-replace>/' <file-name`
  - `s` - Substitute
  - Note: This will only replace the first occurence in every line
- To replace all the occurences, we need to specify `g`, g for global
  - `sed -e 's/<word-to-find>/<word-to-replace>/g' <file-name`
- To delete lines that contains a word: `sed -e '/<word-to-delete>/ d' <file-name`

