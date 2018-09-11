#!/bin/sh
#script criado para adiministração do portal IBM
#criado por Michael Gonçalves
#gitHUb: https://github.com/Mikeikari


#Load Variables off xml file.

XMLDATA="/opt/scripts/AdminPortal.xml"
PortalMode="$(echo "cat /config/portalvariables/portalmode/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalHome="$(echo "cat /config/portalvariables/portalhome/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalProfile="$(echo "cat /config/portalvariables/portalprofile/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
PortalLogs="$(echo "cat /config/portalvariables/portallogs/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
Portaltemp="$(echo "cat /config/portalvariables/portaltemp/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
Portalwstemp="$(echo "cat /config/portalvariables/portalwstemp/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
Portaltranlog="$(echo "cat /config/portalvariables/portaltranlog/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
cachefile="/opt/scripts/.cacheAdminPortal"
Rerturn=""
#Load user Informations off xml file. 

User="$(echo "cat /config/connection/user/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"
Password="$(echo "cat /config/connection/password/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"


#load management servers off xml file

AppServer="$(echo "cat /config/portalvariables/portalappserver/text()" | xmllint --nocdata --shell $XMLDATA |sed '1d;$d')"

#Operator Functions for Portal Websphere. 
list () {
    #List all AppServer and DMGR in Websphere portal
    echo "the following servers are configured in this websphere portal"
    if [[ -s $cachefile ]]
        then
        cat $cachefile
                
    else
        $PortalHome/AppServer/bin/serverStatus.sh -all -username $User -password $Password  |grep "Server name" |awk '{print $4}' > $cachefile 
        cat $cachefile
    fi
}
valida_online () {
    PID=$(cat $PortalLogs/$1/$1.pid )
    Process=$( ps -ef |grep $PID |grep $1 )
  

    if ! [[ -z $Process ]]
        then
        Rerturn="online"
    else 
        Rerturn="offline"
    fi 

}
stop () {

    ARG1=$1

    if  [[  "$PortalMode" == "standalone"  ]]
        then
        valida_online $1
            if [ "$Rerturn" == "online"  ]
                then    
                  Rerturn=""
                  if [[ ("$ARG1" == "$AppServer") ]]
                    then
                        echo "O Sistema esta realizando o stop do portal"
                        $PortalHome/AppServer/bin/stopServer.sh $ARG1 -username "$User" -password "$Password"
                        
                else
                    echo  "please insert a valid server"
                    list
                fi
                  

            else
                echo "The Server Is Offline."
              
            fi
    fi
}

start () {
    
      ARG1=$1
     if  [[ "$PortalMode" == "standalone"  ]]
        then
        valida_online $1
            if [ "$Rerturn" == "offline"  ]
                then    
                  Rerturn=""
                  if [[ ("$ARG1" == "$AppServer") ]]
                    then
                        echo "Starting th Server"
                        $PortalHome/AppServer/bin/startServer.sh $ARG -username $User -password $Password
                else
                    echo  "please insert a valid server"
                    list
                fi
                  

            else
                echo "The Server Is Online."
              
            fi
    fi
  
}

status () {
    echo " Cheking Server Status:"
    $PortalHome/AppServer/bin/serverStatus.sh -all -username $User -password $Password


}

functionExecute () {

    if [ -z  $1 ]
        then 
           instrucions
    fi

    if [ "$1" == "start" ]
        then

        if [ -z $2 ]
            then 
                echo "Please use the list below to choose a server"
                list

        elif [ "$2" == "$AppServer" ]
            then
            start $2
        fi 
    fi

    if [ "$1" == "stop" ]
        then 
         if [ -z $2 ]
            then 
                echo "Please use the list below to choose a server"
                list

        elif [ "$2" == "$AppServer" ]
            then
            stop $2
        fi 

    fi    

    if [ "$1" ==  "status" ]
        then 
        status
    fi

    if [ "$1" == "list" ]
        then   
        list
    fi

      if [ "$1" == "clear" ]
        then   
        clear $2
    fi

     if [ "$1" == "logs" ]
        then   
        logs $2
    fi
}

clear () {

    if [ -z  $1 ]
        then 
           instrucions
    fi

    if [[ $1 == "temp" ]]
        then   
        while true; do
            read -p "Voce tem certza que deseja apagar o $Portaltemp ? -  y/n " yn
            case $yn in
                [Yy]* ) rm -rf $Portaltemp/* ; break;;
                [Nn]* ) exit;;
                * ) echo "Por favor Responda y or n";;
            esac
        done      
    fi

    if [[ $1 == "wstemp" ]]
        then   

        while true; do
            read -p "Voce tem certza que deseja apagar o $Portalwstemp ? -  y/n " yn
            case $yn in
                [Yy]* ) rm -rf $Portalwstemp/* ; break;;
                [Nn]* ) exit;;
                * ) echo "Por favor Responda y or n";;
            esac
        done        
    fi

    if [[ $1 == "tranlog" ]]
        then   
         while true; do
            read -p "Voce tem certza que deseja apagar o $Portaltranlog ? -  y/n " yn
            case $yn in
                [Yy]* ) rm -rf $Portaltranlog/* ; break;;
                [Nn]* ) exit;;
                * ) echo "Por favor Responda y or n";;
            esac
        done        
    fi


}

logs (){

    if [[ -z $1 ]]
        then 
        instrucions
    fi

    if [[ "$1" == "-" ]]
        then  
        tail -1000f $PortalLogs/$AppServer/SystemOut.log

    fi
    
    if [[ "$1" == "$AppServer" ]]
        then   
        tail -5000 $PortalLogs/$AppServer/SystemOut.log
    fi

}
instrucions (){ 

    echo "#####################################################################################################"
    echo " "
    echo "AdminPortal Versão 1.0 -  standalone server"
    echo "Este script contempla start / stop / status / list dos applications server do Admin portal Websphere."
    echo "Com o proposito de ter uma melhor gestão do ambiente e agilizar acoes neste ambiente"
    echo "qualquer duvida contactar o desenvolvedor - Michael - Sonda Ativas."  
    echo " "
    echo " "  
    echo "Utilize o comando dessa forma:"
    echo "Para Verificar quais são as Instancias estão instaladas no servidor use o seguinte comando:"
    echo "/opt/scrips/AdminPortal.sh list"
    echo " "
    echo " "
    echo "Para realizar o Start das instancias."
    echo "/opt/scrips/AdminPortal.sh start < Nome Da Instancia >"
    echo " "
    echo " "
    echo "Para relizar o stop das instancias:"
    echo "/opt/scrips/AdminPortal.sh stop < Nome Da Instancia >"
    echo " "
    echo " "
    echo "Para checar o status das instancias:"
    echo "/opt/scrips/AdminPortal.sh status"
    echo " "
    echo " "
    echo "Para limpar o os temporarios do portal digitar o comando abaixo escolhendo entre as opcoes:"
    echo "/opt/scrips/AdminPortal.sh clear temp/wstemp/tranlog"
    echo " "
    echo "Para visualizar os logs do portal execute o seguinte comando:"
    echo "A opcao - permite ver o log corrente" 
    echo "/opt/scrips/AdminPortal.sh logs <nome da instancia > / - "
    echo " "
    echo "#####################################################################################################"

}
functionExecute $1 $2
