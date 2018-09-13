# API

### States and attributes

#### `day_voting`, `night_voting`, `waiting_for_players`

```json
{
  "id": "day_voting"
}
```

#### `day_results` & `night_results`

```json
{
  "id": "day_results",
  "killed_player_id": "id"
}
```

#### `end_game`

```json
{
  "id": "end_game",
  "winners_ids": ["id", "id", "id"]
}
```

## POST `/towns`

```json
{
  "town": {
    "slug": ""
  }
}
```

## State Response

```json
{
  "town": {
    "slug": "",
  },
  "state": {
    "id": "day_voting",
    "other": "attributes"
  },
  "players": [
    {
      "id": "",
      "name": "",
      "traits": ["host", "citizen"]
    },
    {
      "id": "",
      "name": "",
      "traits": ["citizen", "dead"]
    },
    {
      "id": "",
      "name": "",
      "traits": ["mafioso"]
    }
  ],
}
```
