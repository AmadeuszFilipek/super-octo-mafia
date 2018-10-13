# CURL tests

## Test mode

Setup old api url (needed only to record new responses):

```
export OLD_API_URL=http://localhost:5000
```

Run tests

```
export NEW_API_URL=http://localhost:5000
cd tests/curl
./tests.sh
```

The idea is to use `diff` to compare current responses with valid, cached ones in order
to check if app still behaves properly.

Testsuite is composed from steps, that live in `steps/*.sh`.

Those are simple bash scripts, that accept one argument: api url prefix,
that will be prepended to paths (`{prefix}/api/towns` etc).

Each do one request with `curl` (important!).

## Record mode

If you want to record all steps or given step only and do not perform
request to new api, set proper env var:

```
RECORD_MODE=true ./tests.sh
RECORD_MODE=true ./tests.sh steps/02_create_town.sh
```
