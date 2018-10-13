#!/bin/bash

# Run without arguments will run all steps from steps/*
# Can pass glob or list of steps manually
steps="$@"
if [ -z "$steps" ]; then
  steps="steps/*"
fi

old_api="$OLD_API_URL"
[ -z $old_api ] && old_api="http://localhost:5000"

new_api="$NEW_API_URL"
[ -z $new_api ] && new_api="http://localhost:5000"

c_reset="\e[0m"
c_red="\e[31m"
c_green="\e[32m"
c_yellow="\e[33m"

# (api_url, step_filename)
# outputs response json or error messages
function run_step() {
  local api_url=$1
  local step_filename=$2
  local response=$(./$step_filename "$api_url")

  if [ $? != 0 ]; then
    echo -e ": ${c_red}FAILED${c_reset}"
    echo
    echo "Request to $api_url failed. Response:"
    echo
    echo -e "$response"
    exit 1
  fi

  local json=$(echo -e $response | python -mjson.tool 2>/dev/null)

  if [ $? != 0 ]; then
    echo -e ": ${c_red}FAILED${c_reset}"
    echo
    echo "JSON parse error. Response:"
    echo
    echo -e "$response"
    exit 1
  fi

  # remove "version" line of response json to not trigger git diff with
  # constntly changing version, based on current time
  echo -e "$json" | sed '/"version":/d'
}

# Main loop
#
# 1. Check if cached response for step is available
# 2. If it is available, use it
# 3. If it it not available, request $OLD_API_URL and cache prettified results
#    (also removes "version" field)
# 4. If request to $OLD_API_URL fails or JSON parsing fails,
#    output error and exit with failure status
# 5. Perform request to $NEW_API_URL
# 6. If request to $NEW_API_URL fails or JSON parsing gails,
#    output error and exit with failure status
# 8. Prettify and remove "version" from $NEW_API_URL
# 9. Compare cached response to actual one
# 10. If they differ, show the difference and exit with failure status
# 11. If they are same, continue to next step or exit with success status
for step_filename in $steps; do
  step_name=`basename $step_filename`
  step_name=${step_name#step_}
  step_name=${step_name%.sh}
  response_path="responses/${step_name}.json"

  echo -n "--- $step_name"

  # Use cached or cache step response
  if [ "$RECORD_MODE" != "true" ] && [ -f $response_path ]; then
    old_api_json=$(cat $response_path)
  else
    old_api_json=$(run_step $old_api $step_filename | tee $response_path)
  fi

  if [ "$RECORD_MODE" != "true" ]; then
    # Fetch actual response
    new_api_json=$(run_step $new_api $step_filename)

    diff_output=$(
      diff --unified --color=always <(echo -e "$old_api_json") <(echo -e "$new_api_json")
    )

    if [ $? = 0 ]; then
      echo -e ": ${c_green}OK${c_reset}"
    else
      echo -e ": ${c_red}FAILED${c_reset}"
      echo
      echo -e "$diff_output" | sed 's/^/    /'
      exit 1
    fi
  else
    echo -e ": ${c_yellow}CACHED${c_reset}"
  fi
done

echo
