#!/bin/bash

requests=$1
[ -z $requests ] && requests=request_*.sh

old_api="$OLD_API_URL"
[ -z $old_api ] && old_api="http://localhost:5000"

new_api="$NEW_API_URL"
[ -z $new_api ] && new_api="http://localhost:5000"

for request_filename in $requests; do
  request_name=${request_filename#request_}
  request_name=${request_name%.sh}
  response_filename="response_$request_name"

  echo
  echo -n "--- $request_name"

  if [ ! -f $response_filename ]; then
    ./$request_filename "$old_api" 2>/dev/null | python -mjson.tool | sed '/"version":/d' > $response_filename
  fi

  diff --color=always $response_filename <(
    ./$request_filename "$new_api" 2>/dev/null | python -mjson.tool | sed '/"version":/d'
  ) | sed 's/^/    /'

  if [ 0 = "$?" ]; then
    echo ': ok'
  fi
done
