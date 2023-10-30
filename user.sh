    #!/bin/bash
    LOGFILE_DIRECTORY=/tmp
    DATE=$(date +%F)
    SCRIPT_NAME=$0
    LOGFILE=$LOGFILE_DIRECTORY/$SCRIPT_NAME-$DATE.log

    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    N="\e[0m"

    USERID=$(id -u)
    if [ $USERID -ne 0 ];
    then
    echo -e "$R ERROR $N $USERID not a root User"
    exit 1
    else 
    echo -e "$G SUCCESS :: Root User Login Successfull $N"
    fi
    validate () {
    if [ $1 -ne 0 ];
    then
    echo -e "$2 .... $R FAILED $N"
    exit 1
    else
     echo -e "$2 .... $G SUCCESS!!! $N"
     fi
 }


 curl -sL https://rpm.nodesource.com/setup_lts.x | bash
validate $? "setting up mpm source"

 yum install nodejs -y
validate $? "Installing Node Js"

 useradd roboshop
validate $? "Adding Roboshop User"

 mkdir /app
 validate $? "mkdir app"

 curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
  validate $? "downloading catalogue artifact zip file in to /tmp folder"

 cd /app 
 validate $? "Moving in to App directory"
 unzip /tmp/user.zip
  validate $? "UnZipping catalogue.zip in /tmp"
 npm install 
 validate $? "NPM dependencies Installation"
 cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
 validate $? "Copying User.service"
 systemctl daemon-reload
validate $? "daemon reload"
 systemctl enable user 
 validate $? "Start the service by enabling"
 systemctl start user
 validate $? "Starting catalogue"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
validate $? "Copied mongo.repo into yum.repos.d"

 yum install mongodb-org-shell -y
 validate $? "installing mongo Client"
 mongo --host mongodb.joindevops.icu </app/schema/user.js
 validate $? "Loading catalogue data in to mongo db"
