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

## K8S

### Secrets for Argo

```bash
# generate the resources needed
$ kubectl apply -f ./argo/role.yaml ./argo/role-binding-yaml  ./argo/service-account.yaml ./argo/service-account-token.yaml

# Generate the token
$ ARGO_TOKEN="Bearer $(kubectl get secret argooperator-sa -o=jsonpath='{.data.token}' | base64 --decode)"
# or if you are using fish
$ set ARGO_TOKEN "Bearer $(kubectl get secret argooperator-sa -o=jsonpath='{.data.token}' | base64 --decode)"
```