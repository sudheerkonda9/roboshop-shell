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

 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
 validate $? "setting up mpm source"

 yum install nodejs -y &>> $LOGFILE
 validate $? "Installing Node Js"

#Once the user is created, if you run this script second time , this command will fail definitely 
#Improvement :First check whether the user already exists or not , if not exists then create user
 useradd roboshop &>> $LOGFILE
 validate $? "Adding Roboshop User"

#write a condition to check directory already exists or not
 mkdir /app &>> $LOGFILE
 validate $? "mkdir app"

 curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
 validate $? "downloading catalogue zip file in to /tmp folder"

 cd /app &>> $LOGFILE
 validate $? "CD app 1"

 unzip /tmp/catalogue.zip &>> $LOGFILE
  validate $? "UnZipping catalogue.zip in /tmp"

 cd /app &>> $LOGFILE
 validate $? "CD app2"

 npm install &>> $LOGFILE
 validate $? "NPM Installation"

#Give full path of catalogue.service file ,because we are inside /app directory
#Inside the EC2 catalogue linux server when we clone the code the file location will be on /home/centos/roboshop-shell/catalogue.service which is normal user location and script we are executing with sudo user credentials so we need to specify the full path explicitly
 cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
 validate $? "NPM Installation"

 systemctl daemon-reload &>> $LOGFILE
 validate $? "daemon reload"

 systemctl enable catalogue &>> $LOGFILE
 validate $? "Start the service by enabling"

 systemctl start catalogue &>> $LOGFILE
  validate $? "Start catalogue"

  cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

  yum install mongodb-org-shell -y &>> $LOGFILE

  mongo --host mongodb.joindevops.icu </app/schema/catalogue.js &>> $LOGFILE



