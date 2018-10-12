#!/bin/bash
echo $1
curl -X POST -H "Content-Type: application/json" -d '{
  "town": { "slug": "Swiebodzin" },
  "player": { "name": "Krzysztof" }
}' "${1}/api/towns" 2>/dev/null | python -mjson.tool
