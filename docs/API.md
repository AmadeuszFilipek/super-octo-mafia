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
  "slug": "",
  "state": {
    "id": "day_voting",
    "other": "attributes"
  },
  "players": {
    "id1": {
      "id": "id1",
      "name": "",
      "traits": ["host", "citizen"]
    },
    "id2": {
      "id": "id2",
      "name": "",
      "traits": ["citizen", "dead"]
    },
    "id3": {
      "id": "id3",
      "name": "",
      "traits": ["mafioso"]
    }
  ],
}
```
