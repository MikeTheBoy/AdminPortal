#!/bin/sh
#script criado para adiministração do portal IBM
#criado por Michael Gonçalves
#gitHUb: https://github.com/Mikeikari


#Load Variables off xml file.

XMLDATA="./AdminPortalXML"
PortalMode="$(echo "cat /config/portalvariables/portalmode/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalHome="$(echo "cat /config/portalvariables/portalhome/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalProfile="$(echo "cat /config/portalvariables/portalprofile/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalLogs="$(echo "cat /config/portalvariables/portallogs/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
cachefile="./.cacheAdminPortal"

#Load user Informations off xml file. 

User="$(echo "cat /config/connection/user/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
Password="$(echo "cat /config/connection/password/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"

#load management servers off xml file

AppServer="$(echo "cat /config/portalvariables/portalappserver/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"

#Operator Functions for Portal Websphere. 
stop(){

    ARG1=$1
    echo "O Sistema esta realizando o stop do portal"
    if  [ $PortalMode == "standalone" ]
        then
            if [[ $ARG == $AppServer]]
                then
                    $PortalHome/AppServer/bin/stopServer.sh $ARG -username $User -password $Password
            fi

 #   if  [[ $PortalMode == "cluster" ]]
 #       then

#    fi       





    fi
}

start(){
    echo "O Sistema esta realizando o Start do portal"
  
}

list(){
    #List all AppServer and DMGR in Websphere portal
    echo "the following servers are configured in this websphere portal"
    if [[-s $cachefile ]]
        then
        echo $cachefile
      
    else
        $PortalHome/AppServer/bin/serverStatus.sh -all -username $User -password $Password  |grep "Server name" |awk '{print $4}' > $cachefile 
        echo $cachefile


    fi



}


