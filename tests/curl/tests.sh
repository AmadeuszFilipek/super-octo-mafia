#!/bin/bash

echo

requests=$1
[ -z $requests ] && requests=request_*.sh

old_api="http://localhost:5000"
# new_api="$old_api"

for request_filename in $requests; do
  request_name=${request_filename#request_}
  request_name=${request_name%.sh}
  response_filename="response_$request_name"

  echo "--- $request_name"

  if [ ! -f $response_filename ]; then
    echo -n "  > no response found, quering old api..."
    ./$request_filename "$old_api" > $response_filename
    echo " cached"
  else
    echo "  > reusing cache"
  fi

  echo

  diff --color=always $response_filename <(./$request_filename) | sed 's/^/    /'
done
