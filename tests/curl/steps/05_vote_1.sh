#!/bin/bash
curl -s -f -X POST -H "Content-Type: application/json" -d '{
  "vote": {
    "voteeName": "Andrzej",
    "voterName": "Krzysztof"
  }
}' "${1}/api/towns/Swiebodzin/votes"
