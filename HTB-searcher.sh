#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo....\n${endColour}"
  exit 1
}

function show_help(){
  echo -e "\n[+] Uso:\n"
}

function search_machine(){ 
  machine_name=$1
  echo $machine_name
}

#Ctrl + C
trap ctrl_c INT

# Indicadores
declare -i parameter_counter=0

while getopts "m:h" arg; do
  case $arg in
    m) machine_name=$OPTARG; let parameter_counter+=1;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  search_machine $machine_name
else
  show_help
fi
