#!/bin/bash
curl -s -f -X POST -H "Content-Type: application/json" -d '{
  "town": { "slug": "Swiebodzin" },
  "player": { "name": "Krzysztof" }
}' "${1}/api/towns"
