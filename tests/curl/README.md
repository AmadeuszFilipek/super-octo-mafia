# CURL tests

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

The idea is to compare current responses with valid, cached ones in order
to check if app still behaves properly.

Testsuite is composed from steps, that live in `steps/*.sh`.

Those are simple bash scripts, that accept one argument: api url prefix,
that will be prepended to paths (`{prefix}/api/towns` etc).

Each do one request with `curl` (important!).

