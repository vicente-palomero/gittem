#!/bin/bash

output=$(bats -pr $(pwd)/test/src --output /tmp)

IFS=$'\n'
passes=0
for o in $output; do
    if [[ $o =~ ^[0-9]+[[:space:]]{1}tests?,[[:space:]]{1}[0-9]+[[:space:]]{1}failures?$ ]]; then
        if [[ $o =~ 0[[:space:]]{1}failures$ ]]; then
            passes=1
        fi
        if [[ $passes == 1 ]]; then
            echo "Unit test result: $o. Passing."
        else
            echo "Unit test result: $o. Not passing. Output in /tmp/report.tap"
        fi
    fi
done

if [[ ! $passes ]]; then
    exit 1
fi
