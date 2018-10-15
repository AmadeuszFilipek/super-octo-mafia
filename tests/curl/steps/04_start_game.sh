#!/bin/bash
curl -s -f -X POST -H "Content-Type: application/json" -d '{
    "Andrzej": "mafia",
    "Krzysztof": "civil"
}' "${1}/api/towns/Swiebodzin/start"
