#!/bin/bash

old_api="$OLD_API_URL"
[ -z $old_api ] && old_api="http://localhost:5000"

new_api="$NEW_API_URL"
[ -z $new_api ] && new_api="http://localhost:5000"

for step_filename in steps/*; do
  step_name=`basename $step_filename`
  step_name=${step_name#step_}
  step_name=${step_name%.sh}
  response_path="responses/$step_name"

  echo -n "--- $step_name"

  if [ ! -f $response_path ]; then
    old_api_response=$(./$step_filename "$old_api" 2>1)

    if [ $? = 0 ]; then
      echo -e "$old_api_response" > $response_path
    else
      echo ': FAILED'
      echo
      echo "Request to old api failed. Response:"
      echo
      echo -e "$old_api_response"
      exit 1
    fi
  fi

  diff --color=always <(cat $response_path  | python -mjson.tool| sed '/"version":/d') <(
    ./$step_filename "$new_api" 2>1 | python -mjson.tool | sed '/"version":/d'
  ) | sed 's/^/    /'

  echo ': OK'
done
