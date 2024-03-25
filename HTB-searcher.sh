#!/bin/bash

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

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
  echo -e "\n\n${redColour}[!] Saliendo....${endColour}"
  exit 1
}

function show_help(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour}Uso:${endColour}"
  echo -e "\t ${purpleColour}m)${endColour} ${turquoiseColour}Buscar un por nombre de maquina${turquoiseColour}"
  echo -e "\t ${purpleColour}u)${endColour} ${turquoiseColour}Actualizar sistema${turquoiseColour}"
  echo -e "\t ${purpleColour}h)${endColour}${turquoiseColour} Mostrar este panel de ayuda${endColour}"
  echo -e "\n"
}

function update_files(){
   if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${purpleColour} Descargando los archivos necesarios..${endColour}"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${purpleColour} Actualizacion completada ${endColour}"
    tput cnorm
  else
    if curl -s https://htbmachines.github.io/bundle.js | js-beautify | cmp bundle.js -; then
      echo -e "${yellowColour}[+]${endColour}${purpleColour} Sistema actualizado ${endColour}"
    fi
  fi
  }

function search_machine(){ 
  machine_name=$1
  echo $machine_name
}

#Ctrl + C
trap ctrl_c INT

# Indicadores
declare -i parameter_counter=0

while getopts "m:uh" arg; do
  case $arg in
    m) machine_name=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  search_machine $machine_name
elif [ $parameter_counter -eq 2 ]; then
  update_files
else
  show_help
fi
