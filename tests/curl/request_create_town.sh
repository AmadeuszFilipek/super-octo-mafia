#!/bin/bash
curl -X POST -H "Content-Type: application/json" -d '{
  "town": { "slug": "Swiebodzin" },
  "player": { "name": "Krzysztof" }
}' http://localhost:5000/api/towns 2>/dev/null | python -mjson.tool
