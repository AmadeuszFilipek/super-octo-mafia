# CURL tests

Prepare

```
cd tests/curl
export OLD_API_URL=http://localhost:5000
export NEW_API_URL=http://localhost:5001
```

Running all tests:

```
./tests.sh
```

Running one test:

```
cd tests/curl
./tests.sh request_create_town.sh
```

On first run, it will save response from $OLD_API_URL to `response_{name}` file and reuse it.
