#!/bin/sh
sudo su
sed -i 's/port="8080"/port="$1"/' /etc/tomcat/server.xml
sudo yum install tomcat tomcat-webapps
sudo service tomcat start

