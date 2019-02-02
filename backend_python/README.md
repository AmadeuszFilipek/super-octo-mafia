# Backend in Python using Flask

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

or

```
./run_server HOST=127.0.0.1 PORT=9999
```

## Freezeing requirements

Please do this after installing some new dependencies.

```
pip freeze -r requirements.txt > requirements.txt
```
