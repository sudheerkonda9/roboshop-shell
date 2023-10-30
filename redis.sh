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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
validate $? "Installing redis repo all versions"

yum module enable redis:remi-6.2 -y &>> $LOGFILE
validate $? "enabling 6.2 redis"

yum install redis -y 
validate $? "Installing redis 6.2"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis.conf &>> $LOGFILE
validate $? "Redis configuration file update"

systemctl enable redis &>> $LOGFILE
validate $? "Enabling Redis"

systemctl start redis &>> $LOGFILE
validate $? "Start redis"



