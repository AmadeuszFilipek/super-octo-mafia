#!/bin/bash
curl -f -X POST -H "Content-Type: application/json" -d '{
  "player": { "name": "Andrzej" }
}' "${1}/api/towns/Swiebodzin/players"
