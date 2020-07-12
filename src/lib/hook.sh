#!/bin/bash
#
# Library for extracting information of a hook

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${here}/dialog.sh"

##########################
# Count lines until next hook
# Arguments:
#   filename
#   start line number
# Returns:
#   The position of the next hook
##########################
function hook::where_next() {
  local filename
  local start_line_number
  local next_line
  local candidate_line_number

  filename=$1
  start_line=$2
  next_line=$((start_line + 1))
  candidate_line="$(tail -n +${next_line} ${filename} \
    | grep -n '\[' | cut -d':' -f1)"

  echo $((candidate_line - 1))
}

##########################
# Run a hook
# Arguments:
#   hook_name
#   path
# Outputs:
#   Message "Done" if fine
##########################
function hook::run() {
  local hook_name
  local path

  hook_name=$1
  path=$2

  dialog::say "Running hook ${hook_name}:"
  $(${path})

  if [ $? != 0 ]; then
    dialog::err "Hook ${hook_name} failed. Aborting."
    exit 1
  fi
  dialog::say "Done."
}

##########################
# Extract related hooks
# Arguments:
#   filename
#   hook group
# Returns:
#   Related hooks to a hook group
##########################
function hook::extract() {
  local filename
  local hook_group
  local hook_line_number
  local hook_n_lines
  local max_lines
  local lines_till_next_hook

  filename=$1
  hook_group=$2

  if ! [[ -f "${filename}" ]]; then
    dialog::err "File [${filename}] does not exist" 1>&2
    exit 2
  fi

  max_lines=$(cat ${filename} | wc -l)
  if [ ${max_lines} -eq 0 ]; then
    dialog::err "File [${filename}] is empty" 1>&2
    exit 3
  fi

  hook_line_number=`cat ${filename} | grep -n ${hook_group} | cut -d':' -f1`
  hook_n_lines=`echo "${hook_line_number}" | wc -l`
  if [ -z "${hook_line_number}" ]; then
    echo ""
    exit
  fi

  # When more than one hook_group is found, raise an error.
  if [ "$hook_n_lines" -ne "1" ]; then
    dialog::err "Found more than one occurence for candidate hook [${hook_group}]" 1>&2
    exit 1
  fi

  lines_till_next_hook=$(hook::where_next ${filename} ${hook_line_number})
  if [[ ${lines_till_next_hook} -eq -1 ]]; then
    lines_till_next_hook=${max_lines}
  fi

  related_hooks=$(cat ${filename} \
    | grep -A${lines_till_next_hook} ${hook_group} \
    | grep -v "^[[:blank:]]*#" \
    | grep -v ${hook_group} \
    | grep "=" \
    | sed 's/ //g')

  echo $related_hooks
}
