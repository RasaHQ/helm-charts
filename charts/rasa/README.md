# rasa

![Version: 1.17.3](https://img.shields.io/badge/Version-1.17.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.2.6](https://img.shields.io/badge/AppVersion-3.2.6-informational?style=flat-square)

The Rasa Helm chart deploy a Rasa Open Source Server. Rasa is an open source machine learning framework for automated text and voice-based conversations.

See the [Rasa docs](https://rasa.com/docs/rasa/) to learn more.

## How to use Rasa Helm repository

You need to add this repository to your Helm repositories:

```shell
helm repo add rasa https://helm.rasa.com
helm repo update
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~10.16.2 |
| https://charts.bitnami.com/bitnami | rabbitmq | ~8.32.2 |
| https://charts.bitnami.com/bitnami | redis | ~15.7.6 |
| https://helm.rasa.com | duckling | ~1.0.0 |
| https://helm.rasa.com | rasa-action-server | ~1.0.0 |
| https://helm.rasa.com | rasa-common | ~1.0.2 |

## Quick start

The default configuration of the Rasa chart deploys a Rasa Open Source Server, downloads a model, and serves the downloaded model.

Below you can find examples of how to configure your deployment or use more advanced configurations such as integration with Rasa X/Enterprise.

Default components that will be installed along with the Rasa server:

* PostgreSQL used as the backend for the [Tracker Store](https://rasa.com/docs/rasa/tracker-stores)

### Installing the Rasa Chart

To install the chart and assign the release name `<RELEASE_NAME>`, run the following command:

```bash
helm install --name <RELEASE_NAME> rasa/rasa
```

After Rasa was installed successfully you should see additional information on how to connect to it, e.g:

```shell
To access Rasa from outside of the cluster, follow the steps below:

1. Get the Rasa URL by running these commands:

    export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services <RELEASE_NAME>)
    kubectl port-forward --namespace default svc/<RELEASE_NAME> ${SERVICE_PORT}:${SERVICE_PORT} &
    echo "http://127.0.0.1:${SERVICE_PORT}"

    NGINX is enabled, in order to send a request that goes through NGINX you can use port: 80
```

After executing the commands above, you can validate that it is accessible from outside the cluster by sending a curl request:

```shell
curl http://127.0.0.1:${SERVICE_PORT}
Hello from Rasa: 2.4.0
```

## Configuration

To configure the chart, use a YAML file that specifies the values for the chart parameters. In this README we'll call this file `rasa-values.yaml`. To create and use your `rasa-values.yaml` file:

1. Copy the default [values.yaml](values.yaml) value file to a new `rasa-values.yaml` file.
2. Set any custom parameters in `rasa-values.yaml`.
3. To apply your changes, upgrade the Rasa Helm chart with the new rasa-values.yaml file:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa
```

Use the same upgrade command above to apply any subsequent changes you make to your values.

### Exposing the rasa deployment to the public

By default the rasa service is available only within the Kubernetes cluster.
In order to make it accessible outside the cluster via a load balancer, update your `rasa-values.yaml` file with the following configuration:

```yaml
service:
    type: LoadBalancer
```

### Enabling TLS for NGINX (self-signed)

To use a self-signed TLS certificate for NGINX, update your `rasa-values.yaml` with the following NGINX TLS self-signed configuration:

```yaml
nginx:
  tls:
    enabled: true
    generateSelfSignedCert: true
```

### Note on Configuring Endpoints and Channel Credentials

To configure [endpoints](https://rasa.com/docs/rasa/arch-overview) and [channel credentials](https://rasa.com/docs/rasa/connectors/your-own-website) you can either specify them directly in rasa-values.yaml under `applicationSettings.endpoints` and `applicationSettings.credentials`, or you can [use Rasa X/Enterprise as a configuration endpoint](../../examples/rasa/README.md) if it is deployed in the same namespace as Rasa.

> It is not possible to combine the two options. If you choose to use Rasa X/Enterprise as a configuration endpoint, all other configuration of endpoints and credentials will be ignored.

### Options for loading models

To load a model for Rasa to serve, you can use a model server to pull models at regular intervals. If you're not using a model server, you'll need to configure [Loading an Initial Model](#loading-an-initial-model).

You can use Rasa X/Enterprise as a model server or use your own model server. To configure your own model server, follow the instructions on the [Rasa docs](https://rasa.com/docs/rasa/model-storage#load-model-from-server).

To enable a non-Rasa X model server, add this configuration information to your values:

```yaml
applicationSettings:
  # (...)
  endpoints:
    models:
      enabled: true
      url: http://my-server.com/models/default
      token: "auth-token"
      waitTimeBetweenPulls: 20
```

To use Rasa X/Enterprise as a model server, you don't need to specify the URL, since it is defined in the [section which configures the use of Rasa X/Enterprise](#connecting-rasa-with-rasa-xenterprise), so you can add this configuration to your values:

```yaml
applicationSettings:
  # (...)
  endpoints:
    models:
      enabled: true
      # User Rasa X/Enterprise token
      # If you use the rasa-x-helm chart you can set a token by using the `rasax.token` parameter
      # See: https://github.com/RasaHQ/rasa-x-helm/blob/main/charts/rasa-x/values.yaml#L22
      token: "rasaXToken"
      waitTimeBetweenPulls: 20
      useRasaXasModelServer:
        enabled: true
        # -- The tag of the model that should be pulled from Rasa X/Enterprise
        tag: "production"
```

#### Loading an initial model

The first time you install Rasa, you may not have a model server available yet, or you may want an lightweight model for testing the deployment. For this purpose, you can choose between training or downloading an initial model. By default, the Rasa chart downloads an example model from GitHub. To use this option, you don't have to change anything.

If you want to define an existing model to download from a URL you define instead, update your `rasa-values.yaml` with the URL according to the following configuration:

```yaml
applicationSettings:
  initialModel: "https://github.com/RasaHQ/rasa-x-demo/blob/master/models/model.tar.gz?raw=true"
```

Note that the URL for the initial model download has to point to a tar.gz file and must not require authentication.

If you want to train an initial model you can do this by setting the `applicationSettings.trainInitialModel` to `true`. It creates a init container that trains a model based on data located in the `/app` directory. If the `/app` directory is empty it creates a new project.
[Here](../../examples/rasa/train-model-helmfile.yaml) you can find an example that shows how to download data files from a git repository and train an initial model.

Visit [the docs](https://rasa.com/docs/rasa/setting-up-ci-cd) to learn more about how to train a model.

### Configuring Messaging Channels

You can enable messaging channels by specifying credentials in `rasa-values.yaml` in the same way you would define them in `credentials.yml` when running locally.

For example, to enable the REST channel, update your `rasa-values.yaml` file with the following channel configuration:

```yaml
applicationSettings:
  # (...)
  credentials:
    # (...)
    additionalChannelCredentials:
      rest:
```
(For the `rest` channel, no credentials are required. To learn more see: https://rasa.com/docs/rasa/connectors/your-own-website)

### Connecting Rasa with Rasa X/Enterprise

Any Rasa Open Source server can stream events to Rasa X/Enterprise using an [event broker](https://rasa.com/docs/rasa/event-brokers). Both Rasa and Rasa X/Enterprise will need to refer to the same event broker.

This means you have three options:

1. Configure Rasa to refer to the event broker started by Rasa X/Enterprise
2. Configure Rasa X/Enterprise to connect to the event broker started by Rasa
3. Configure both Rasa and Rasa X/Enterprise to connect to an external event broker (e.g. a managed Kafka instance)

For example, to configure Rasa to refer to the event broker started by Rasa X/Enterprise:

```yaml
applicationSettings:
  rasaX:
    enabled: true
    # here you have to put the URL to your Rasa Enterprise instance
    url: "http://example.com"
  endpoints:
    # In order to send messages to the same
    # event broker as Rasa X/Enterprise does we can pass
    # a custom configuration.
    eventBroker:
      type: "pika"
      url: "<exposed-rabbit-service-address>"
      username: "user"
      password: ${RABBITMQ_PASSWORD}
      port: 5672
      queues:
        - "rasa_production_events"
extraEnv:
  # The configuration for an event broker uses environment variables, thus
  # you have to pass extra environment variables that read values from
  # the rasa-x-rabbit secret.
  - name: "RABBITMQ_PASSWORD"
    valueFrom:
      secretKeyRef:
        name: rasa-x-rabbit
        key: rabbitmq-password
```

In the example above we assumed that the `rasa-x-rabbit` secret already exists in the cluster and contains the `rabbitmq-password` key.

If you're using the rasa-x-helm chart to deploy Rasa X/Enterprise you might have to update your values.yaml file, please visit [the docs](https://github.com/RasaHQ/rasa-x-helm/tree/rasa-x-2.0.0#enabling-an-external-rasa-oss-deployment) to learn more.

## Examples of usage

In the [`examples/rasa`](../../examples) directory you can find more detailed examples of configuration:

- [How to download a model via URL using a init container and load it into Rasa OSS](../../examples/rasa/download-model-helmfile.yaml)
- [How to use Rasa X/Enterprise deployed in the same namespace as a configuration endpoint](../../examples/rasa/README.md)
- [How to run the rasa chart on OpenShift](../../examples/rasa/openshift-helmfile.yaml)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Allow the Rasa Open Source Deployment to schedule using affinity rules # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| applicationSettings.cors | string | `"*"` | CORS for the passed origin. Default is * to allow all origins |
| applicationSettings.credentials.additionalChannelCredentials | object | `{}` | Additional channel credentials which should be used by Rasa to connect to various input channels # See: https://rasa.com/docs/rasa/messaging-and-voice-channels |
| applicationSettings.credentials.enabled | bool | `true` | Enable credentials configuration for channel connectors |
| applicationSettings.debugMode | bool | `false` | Enable debug mode |
| applicationSettings.enableAPI | bool | `true` | Start the web server API in addition to the input channel |
| applicationSettings.endpoints.action.endpointURL | string | `"/webhook"` | the URL which Rasa Open Source calls to execute custom actions |
| applicationSettings.endpoints.additionalEndpoints | object | `{}` | Additional endpoints |
| applicationSettings.endpoints.eventBroker.enabled | bool | `false` | Enable endpoint for Event Broker |
| applicationSettings.endpoints.eventBroker.password | string | `"${RABBITMQ_PASSWORD}"` | Password used for authentication |
| applicationSettings.endpoints.eventBroker.port | string | `"${RABBITMQ_PORT}"` | The port which an event broker is listening on |
| applicationSettings.endpoints.eventBroker.queues | list | `["rasa_production_events"]` | Send all messages to a given queue |
| applicationSettings.endpoints.eventBroker.type | string | `"pika"` | Event Broker |
| applicationSettings.endpoints.eventBroker.url | string | `"${RABBITMQ_HOST}"` | The url of an event broker |
| applicationSettings.endpoints.eventBroker.username | string | `"${RABBITMQ_USERNAME}"` | Username used for authentication |
| applicationSettings.endpoints.lockStore.db | string | `"1"` | The database in redis which Rasa uses to store the conversation locks |
| applicationSettings.endpoints.lockStore.enabled | bool | `false` | Enable endpoint for Lock Store |
| applicationSettings.endpoints.lockStore.password | string | `"${REDIS_PASSWORD}"` | Password used for authentication |
| applicationSettings.endpoints.lockStore.port | string | `"${REDIS_PORT}"` | The port which redis is running on |
| applicationSettings.endpoints.lockStore.type | string | `"redis"` | Lock Store type |
| applicationSettings.endpoints.lockStore.url | string | `"${REDIS_HOST}"` | The url of your redis instance |
| applicationSettings.endpoints.models.enabled | bool | `false` | Enable endpoint for a model server |
| applicationSettings.endpoints.models.token | string | `"token"` | Token used as a authentication token |
| applicationSettings.endpoints.models.url | string | `"http://my-server.com/models/default"` | URL address that models will be pulled from |
| applicationSettings.endpoints.models.useRasaXasModelServer.enabled | bool | `false` | Use Rasa X (Enterprise) as a model server |
| applicationSettings.endpoints.models.useRasaXasModelServer.tag | string | `"production"` | The model with a given tag that should be pulled from the model server |
| applicationSettings.endpoints.models.waitTimeBetweenPulls | int | `20` | Time in seconds how often the model server will be querying |
| applicationSettings.endpoints.trackerStore.db | string | `"${DB_DATABASE}"` | The path to the database to be used |
| applicationSettings.endpoints.trackerStore.dialect | string | `"postgresql"` | The dialect used to communicate with your SQL backend |
| applicationSettings.endpoints.trackerStore.enabled | bool | `true` | Enable endpoint for Tracker Store |
| applicationSettings.endpoints.trackerStore.login_db | string | `"${DB_DATABASE}"` | Create the database for the tracker store. If `false` the tracker store database must have been created previously. |
| applicationSettings.endpoints.trackerStore.password | string | `"${DB_PASSWORD}"` | The password which is used for authentication |
| applicationSettings.endpoints.trackerStore.port | string | `"${DB_PORT}"` | Port of your SQL server |
| applicationSettings.endpoints.trackerStore.type | string | `"sql"` | Tracker Store type |
| applicationSettings.endpoints.trackerStore.url | string | `"${DB_HOST}"` | URL of your SQL server |
| applicationSettings.endpoints.trackerStore.username | string | `"${DB_USER}"` | The username which is used for authentication |
| applicationSettings.initialModel | string | `"https://github.com/RasaHQ/rasa-x-demo/blob/master/models/model.tar.gz?raw=true"` | Initial model to download and load if a model server or remote storage is not used. It has to be a URL (without auth) that points to a tar.gz file |
| applicationSettings.port | int | `5005` | Port on which Rasa runs |
| applicationSettings.rasaX.enabled | bool | `false` | Run Rasa X / Enterprise server |
| applicationSettings.rasaX.token | string | `"rasaXToken"` | Token Rasa X / Enterprise accepts as authentication token from other Rasa services |
| applicationSettings.rasaX.url | string | `""` | URL to Rasa X / Enterprise, e.g. http://rasa-x.mydomain.com:5002 |
| applicationSettings.rasaX.useConfigEndpoint | bool | `false` | Rasa X / Enterprise endpoint URL from which to pull the runtime config |
| applicationSettings.scheme | string | `"http"` | Scheme by which the service are accessible |
| applicationSettings.telemetry.enabled | bool | `true` | Enable telemetry See: https://rasa.com/docs/rasa/telemetry/telemetry/ |
| applicationSettings.token | string | `"rasaToken"` | Token Rasa accepts as authentication token from other Rasa services |
| applicationSettings.trainInitialModel | bool | `false` | Train a model if an initial model is not defined. This parameter is ignored if the `applicationSettings.initialModel` is defined |
| args | list | `[]` | Override the default arguments for the container |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `20` | Upper limit for the number of pods that can be set by the autoscaler. It cannot be smaller than minReplicas. |
| autoscaling.minReplicas | int | `1` | Lower limit for the number of pods that can be set by the autoscaler |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Fraction of the requested CPU that should be utilized/used, e.g. 70 means that 70% of the requested CPU should be in use. |
| command | list | `[]` | Override the default command for the container |
| deploymentAnnotations | object | `{}` | Annotations to add to the rasa-oss deployment |
| deploymentLabels | object | `{}` | Labels to add to the rasa-oss deployment |
| duckling.external.enabled | bool | `false` | Determine if external URL is used |
| duckling.external.url | string | `""` | External URL to Duckling |
| duckling.install | bool | `false` | Install Duckling |
| extraArgs | list | `[]` | Add additional arguments to the default one |
| extraContainers | list | `[]` | Allow to specify additional containers for the Rasa Open Source Deployment |
| extraEnv | list | `[]` | Add extra environment variables |
| fullnameOverride | string | `""` | Override the full qualified app name |
| global.postgresql.existingSecret | string | `""` | existingSecret which should be used for the password instead of putting it in the values file |
| global.postgresql.postgresqlDatabase | string | `"rasa"` | postgresDatabase which should be used by Rasa |
| global.postgresql.postgresqlPassword | string | `"password"` | postgresqlPassword is the password which is used when the postgresqlUsername equals "postgres" |
| global.postgresql.postgresqlUsername | string | `"postgres"` | postgresqlUsername which should be used by Rasa to connect to Postgres |
| global.postgresql.servicePort | int | `5432` | servicePort which is used to expose postgres to the other components |
| global.redis | object | `{"password":"redis-password"}` | global settings of the redis subchart |
| global.redis.password | string | `"redis-password"` | password to use in case there no external secret was provided |
| image.name | string | `"rasa"` | Rasa Open Source image name to use (relative to `registry`) |
| image.pullPolicy | string | `"IfNotPresent"` | Rasa Open Source image pullPolicy |
| image.pullSecrets | list | `[]` | Rasa Open Source repository pullSecret # See https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod |
| image.repository | string | `""` | Override default registry + image.name for Rasa Open Source |
| image.tag | string | `"3.2.6"` | Rasa Open Source image tag to use |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Set to true to enable ingress |
| ingress.extraPaths | object | `{}` | Any additional arbitrary paths that may need to be added to the ingress under the main host |
| ingress.hostname | string | `"chart-example.local"` | Hostname used for the ingress |
| ingress.labels | object | `{}` | Labels to add to the ingress |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type # Ref: https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types |
| ingress.tls | list | `[]` | TLS configuration for ingress # See: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls |
| initContainers | list | `[]` | Allow to specify init containers for the Rasa Open Source Deployment # Ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| nameOverride | string | `""` | Override name of app |
| networkPolicy.denyAll | bool | `false` | Create a network policy that deny all traffic |
| networkPolicy.enabled | bool | `false` | Enable Kubernetes Network Policy |
| nginx.customConfiguration | object | `{}` | Custom configuration for Nginx sidecar |
| nginx.enabled | bool | `true` | Enabled Nginx as a sidecar container # If you use ingress-nginx as an ingress controller you should disable NGINX. |
| nginx.image.name | string | `"nginx"` | Image name to use |
| nginx.image.tag | string | `"1.20"` | Image tag to use |
| nginx.livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| nginx.port | int | `80` | Port number that Nginx listen on |
| nginx.readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| nginx.resources | object | `{}` | Resource requests and limits |
| nginx.securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| nginx.tls.certificateSecret | string | `""` | Use a secret with TLS certificates. The secret has to include `cert.pem` and `key.pem` keys |
| nginx.tls.enabled | bool | `false` | Enable TLS for Nginx sidecar |
| nginx.tls.generateSelfSignedCert | bool | `false` | Generate self-signed certificates |
| nginx.tls.port | int | `443` |  |
| nodeSelector | object | `{}` | Allow the Rasa Open Source Deployment to be scheduled on selected nodes # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector # Ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| podAnnotations | object | `{}` | Annotations to add to the rasa-oss's pod(s) |
| podLabels | object | `{}` | Labels to add to the rasa-oss's pod(s) |
| podSecurityContext | object | `{}` | Defines pod-level security attributes and common container settings # See: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| postgresql.external.enabled | bool | `false` | Determine if use an external PostgreSQL host |
| postgresql.external.host | string | `"external-postgresql"` | External PostgreSQL hostname # The host value is accessible via the `${DB_HOST}` environment variable |
| postgresql.install | bool | `true` | Install PostgreSQL |
| rabbitmq.auth.erlangCookie | string | `"erlangCookie"` | Erlang cookie |
| rabbitmq.auth.existingPasswordSecret | string | `""` | Existing secret with RabbitMQ credentials (must contain a value for `rabbitmq-password` key) |
| rabbitmq.auth.password | string | `"password"` | RabbitMQ application password |
| rabbitmq.auth.username | string | `"user"` | RabbitMQ application username |
| rabbitmq.external.enabled | bool | `false` | Determine if use an external RabbitMQ host |
| rabbitmq.external.host | string | `"external-rabbitmq"` | External RabbitMQ hostname # The host value is accessible via the `${RABBITMQ_HOST}` environment variable |
| rabbitmq.install | bool | `false` | Install RabbitMQ |
| rasa-action-server.external.enabled | bool | `false` | Determine if external URL is used |
| rasa-action-server.external.url | string | `""` | External URL to Rasa Action Server |
| rasa-action-server.install | bool | `false` | Install Rasa Action Server |
| readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| redis.auth.password | string | `"redis-password"` | Redis(TM) password |
| redis.external.enabled | bool | `false` | Determine if use an external Redis host |
| redis.external.host | string | `"external-redis"` | External Redis hostname # The host value is accessible via the `${REDIS_HOST}` environment variable |
| redis.install | bool | `false` | Install Redis(TM) |
| redis.replica.replicaCount | int | `0` | Number of Redis(TM) replicas to deploy |
| registry | string | `"docker.io/rasa"` | Registry to use for all Rasa images (default docker.io) # DockerHub - use docker.io/rasa |
| replicaCount | int | `1` | Specify the number of Rasa Open Source replicas |
| resources | object | `{}` | Resource requests and limits |
| securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.externalTrafficPolicy | string | `"Cluster"` | Enable client source IP preservation # Ref: http://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip |
| service.loadBalancerIP | string | `nil` | Exposes the Service externally using a cloud provider's load balancer # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer |
| service.nodePort | string | `nil` | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#nodeport |
| service.port | int | `5005` | Set port of rasa service (Kubernetes >= 1.15) |
| service.type | string | `"ClusterIP"` | Set type of rasa service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Allow the deployment to perform a rolling update # ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | list | `[]` | Tolerations for pod assignment # Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| volumeMounts | list | `[]` | Specify additional volumes to mount in the rasa-oss container |
| volumes | list | `[]` | Specify additional volumes to mount in the rasa-oss container # Ref: https://kubernetes.io/docs/concepts/storage/volumes/ |
