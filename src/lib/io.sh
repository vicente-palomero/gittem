#!/bin/bash
#
# Library for input and output functions

##########################
# Clean input
# Arguments:
#   an input
# Returns:
#   Cleaned $1
##########################
function io::clean() {
  echo $1 | sed "s/'//g"
}

