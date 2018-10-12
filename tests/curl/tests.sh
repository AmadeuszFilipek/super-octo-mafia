#!/bin/bash

tests=$1
[ -z $tests ] && tests=test_*.sh

old_api="$OLD_API_URL"
[ -z $old_api ] && old_api="http://localhost:5000"

new_api="$NEW_API_URL"
[ -z $new_api ] && new_api="http://localhost:5000"

for test_filename in $tests; do
  test_name=${test_filename#test_}
  test_name=${test_name%.sh}
  response_filename="response_$test_name"

  echo
  echo -n "--- $test_name"

  ./setup.sh

  if [ ! -f $response_filename ]; then
    ./$test_filename "$old_api" 2>/dev/null > $response_filename
  fi

  diff --color=always <(cat $response_filename | sed '/"version":/d') <(
    ./$test_filename "$new_api" 2>/dev/null | sed '/"version":/d'
  ) | sed 's/^/    /'

  if [ 0 = "$?" ]; then
    echo ': ok'
  fi
done
