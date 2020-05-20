function say(){
    >&2 echo -e "\e[92m$1\e[39m"
}

function warn(){
    >&2 echo -e "\e[93m$1\e[39m"
}

function err(){
    >&2 echo -e "\e[91m$1\e[39m"
}

function ask(){
  read -r -p $'\e[33m'"$1"$' (y/N) \e[0m' response
  echo ${response,,}
}

function fill(){
  read -r -p $'\e[33m'"$1"$' \e[0m' response
  echo ${response,,}
}


