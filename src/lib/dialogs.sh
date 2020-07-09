#!/usr/bash
#
# Library for dialogs

##########################
# Echo with friendly format
# Arguments:
#   none
# Outputs:
#   Prompt with friendly output
##########################
function dialog::say() {
    >&2 echo -e "\e[92m$1\e[39m"
}

##########################
# Echo with warning format
# Arguments:
#   none
# Outputs:
#   Prompt with warning output
##########################
function dialog::warn() {
    >&2 echo -e "\e[93m$1\e[39m"
}

##########################
# Echo with error format
# Arguments:
#   none
# Outputs:
#   Prompt with error output
##########################
function dialog::err() {
    >&2 echo -e "\e[91m$1\e[39m"
}

##########################
# Closed question and answer retriever
# Arguments:
#   Question
# Outputs:
#   The answer of a question
##########################
function dialog::ask() {
  local question=""
  question=$1
  read -r -p $'\e[33m'"${question}"$' (y/N) \e[0m' response
  echo ${response,,}
}

##########################
# Open question and answer retriever
# Arguments:
#   Question
# Outputs:
#   The answer of a question
##########################
function dialog::fill() {
  local question=""
  question=$1
  read -r -p $'\e[33m'"${question}"$' \e[0m' response
  echo ${response,,}
}

