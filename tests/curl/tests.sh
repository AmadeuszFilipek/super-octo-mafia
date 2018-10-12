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

  echo
  echo -n "--- $step_name"

  if [ ! -f $response_path ]; then
    ./$step_filename "$old_api" 2>/dev/null > $response_path
  fi

  diff --color=always <(cat $response_path  | python -mjson.tool| sed '/"version":/d') <(
    ./$step_filename "$new_api" 2>/dev/null | python -mjson.tool | sed '/"version":/d'
  ) | sed 's/^/    /'

  echo
done
