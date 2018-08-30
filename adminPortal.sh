#!/bin/sh
#script criado para adiministração do portal IBM
#criado por Michael Gonçalves
#gitHUb: https://github.com/Mikeikari


#Load Variables off xml file.

XMLDATA="./AdminPortalXML"
PortalMode="$(echo "cat /config/portalvariables/portalmode/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalHome="$(echo "cat /config/portalvariables/portalhome/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalLogs="$(echo "cat /config/portalvariables/portallogs/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"


#Load user Informations off xml file. 

User="$(echo "cat /config/connection/user/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
Password="$(echo "cat /config/connection/password/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"

#load management servers off xml file

AppServer="$(echo "cat /config/portalvariables/portalappserver/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"

#Operator Functions for Portal Websphere. 
stop(){
    echo "O Sistema esta realizando o stop do portal"
 
    
}

start(){
    echo "O Sistema esta realizando o Start do portal"
  
}


