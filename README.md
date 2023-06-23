# In House

Basic golang endpoint to deploy it with Argo pipelines.

## Local

### Run

```bash
$ go run main.go
```

## Docker

You can find the image on [Docker Hub](https://hub.docker.com/r/orggue/in-house).

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

### No Auth

If you want to disabled authentication for now you can path the deployment as follows:

```bash
$ kubectl patch deployment \
argo-server \
--namespace argo \
--type='json' \
-p='[{"op": "replace", "path": 
"/spec/template/spec/containers/0/args", "value": [
"server",
"--auth-mode=server"
]}]'
```

### Run

```bash
$ kubectl port-forward svc/argo-server 2746:2746
```

Now you can go directly to https://127.0.0.1:2746/ and use the token from `ARGO_TOKEN` to log in.

### Workflow

You can run the workflow with the following command:

```bash
$ argo submit -n argo --watch workflows/go.yaml
```

### Security

Here are the steps to enable RBAC and configure it to restrict access to the argo CLI commands that allow restoring workflows:

1. Enable RBAC by setting the --auth-mode flag to rbac when starting the Argo server:

```bash
$ argo server --auth-mode rbac
```

2. Create a new role that only allows read access to workflows and does not allow restoring workflows. You can use the following YAML manifest as an example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: read-only
rules:
  - apiGroups: ["argoproj.io"]
    resources: ["workflows"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["argoproj.io"]
    resources: ["workflows/finalizers"]
    verbs: ["update"]
```

This role allows read access to workflows and allows updating the finalizers of workflows (which is required to delete workflows), but does not allow creating, updating, or restoring workflows.

3. Create a new role binding that assigns the read-only role to the user who should not be able to restore workflows. You can use the following YAML manifest as an example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-only-binding
subjects:
  - kind: User
    name: jorgechato # Replace with the GitHub handle of the user who should not be able to restore workflows
roleRef:
  kind: Role
  name: read-only
  apiGroup: rbac.authorization.k8s.io
```

This role binding assigns the read-only role to the user with the GitHub handle jorgechato.

