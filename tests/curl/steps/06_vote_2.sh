#!/bin/bash
curl -s -f -X POST -H "Content-Type: application/json" -d '{
  "vote": {
    "voteeName": "Krzysztof",
    "voterName": "Andrzej"
  }
}' "${1}/api/towns/Swiebodzin/votes"
