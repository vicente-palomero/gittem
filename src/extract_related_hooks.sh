#!/bin/bash

function count_lines_until_next_hook() {
    local filename=$1
    local start_line_number=$2
    local next_line=$((start_line_number+1))
    local candidate_line_number=`tail -n +$next_line $filename | grep -n '\[' | cut -d':' -f1`
    echo $((candidate_line_number-1))
}

function extract_related_hooks() {
    local filename=$1
    local hook_group=$2

    if ! [ -f "$filename" ]; then
	echo "File [$filename] does not exist" 1>&2
	exit 2
    fi

    local max_lines=$(cat $filename | wc -l)

    if [ $max_lines -eq 0 ]; then
	echo "File [$filename] is empty" 1>&2
	exit 3
    fi

    local hook_line_number=`cat $filename | grep -n $hook_group | cut -d':' -f1`
    local hook_n_lines=`echo "$hook_line_number" | wc -l`

    if [ -z "$hook_line_number" ]; then 
	echo ""
	exit
    fi

    # When more than one hook_group is found, raise an error.
    if [ "$hook_n_lines" -ne "1" ]; then 
	echo "Found more than one occurence for candidate hook [$hook_group]" 1>&2
	exit 1
    fi

    local lines_till_next_hook=$(count_lines_until_next_hook $filename $hook_line_number)

    if [[ $lines_till_next_hook -eq -1 ]]; then
	lines_till_next_hook=$max_lines
    fi

    related_hooks=$(cat $filename |
        grep -A$lines_till_next_hook $hook_group |
	grep -v "^[[:blank:]]*#" |
	grep -v $hook_group |
	grep "=" |
	sed 's/ //g')

    echo $related_hooks
}
