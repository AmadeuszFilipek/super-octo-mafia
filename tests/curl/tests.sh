#!/bin/bash

old_api="$OLD_API_URL"
[ -z $old_api ] && old_api="http://localhost:5000"

new_api="$NEW_API_URL"
[ -z $new_api ] && new_api="http://localhost:5000"

c_reset="\e[0m"
c_red="\e[31m"
c_green="\e[32m"

function run_step() {
  local api_url=$1
  local step_filename=$2
  local response=$(./$step_filename "$api_url" 2>1)

  if [ $? != 0 ]; then
    echo -e ": ${c_red}FAILED${c_reset}"
    echo
    echo "Request to $api_url failed. Response:"
    echo
    echo -e "$response"
    exit 1
  fi

  local json=$(echo -e $response | python -mjson.tool)

  if [ $? != 0 ]; then
    echo -e ": ${c_red}FAILED${c_reset}"
    echo
    echo "JSON parse error. Response:"
    echo
    echo -e "$response"
    exit 1
  fi

  # remove "version" to not trigger git diff
  echo -e "$json" | sed '/"version":/d'
}

for step_filename in steps/*; do
  step_name=`basename $step_filename`
  step_name=${step_name#step_}
  step_name=${step_name%.sh}
  response_path="responses/$step_name"

  echo -n "--- $step_name"

  if [ -f $response_path ]; then
    old_api_json=$(cat $response_path)
  else
    old_api_json=$(run_step $old_api $step_filename | tee $response_path)
  fi

  new_api_json=$(run_step $new_api $step_filename)

  diff_output=$(
    diff --color=always <(echo -e "$old_api_json") <(echo -e "$new_api_json")
  )

  if [ $? = 0 ]; then
    echo -e ": ${c_green}OK${c_reset}"
  else
    echo -e ": ${c_red}FAILED${c_reset}"
    echo
    echo -e "$diff_output" | sed 's/^/    /'
    exit 1
  fi
done

echo
