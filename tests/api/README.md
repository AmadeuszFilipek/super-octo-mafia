# API Scenarios

```
cd tests/api
```

## Install

* Need ruby

```
bundle install
```

## Running all scenarios

```
./run_scenarios
```


```
- eight_players/errors/can_only_join_when_in_waiting_for_players ............ OK
- eight_players/errors/cannot_vote_on_non_existing ............ OK
- eight_players/errors/cannot_vote_on_self ............ OK
- eight_players/errors/must_exist_to_vote ............ OK
- eight_players/mafia_dies_in_first_round/civil1_dies_second_round ....................... OK
- eight_players/mafia_dies_in_first_round/errors/cannot_vote_when_dead ..................... OK
- eight_players/mafia_dies_in_first_round/errors/civil_cannot_vote_at_night ..................... OK
- errors/cannot_join_to_nonexisting_town .. OK
- errors/cannot_join_with_duplicated_name ... OK
- errors/town_already_exist ... OK

All scenarios passed.
```

## Running subset of scenarios

```
./run_scenarios scenarios/errors
```

Will run all scenarios having path `scenarios/errors` in ancestors

```
- errors/cannot_join_to_nonexisting_town .. OK
- errors/cannot_join_with_duplicated_name ... OK
- errors/town_already_exist ... OK

All scenarios passed.
```
```
