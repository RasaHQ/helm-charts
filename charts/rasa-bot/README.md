# rasa-bot

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.0](https://img.shields.io/badge/AppVersion-2.5.0-informational?style=flat-square)

Rasa Bot (Rasa Open Source Server) is an open source machine learning framework for automated text and voice-based conversations. Understand messages, hold conversations, and connect to messaging channels and APIs.

See [Rasa website](https://rasa.com/docs/rasa/) to learn more.

## How to use Rasa Helm repository

You need to add this repository to your Helm repositories:

```shell
helm repo add rasa https://helm.rasa.com
helm repo update
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../rasa-action-server | rasa-action-server | 0.38.0 |
| file://../rasa-common | rasa-common | 1.x.x |
| https://charts.bitnami.com/bitnami | postgresql | ~10.3.18 |
| https://charts.bitnami.com/bitnami | rabbitmq | ~8.12.1 |
| https://charts.bitnami.com/bitnami | redis | ~14.1.0 |

## Quick start

The rasa-bot deploy Rasa Open Source Server which will create a initial project and train model, the trained model is loaded.

Below you can find examples of how to configure your deployment or use more advanced configurations such as integration with Rasa X / Enterprise.

Default components that will be installed along with the rasa-bot:

* RabbitMQ used as backend for [Event Broker](https://rasa.com/docs/rasa/event-brokers)
* PostgreSQL used as backend for [Tracker Store](https://rasa.com/docs/rasa/tracker-stores)
* Redis used as backend for [Lock Store](https://rasa.com/docs/rasa/lock-stores)

### Installing the Rasa Bot Chart

To install the chart with the release name `<RELEASE_NAME>` run the following command:

```bash
helm install --name <RELEASE_NAME> rasa/rasa-bot
```

After the rasa-bot was deployed successfully you should see additional information on how to connect to Rasa OSS, e.g:

```shell
To access Rasa Bot from outside of the cluster, follow the steps below:

1. Get the Rasa URL by running these commands:

    export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services <RELEASE_NAME>)
    kubectl port-forward --namespace default svc/<RELEASE_NAME> ${SERVICE_PORT}:${SERVICE_PORT} &
    echo "http://127.0.0.1:${SERVICE_PORT}"

    NGINX is enabled, in order to send a request that goes through NGINX you can use port: 80
```

After executing the commands above we can send a request to Rasa Bot

```shell
curl http://127.0.0.1:${SERVICE_PORT}
Hello from Rasa: 2.4.0
```

## Custom configuration

As a best practice, a YAML file that specifies the values for the chart parameters should be provided to configure the chart:

1. Copy the default [values.yaml](values.yaml) value file to `rasa-values.yaml`. From now on we'll use the `rasa-values.yaml` values file.
2. Set custom parameters in the rasa-values.yaml
3. Upgrade the Rasa Bot Helm chart with the new rasa-values.yaml file:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

### Downloading a initial model

By default, the rasa-bot chart creates an initial project and train a model, but it's also possible to define an existing model to download. In a such scenario, a model is downloaded from a defined URL.

Update your `rasa-values.yaml` with the following configuration:

```yaml
applicationSettings:
  # (...)
  # Initial model to download and load if a model server or remote storage is not used.
  # It has to be a URL (without auth) that points to a tag.gz file.
  initialModel: "https://github.com/RasaHQ/rasa-x-demo/blob/master/models/model.tar.gz?raw=true"
```

then upgrade your Rasa Bot deployment:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

### Enabling REST Channel

The `RestInput and CallbackInput` channels can be used for custom integrations. They provide a URL where you can post messages and either receive response messages directly, or asynchronously via a webhook.

To learn more see: https://rasa.com/docs/rasa/connectors/your-own-website/#rest-channels

By default the rasa-bot run without enabled REST channel, update your rasa-values.yaml file with the following REST channel configuration:

```yaml
applicationSettings:
  # (...)
  credentials:
    # (...)
    additionalChannelCredentials:
      rest:
```

then upgrade your Rasa Bot deployment:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

### Enabling TLS for NGINX (self-signed)

Update your `rasa-values.yaml` with the following NGINX TLS self-singed configuration:

```yaml
nginx:
  tls:
    enabled: true
    generateSelfSignedCert: true
```

then upgrade your Rasa Bot deployment:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

### Exposing the rasa-bot deployment to the public

By default the rasa-bot service is available within a Kubernetes cluster, in order to expose the rasa-bot service to the public update your `rasa-values.yaml` file with the following configuration:

```yaml
service:
    type: LoadBalancer
```

then upgrade your Rasa Bot deployment:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

### Enabling External Rasa X / Enterprise

To use Rasa Bot along with Rasa X / Enterprise update `rasa-values.yaml` with the following configuration:

```yaml
applicationSettings:
  rasaX:
    enabled: true
    # here you have to put URL to Rasa Enterprise
    url: "http://rasa-x-rasa-x:5002"
  endpoints:
    # In order to send messages to the same
    # event broker as Rasa X / Enterprise does we can pass
    # a custom configuration.
    eventBroker:
      type: "pika"
      url: "rasa-x-rabbit"
      username: "user"
      password: ${RABBITMQ_PASSWORD}
      port: 5672
      queues:
        - "rasa_production_events"
    # Use Rasa X as a model server
    models:
      useRasaXasModelServer:
        enabled: true
extraEnv:
  # In the configuration for an event broker are used environment variables, thus
  # you have to pass extra environment variables that read values from
  # the rasa-x-rabbit secret.
  - name: "RABBITMQ_PASSWORD"
    valueFrom:
      secretKeyRef:
        name: rasa-x-rabbit
        key: rabbitmq-password
```

In the example above we assumed that the `rasa-x-rabbit` secret already exists and contains the `rabbitmq-password` key.

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

In addition to Rasa Bot configuration, you have to update Rasa X / Enterprise configuration as well, please visit [the docs](https://link-to-the-docs) to learn more.

### Enabling Rasa X / Enterprise (within the same cluster)

It's possible to use Rasa X / Enterprise as a configuration endpoint, in a such case runtime configuration for Rasa OSS will be pulled from Rasa X / Enterprise.

An example below shows how to configure the Rasa Bot to use Rasa X / Enterprise which is deployed in the same namespace.

Update `rasa-values.yaml` with the following configuration:

```yaml
applicationSettings:
  rasaX:
    enabled: true
    url: "http://rasa-x-rasa-x:5002"
    # Define if a runtime configuration should be pulled
    # from Rasa X / Enterprise
    useConfigEndpoint: true
```

Below we can see an example of a runtime configuration that is pulled from Rasa X / Enterprise:

```yaml
models:
  url: ${RASA_MODEL_SERVER}
  token: ${RASA_X_TOKEN}
  wait_time_between_pulls: 10
tracker_store:
  type: sql
  dialect: "postgresql"
  url: rasa-x-postgresql
  port: 5432
  username: postgres
  password: ${DB_PASSWORD}
  db: ${DB_DATABASE}
  login_db: rasa
event_broker:
  type: "pika"
  url: "rasa-x-rabbit"
  username: "user"
  password: ${RABBITMQ_PASSWORD}
  port: 5672
  queues:
  - ${RABBITMQ_QUEUE}

action_endpoint:
  url: "http://rasa-bot-rasa-action-server/webhook"
  token:  ""
lock_store:
  type: "redis"
  url: rasa-x-redis-master
  port: 6379
  password: ${REDIS_PASSWORD}
  db: 1
cache:
  type: "redis"
  url: rasa-x-redis-master
  port: 6379
  password: ${REDIS_PASSWORD}
  db: 2
  key_prefix: "rasax_cache"
```

The configuration uses environment variables, that's why you have to add extra environment variables to the rasa bot. Full `rasa-values.yaml` should look like this:

```yaml
applicationSettings:
  rasaX:
    enabled: true
    url: "http://rasa-x-rasa-x:5002"
    # Define if a runtime configuration should be pulled
    # from Rasa X / Enterprise
    useConfigEndpoint: true

## Don't install additional components.
## The components installed by Rasa X / Enterprise are used instead.
postgresql:
  install: false
redis:
  install: false
rabbitmq:
  install: false

## Extra environment variables used in the Rasa X / Enterprise configuration
extraEnv:
 - name: RASA_MODEL_SERVER
   value: http://rasa-x-rasa-x:5002/api/projects/default/models/tags/production
 - name: RASA_X_TOKEN
   valueFrom:
     secretKeyRef:
       name: rasa-x-rasa
       key: "rasaXToken"
 - name: "DB_PASSWORD"
   valueFrom:
     secretKeyRef:
       name: rasa-x-postgresql
       key: postgresql-password
 - name: "DB_DATABASE"
   value: "rasa_production"
 - name: "REDIS_PASSWORD"
   valueFrom:
     secretKeyRef:
       name: rasa-x-redis
       key: redis-password
 - name: "RABBITMQ_QUEUE"
   value: rasa_production_events
 - name: "RABBITMQ_PASSWORD"
   valueFrom:
     secretKeyRef:
       name: rasa-x-rabbit
       key: rabbitmq-password

```

then upgrade your Rasa Bot deployment:

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Allow the Rasa Open Source Deployment to schedule using affinity rules |
| applicationSettings.cors | string | `"*"` | CORS for the passed origin. Default is * to whitelist all origins |
| applicationSettings.credentials.additionalChannelCredentials | object | `{}` | Additional channel credentials which should be used by Rasa to connect to various input channels |
| applicationSettings.credentials.enabled | bool | `false` | Enable credentials configuration for channel connectors |
| applicationSettings.debugMode | bool | `false` | Enable debug mode |
| applicationSettings.endpoints.action.endpointURL | string | `"/webhook"` | the URL which Rasa Open Source calls to execute custom actions |
| applicationSettings.endpoints.additionalEndpoints | object | `{}` | Additional endpoints |
| applicationSettings.endpoints.eventBroker.enabled | bool | `true` | Enable endpoint for Event Broker |
| applicationSettings.endpoints.eventBroker.password | string | `"${RABBITMQ_PASSWORD}"` | Password used for authentication |
| applicationSettings.endpoints.eventBroker.port | string | `"${RABBITMQ_PORT}"` | The port which an event broker is listening on |
| applicationSettings.endpoints.eventBroker.queues | list | `["rasa_production_events"]` | Send all messages to a given queue |
| applicationSettings.endpoints.eventBroker.type | string | `"pika"` | Event Broker |
| applicationSettings.endpoints.eventBroker.url | string | `"${RABBITMQ_HOST}"` | The url of an event broker |
| applicationSettings.endpoints.eventBroker.username | string | `"${RABBITMQ_USERNAME}"` | Username used for authentication |
| applicationSettings.endpoints.lockStore.db | string | `"1"` | The database in redis which Rasa uses to store the conversation locks |
| applicationSettings.endpoints.lockStore.enabled | bool | `true` | Enable endpoint for Lock Store |
| applicationSettings.endpoints.lockStore.password | string | `"${REDIS_PASSWORD}"` | Password used for authentication |
| applicationSettings.endpoints.lockStore.port | string | `"${REDIS_PORT}"` | The port which redis is running on |
| applicationSettings.endpoints.lockStore.type | string | `"redis"` | Lock Store type |
| applicationSettings.endpoints.lockStore.url | string | `"${REDIS_HOST}"` | The url of your redis instance |
| applicationSettings.endpoints.models.enabled | bool | `false` | Enable endpoint for a model server |
| applicationSettings.endpoints.models.token | string | `"token"` | Token used as a authentication token |
| applicationSettings.endpoints.models.url | string | `"http://my-server.com/models/default"` | URL address that models will be pulled from |
| applicationSettings.endpoints.models.useRasaXasModelServer.enabled | bool | `false` | Use Rasa X (Enterprise) as a model server |
| applicationSettings.endpoints.models.useRasaXasModelServer.tag | string | `"production"` | The model with a given tag that should be pulled from the model server |
| applicationSettings.endpoints.models.waitTimeBetweenPulls | int | `20` | Time in seconds how often the the model server will be querying |
| applicationSettings.endpoints.trackerStore.db | string | `"${DB_DATABASE}"` | The path to the database to be used |
| applicationSettings.endpoints.trackerStore.dialect | string | `"postgresql"` | The dialect used to communicate with your SQL backend |
| applicationSettings.endpoints.trackerStore.enabled | bool | `true` | Enable endpoint for Tracker Store |
| applicationSettings.endpoints.trackerStore.login_db | string | `"${DB_DATABASE}"` | Create the database for the tracker store. If `false` the tracker store database must have been created previously. |
| applicationSettings.endpoints.trackerStore.password | string | `"${DB_PASSWORD}"` | The password which is used for authentication |
| applicationSettings.endpoints.trackerStore.port | string | `"${DB_PORT}"` | Port of your SQL server |
| applicationSettings.endpoints.trackerStore.type | string | `"sql"` | Tracker Store type |
| applicationSettings.endpoints.trackerStore.url | string | `"${DB_HOST}"` | URL of your SQL server |
| applicationSettings.endpoints.trackerStore.username | string | `"${DB_USER}"` | The username which is used for authentication |
| applicationSettings.initialModel | string | `""` | Initial model to download and load if a model server or remote storage is not used. It has to be a URL (without auth) that points to a tag.gz file e.g. https://github.com/RasaHQ/rasa-x-demo/blob/master/models/model.tar.gz?raw=true |
| applicationSettings.port | int | `5005` | Port on which Rasa runs |
| applicationSettings.rasaX.enabled | bool | `false` | Run Rasa X / Enterprise server |
| applicationSettings.rasaX.production | bool | `true` | Run Rasa X / Enterprise in a production environment |
| applicationSettings.rasaX.token | string | `"rasaXToken"` | Token Rasa X / Enterprise accepts as authentication token from other Rasa services |
| applicationSettings.rasaX.url | string | `""` | URL to Rasa X / Enterprise, e.g. http://rasa-x.mydomain.com:5002 |
| applicationSettings.rasaX.useConfigEndpoint | bool | `false` | Rasa X / Enterprise endpoint URL from which to pull the runtime config |
| applicationSettings.scheme | string | `"http"` | Scheme by which the service are accessible |
| applicationSettings.telemetry.enabled | bool | `false` | Enable telemetry See: https://rasa.com/docs/rasa/telemetry/telemetry/ |
| applicationSettings.token | string | `"rasaToken"` | Token Rasa accepts as authentication token from other Rasa services |
| applicationSettings.trainInitialModel | bool | `true` | Train a model if a initial model is not defined. This parameter is ignored if the `appplication.Settings.initialModel` is defined. |
| args | list | `[]` | Override the default arguments for the container |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `20` | Upper limit for the number of pods that can be set by the autoscaler. It cannot be smaller than minReplicas. |
| autoscaling.minReplicas | int | `1` | Lower limit for the number of pods that can be set by the autoscaler |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Fraction of the requested CPU that should be utilized/used, e.g. 70 means that 70% of the requested CPU should be in use. |
| command | list | `[]` | Override the default command for the container |
| deploymentAnnotations | object | `{}` | Annotations to add to the rasa-oss deployment |
| deploymentLabels | object | `{}` | Labels to add to the rasa-oss deployment |
| extraArgs | list | `[]` | Add additional arguments to the default one |
| extraContainers | list | `[]` | Allow to specify additional containers for the Rasa Open Source Deployment |
| extraEnv | list | `[]` | Add extra environment variables |
| fullnameOverride | string | `nil` | Override the full qualified app name |
| global.postgresql.existingSecret | string | `""` | existingSecret which should be used for the password instead of putting it in the values file |
| global.postgresql.postgresqlDatabase | string | `"rasa"` | postgresDatabase which should be used by Rasa |
| global.postgresql.postgresqlPassword | string | `"password"` | postgresqlPassword is the password which is used when the postgresqlUsername equals "postgres" |
| global.postgresql.postgresqlUsername | string | `"postgres"` | postgresqlUsername which should be used by Rasa to connect to Postgres |
| global.postgresql.servicePort | int | `5432` | servicePort which is used to expose postgres to the other components |
| global.redis | object | `{"password":"redis-password"}` | global settings of the redis subchart |
| global.redis.password | string | `"redis-password"` | password to use in case there no external secret was provided |
| image.name | string | `"rasa"` | Rasa Open Source image name to use (relative to `registry`) |
| image.pullPolicy | string | `"IfNotPresent"` | Rasa Open Source image pullPolicy |
| image.pullSecrets | list | `[]` | Rasa Open Source repository pullSecret |
| image.repository | string | `nil` | Override default registry + image.name for Rasa Open Source |
| image.tag | string | `"2.4.0"` | Rasa Open Source image tag to use |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Set to true to enable ingress |
| ingress.extraPaths | object | `{}` | Any additional arbitrary paths that may need to be added to the ingress under the main host |
| ingress.hostname | string | `"chart-example.local"` | Hostname used for the ingress |
| ingress.labels | object | `{}` | Labels to add to the ingress |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type |
| ingress.tls | list | `[]` | TLS configuration for ingress |
| initContainers | list | `[]` | Allow to specify init containers for the Rasa Open Source Deployment |
| livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings |
| nameOverride | string | `nil` | Override name of app |
| networkPolicy.denyAll | bool | `false` | Create a network policy that deny all traffic |
| networkPolicy.enabled | bool | `false` | Enable Kubernetes Network Policy |
| nginx.customConfiguration | object | `{}` | Custom configuration for Nginx sidecar |
| nginx.enabled | bool | `true` | Enabled Nginx as a sidecar container |
| nginx.image.name | string | `"nginx"` | Image name to use |
| nginx.image.tag | string | `"1.19"` | Image tag to use |
| nginx.livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings |
| nginx.port | int | `80` | Port number that Nginx listen on |
| nginx.readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings |
| nginx.resources | object | `{}` | Resource requests and limits |
| nginx.securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| nginx.tls.certificateSecret | string | `""` | Use a secret with TLS certificates. The secret has to include `cert.pem` and `key.pem` keys |
| nginx.tls.enabled | bool | `false` | Enable TLS for Nginx sidecar |
| nginx.tls.generateSelfSignedCert | bool | `false` | Generate self-signed certificates |
| nginx.tls.port | int | `443` |  |
| nodeSelector | object | `{}` | Allow the Rasa Open Source Deployment to be scheduled on selected nodes |
| podAnnotations | object | `{}` | Annotations to add to the rasa-oss's pod(s) |
| podLabels | object | `{}` | Labels to add to the rasa-oss's pod(s) |
| podSecurityContext | object | `{}` | Defines pod-level security attributes and common container settings |
| postgresql.external.enabled | bool | `false` | Determine if use an external PostgreSQL host |
| postgresql.external.host | string | `"external-postgresql"` | External PostgreSQL hostname |
| postgresql.install | bool | `true` | Install PostgreSQL |
| rabbitmq.auth.erlangCookie | string | `"erlangCookie"` | Erlang cookie |
| rabbitmq.auth.existingPasswordSecret | string | `""` | Existing secret with RabbitMQ credentials (must contain a value for `rabbitmq-password` key) |
| rabbitmq.auth.password | string | `"password"` | RabbitMQ application password |
| rabbitmq.auth.username | string | `"user"` | RabbitMQ application username |
| rabbitmq.external.enabled | bool | `false` | Determine if use an external RabbitMQ host |
| rabbitmq.external.host | string | `"external-rabbitmq"` | External RabbitMQ hostname |
| rabbitmq.install | bool | `true` | Install RabbitMQ |
| rasa-action-server.external.enabled | bool | `false` | Determine if external URL is used |
| rasa-action-server.external.url | string | `""` | External URL to Rasa Action Server |
| rasa-action-server.install | bool | `true` | Install Rasa Action Server |
| readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings |
| redis.auth.password | string | `"redis-password"` | Redis(TM) password |
| redis.external.enabled | bool | `false` | Determine if use an external Redis host |
| redis.external.host | string | `"external-redis"` | External Redis hostname |
| redis.install | bool | `true` | Install Redis(TM) |
| redis.replica.replicaCount | int | `0` | Number of Redis(TM) replicas to deploy |
| registry | string | `"docker.io/rasa"` | Registry to use for all Rasa images (default docker.io) |
| replicaCount | int | `1` | Specify the number of Rasa Open Source replicas |
| resources | object | `{}` | Resource requests and limits |
| securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.externalTrafficPolicy | string | `"Cluster"` | Enable client source IP preservation |
| service.loadBalancerIP | string | `nil` | Exposes the Service externally using a cloud provider's load balancer |
| service.nodePort | string | `nil` | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types |
| service.port | int | `5005` | Set port of rasa-bot service (Kubernetes >= 1.15) |
| service.type | string | `"ClusterIP"` | Set type of rasa-bot service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Allow the deployment to perform a rolling update |
| tolerations | list | `[]` | Tolerations for pod assignment |
| volumeMounts | list | `[]` | Specify additional volumes to mount in the rasa-oss container |
| volumes | list | `[]` | Specify additional volumes to mount in the rasa-oss container |
