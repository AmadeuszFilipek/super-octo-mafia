#!/bin/bash

export api=http://localhost:5000

./request_create_town.sh $api | python -mjson.tool
./request_create_player.sh $api | python -mjson.tool
./request_start_game.sh $api | python -mjson.tool

curl -X POST -H "Content-Type: application/json" -d '{
  "vote": {
    "voteeName": "Andrzej",
    "voterName": "Krzysztof"
   }
}' "${api}/api/towns/Swiebodzin/votes" | python -mjson.tool

curl -X POST -H "Content-Type: application/json" -d '{
  "vote": {
    "voteeName": "Krzysztof",
    "voterName": "Andrzej"
   }
}' "${api}/api/towns/Swiebodzin/votes" | python -mjson.tool
