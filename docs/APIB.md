FORMAT: 1A

# SuperOctoMafia API

## State Response

This structure represents state for whole town. It is returned
for every reqest and is same for every user.

```
{
  "slug": "Swiebodzin",
  "version": 12331345.33235,
  "state": {
    "id": "day_voting",
    "started_at": timestamp,
  },
  "players": {
    "gruby": {
      "name": "gruby",
      "is_host": false
    },
    "chudy": {
      "name": "chudy",
      "is_host": true
    },
    "brodaty": {
      "name": "brodaty",
      "is_host": false
    }
  },
  "votes": {
    "user_a": "user_b",
    "user_b": "user_c",
    "user_c": "user_b"
  }
}
```

#### Fields

`version` - a numer that is bigger for every request, needed because we cannot rely on responses arriving to clients in given order

`slug` - unique town identifier (string)

`state.id` - name of current state

`state.started_at` - timestamp of last state transition

`players` - an object of all town players, where keys are player names

`players.name` - name (duplicated as a key for given player).

`players.is_host` - determines, if given player is a host

`votes` - an object of all votes in current state, where keys are voters names and values are votees names.

# Group Town

## Town Collection [/api/towns]

### Create New Town [POST]

Creates new town in `waiting_for_players` state if there is no town with given `slug` on the server.

Otherwise just returns state object.

+ `town.slug` (string) - slug of new town
+ `player.name` (string) - name of new player

+ Request (application/json)

    ```
    {
      "town": { "slug": "" },
      "player": { "name": "" }
    }
    ```

+ Response 201 (application/json)

    ```
    {
    }
    ```






/* @app.route('/api/towns', methods = ['POST']) */
/* @app.route('/api/towns/<slug>') */
/* @app.route('/api/towns/<slug>/players', methods = ['POST']) */
/* @app.route('/api/towns/<slug>/start', methods = ['POST']) */
/* @app.route('/api/towns/<slug>/votes', methods = ['POST']) */

