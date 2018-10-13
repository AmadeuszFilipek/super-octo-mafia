#!/bin/bash

api=$1

if [ -z $api ]; then
  api=http://localhost:5000
fi

curl -f -X DELETE "${api}/api/towns/Swiebodzin"
