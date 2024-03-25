#!/bin/bash

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

#Ctrl + C
trap ctrl_c INT

# Indicadores
declare -i parameter_counter=0

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
  echo -e "\t ${purpleColour}i)${endColour} ${turquoiseColour}Buscar un por ip de maquina${turquoiseColour}"
  echo -e "\t ${purpleColour}u)${endColour} ${turquoiseColour}Actualizar sistema${turquoiseColour}"
  echo -e "\t ${purpleColour}h)${endColour}${turquoiseColour} Mostrar este panel de ayuda${endColour}"
  echo -e "\n"
}

function update_files(){
   if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${purpleColour} Descargando los archivos necesarios..${endColour}"
    curl -s $main_url > bundle.js | js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${purpleColour} Actualizacion completada ${endColour}"
    tput cnorm
  else
    if curl -s https://htbmachines.github.io/bundle.js | js-beautify | cmp bundle.js -; then
      echo -e "${yellowColour}[+]${endColour}${purpleColour} No se han encontrado actualizaciones ${endColour}"
    else
      echo -e "${yellowColour}[!]${endColour}${purpleColour}Se ha encontrado una actualizacion${endColour}"
      curl -s $main_url > bundle.js | js-beautify bundle.js | sponge bundle.js
      echo -e "${yellowColour}[+]${endColour}${purpleColour}La actualizacion se ha realizado con exito${endColour}"
    fi
  fi
}

function search_machine(){ 
  echo -e "${yellowColour}[+]${endColour}${grayColour}Listando la maquina${endColour}"
  cat bundle.js | grep "name: \"$machine_name\"" -A 9 | grep -vE "id:|sku:|resuelta:" | tr -d '"' | sed 's/^ *//'
}

function search_ip(){
  ip_address="$1"
  machine_name="$(cat bundle.js | grep "ip: \"10.10.11.105\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
 echo -e "\n[+] La maquina correspondiente a la IP $ip_address es $machine_name"
 search_machine $machine_name
}

while getopts "m:ui:h" arg; do
  case $arg in
    m) machine_name=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ip_address=$OPTARG; let parameter_counter+=3;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  search_machine $machine_name
elif [ $parameter_counter -eq 2 ]; then
  update_files
elif [ $parameter_counter -eq 3 ]; then
  search_ip $ip_address
else
  show_help
fi
