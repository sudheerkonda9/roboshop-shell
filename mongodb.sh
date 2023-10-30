    #!/bin/bash
    LOGFILE_DIRECTORY=/tmp
    DATE=$(date +%F:%H:%M:%S)
    SCRIPT_NAME=$0
    LOGFILE=$LOGFILE_DIRECTORY/$SCRIPT_NAME-$DATE.log

    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    N="\e[0m"

    USERID=$(id -u)
    if [ $USERID -ne 0 ];
    then
    echo "ERROR :: $USERID not a root User"
    exit 1
    else 
    echo "SUCCESS :: Root User Login Successfull"
    
    validate () {
    if [ $1 -ne 0 ];
    then
    echo "$2 .... $R FAILED $N"
    exit 1
    else
     echo "$2 .... $G SUCCESS!!! $N"
     fi

    }

# it will invoke mongo.repo file and throuh URL present in mongo.repo ,it will download and save the files in path /etc/yum.repos.d/mongo.repo
cp mango.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
validate $? "Copied mongo.repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE
validate $? "MongoDB Installation"

systemctl enable mongod &>> $LOGFILE
validate $? "Enabled mongod"

systemctl start mongod &>> $LOGFILE
validate $? "Starting mongod"

sed -i '/s/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE
validate $? "Edited the file mongod.conf"

systemctl restart mongod &>> $LOGFILE
validate $? "Re-Starting mongod"




