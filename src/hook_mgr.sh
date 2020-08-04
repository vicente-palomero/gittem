#!/bin/bash
#
# Script for running hooks

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${here}/lib/hook.sh"

gittem_local=$(pwd)/.git/gittem
path_to_config=${gittem_local}/.config
hook_name="$@"

if [[ ! -f "${path_to_config}" ]]; then
  exit
fi

candidates=$(hook::extract ${path_to_config} ${hook_name});

for candidate in ${candidates}; do
  IFS="="
  read -ra splitted <<< "${candidate}"
  hook_name=${splitted[0]}
  path=${splitted[1]}
  full_path= ${gittem_local}/${path}
  $(hook::run ${hook_name} ${full_path})
done

