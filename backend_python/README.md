# Mafia

## Requirements

You need `Python 3.x`. We use [pyenv](https://github.com/pyenv/pyenv)
to manage it (also, it reads `.python-version` so no manual work is required).

To install required packages, run:

```
pip install -r requirements.txt
```

## Running sever

```
./run_server
```

## Freezeing requirements

```
pip freeze -r requirements.txt > requirements.txt
```

## State machine

![State machine](docs/state_machine.png)

## API

[API](docs/API.md)

## Backend

* Flask "http://flask.pocoo.org/"
