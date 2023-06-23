# In House

Basic golang endpoint to deploy it with Argo pipelines.

## Local

### Run

```bash
$ go run main.go
```

## Docker

### Build image

```bash
$ docker build -t <docker-hub-username>/in-house .
# run
$ docker run --rm -p 5000:5000 <docker-hub-username>/in-house
```

### Push to docker hub

```bash
$ docker login
$ docker push <docker-hub-username>/in-house
```