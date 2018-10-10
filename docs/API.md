# API

## Town State Response

```json
{
  "slug": "",
  "version": timestamp,
  "state": {
    "id": "day_voting",
    "other": "attributes"
	"started_at": timestamp,
  },
  "votes": {
    "dziku": "dziku2",
    "dziku3": "dziku4",
  },
  "players": {
    "name1": {
      "name": "name1",
	  "is_host": false,
      "traits": ["host", "citizen"]
    },
    "name2": {
      "name": "name2",
      "traits": ["citizen", "dead"]
    },
    "name3": {
      "name": "name3",
      "traits": ["mafioso"]
    }
  ],
}
```


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

