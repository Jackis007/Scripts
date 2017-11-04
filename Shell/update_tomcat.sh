#!/bin/bash

set -e

date=`date +\%Y\%m\%d`
time=`date +\%H%M`

CODEHOST=172.16.100.61
PORT=22

WARNAME=AA.war
CODEPATH=/opt/Code-source/AA
WARPATH=/opt/$date"ab"/$WARNAME
TOMPATH=/opt/Tomcat/aa-tomcat

##Tomcat-stop##
tom_stop()
{
    cd $TOMPATH/bin  && ./shutdown.sh >&/dev/null
    sleep 1
        pid=`ps aux |grep "$TOMPATH" | grep -v 'grep'| awk '{print $2}'` 
        if [ "$pid" != "" ] ; then
            kill -9 $pid
            echo -e "\033[31m Tomcat is stoped! \033[0m"	
	else 
            echo -e "\033[31m Tomcat is stoped! \033[0m"	
        fi  
}

##Tomcat-start##
tom_start()
{
    cd $TOMPATH/bin  && ./startup.sh >&/dev/null
    echo -e "\033[32m Tomcat is Started! \033[0m"
}

##backup_Code##
code_backup()
{
    mv "$CODEPATH"  "$CODEPATH"_"${date}" && echo -e "\033[32m Backup "$CODEPATH"_"${date}" OK! \033[0m" || echo -e "\033[31m BackUP Code JJ  \033[0m" 
    mkdir -p $CODEPATH
}

/usr/bin/scp -P $PORT root@$CODEHOST:$WARPATH /root/
ssh -p $PORT root@$CODEHOST "mv $WARPATH $WARPATH.$time"

if [ -f /root/$WARNAME ] ; then
    #STOP_APIS#
    tom_stop
    #code_bak#
    code_backup
    mv /root/$WARNAME $CODEPATH  && cd $CODEPATH && jar -xvf $WARNAME >&/dev/null
#   mv /opt/code-program/ethank_APIS/$date/pms-APIS.war /opt/code-program/ethank_APIS/$date/pms-APIS.war.$time
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/common.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/jdbc.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/project.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/redis.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/jms.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/log4j.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/classes/HttpService.properties $APISPATH/WEB-INF/classes/
#    \cp -rf /opt/pms-source/ethank_pms_APIS_${date}/WEB-INF/log4j.properties $APISPATH/WEB-INF/
        tom_start
fi
