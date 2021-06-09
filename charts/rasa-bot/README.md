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

The rasa-bot deploy Rasa Open Source Server with loaded a model that is defined by the `applicationSettings.defaultModel` value. Below you can find examples of how to configure your deployment or use more advanced configurations such as integration with Rasa Enterprise.

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

1. Copy the default [values.yaml](values.yaml) value file. From now on we'll use the `rasa-values.yaml` values file.
2. Set custom parameters in the rasa-values.yaml
3. Upgrade the Rasa Bot Helm chart with the new rasa-values.yaml file:

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

### Enabling Rasa X / Enterprise

To use Rasa Bot along with Rasa Enterprise update `rasa-values.yaml` with the following configuration:

```yaml
applicationSettings:
  enterprise:
    enabled: true
      # here you have to put URL to Rasa Enterprise
    url: "http://rasa-x-rasa-x:5002"
  endpoints:
    # In order to send messages to the same
    # event broker as Rasa Enterprise uses we can pass
    # a custom configuration.
    eventBroker:
      customConfiguration:
        type: "pika"
        url: "rasa-x-rabbit"
        username: "user"
        password: ${RABBITMQ_PASSWORD}
        port: 5672
        queues:
          - ${RABBITMQ_QUEUE}
    # Use Rasa X as a model server
    models:
      useRasaXasModelServer:
        enabled: true
extraEnv:
  # In the configuration for an event broker are used environment variables, thus
  # you have to pass extra environment variables that read values from
  # the rasa-x deployment in the same namespace
  - name: "RABBITMQ_QUEUE"
    value: rasa_production_events
  - name: "RABBITMQ_PASSWORD"
    valueFrom:
      secretKeyRef:
        name: rasa-x-rabbit
        key: rabbitmq-password
```

In the example above we assumed that Rasa Enterprise is deployed with `rasa-x` release name in the same namespaces as the rasa bot.

```shell
helm upgrade -f rasa-values.yaml <RELEASE_NAME> rasa/rasa-bot
```

In addition to Rasa Bot configuration, you have to update Rasa Enterprise configuration as well, please visit the docs to learn more.

### Enabling Rasa Enterprise (used as a configuration endpoint)

It's possible to use Rasa Enterprise as a configuration endpoint, in a such care runtime configuration for Rasa OSS will be pulled from Rasa Enterprise.

An example below shows how to configure the Rasa Bot to use Rasa Enterprise which are deployed in the same namespace.

Update `rasa-values.yaml` with the following configuration:

```yaml
applicationSettings:
  enterprise:
    enabled: true
    url: "http://rasa-x-rasa-x:5002"
    # Define if a runtime configuration should be pulled
    # from Rasa Enterprise
    useConfigEndpoint: true
```

Below we can see an example of a runtime configuration that is pulled from Rasa Enterprise:

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

The configuration uses environment variables, that's you have to add extra environment variables to the rasa bot. Full `rasa-values.yaml` should look like this:

```yaml
applicationSettings:
  enterprise:
    enabled: true
    url: "http://rasa-x-rasa-x:5002"
    # Define if a runtime configuration should be pulled
    # from Rasa Enterprise
    useConfigEndpoint: true

## Don't install additional components.
## The components installed by Rasa Enterprise are used instead.
postgresql:
  install: false
redis:
  install: false
rabbitmq:
  install: false

## Extra environment variables used in the Rasa Enterprise configuration
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
| affinity | object | `{}` | Allow the Model Runner Deployment to schedule using affinity rules |
| applicationSettings.cors | string | `"*"` | CORS for the passed origin. Default is * to whitelist all origins |
| applicationSettings.credentials.additionalChannelCredentials | object | `{}` | Additional channel credentials which should be used by Rasa to connect to various input channels |
| applicationSettings.credentials.enabled | bool | `false` | Enable credentials configuration for channel connectors |
| applicationSettings.debugMode | bool | `false` | Enable debug mode |
| applicationSettings.defaultModel | string | `"https://github.com/RasaHQ/rasa-x-demo/blob/master/models/model.tar.gz?raw=true"` | Default model loaded if a model server or a remote storage is not used. It has to be a URL that points to a tag.gz file. |
| applicationSettings.endpoints.action.endpointURL | string | `"/webhook"` | the URL which Rasa Open Source calls to execute custom actions |
| applicationSettings.endpoints.additionalEndpoints | object | `{}` | Additional endpoints |
| applicationSettings.endpoints.eventBroker.customConfiguration | object | `{}` | Custom configuration for Event Broker |
| applicationSettings.endpoints.eventBroker.enabled | bool | `true` | Enable endpoint for Event Broker |
| applicationSettings.endpoints.eventBroker.queue | string | `"rasa_events"` | Send all messages to a given queue |
| applicationSettings.endpoints.lockStore.customConfiguration | object | `{}` | Custom configuration for Lock Store |
| applicationSettings.endpoints.lockStore.database | string | `"1"` | The database in redis which Rasa uses to store the conversation locks |
| applicationSettings.endpoints.lockStore.enabled | bool | `true` | Enable endpoint for Lock Store |
| applicationSettings.endpoints.models.enabled | bool | `false` | Enable endpoint for a model server |
| applicationSettings.endpoints.models.token | string | `"token"` | Token used as a authentication token |
| applicationSettings.endpoints.models.url | string | `"http://my-server.com/models/default"` | URL address that models will be pulled from |
| applicationSettings.endpoints.models.useRasaXasModelServer.enabled | bool | `false` | Use Rasa X (Enterprise) as a model server |
| applicationSettings.endpoints.models.useRasaXasModelServer.tag | string | `"production"` | The model with a given tag that should be pulled from the model server |
| applicationSettings.endpoints.models.waitTimeBetweenPulls | int | `20` | Time in seconds how often the the model server will be querying |
| applicationSettings.endpoints.trackerStore.customConfiguration | object | `{}` | Custom configuration for Tracker Store |
| applicationSettings.endpoints.trackerStore.enabled | bool | `true` | Enable endpoint for Tracker Store |
| applicationSettings.endpoints.trackerStore.useLoginDatabase | bool | `true` | Create the database for the tracker store. If `false` the tracker store database must have been created previously. |
| applicationSettings.enterprise.enabled | bool | `false` | Run Rasa X (Enterprise) server |
| applicationSettings.enterprise.production | bool | `true` | Run Rasa X (Enterprise) in a production environment |
| applicationSettings.enterprise.token | string | `"rasaXToken"` | Token Rasa Enterprise accepts as authentication token from other Rasa services |
| applicationSettings.enterprise.url | string | `""` | URL to Rasa X (Enterprise), e.g. http://rasa-x.mydomain.com:5002 |
| applicationSettings.enterprise.useConfigEndpoint | bool | `false` | Rasa X (Enterprise) endpoint URL from which to pull the runtime config |
| applicationSettings.port | int | `5005` | Port on which Rasa runs |
| applicationSettings.scheme | string | `"http"` | Scheme by which the service are accessible |
| applicationSettings.telemetry.enabled | bool | `false` | Enable telemetry See: https://rasa.com/docs/rasa/telemetry/telemetry/ |
| applicationSettings.token | string | `"rasaToken"` | Token Rasa accepts as authentication token from other Rasa services |
| args | list | `[]` | Override the default arguments for the container |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `20` | Upper limit for the number of pods that can be set by the autoscaler. It cannot be smaller than minReplicas. |
| autoscaling.minReplicas | int | `1` | Lower limit for the number of pods that can be set by the autoscaler |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Fraction of the requested CPU that should be utilized/used, e.g. 70 means that 70% of the requested CPU should be in use. |
| command | list | `[]` | Override the default command for the container |
| deploymentAnnotations | object | `{}` | Annotations to add to the model-runner deployment |
| deploymentLabels | object | `{}` | Labels to add to the model-runner deployment |
| extraArgs | list | `[]` | Add additional arguments to the default one |
| extraContainers | list | `[]` | Allow to specify additional containers for the Model Runner Deployment |
| extraEnv | list | `[]` | Add extra environment variables |
| fullnameOverride | string | `nil` | Override the full qualified app name |
| global.postgresql.existingSecret | string | `""` | existingSecret which should be used for the password instead of putting it in the values file |
| global.postgresql.postgresqlDatabase | string | `"rasa"` | postgresDatabase which should be used by Rasa |
| global.postgresql.postgresqlPassword | string | `"password"` | postgresqlPassword is the password which is used when the postgresqlUsername equals "postgres" |
| global.postgresql.postgresqlUsername | string | `"postgres"` | postgresqlUsername which should be used by Rasa to connect to Postgres |
| global.postgresql.servicePort | int | `5432` | servicePort which is used to expose postgres to the other components |
| global.redis | object | `{"password":"redis-password"}` | global settings of the redis subchart |
| global.redis.password | string | `"redis-password"` | password to use in case there no external secret was provided |
| image.name | string | `"rasa"` | Model Runner image name to use (relative to `registry`) |
| image.pullPolicy | string | `"IfNotPresent"` | Model Runner image pullPolicy |
| image.pullSecrets | list | `[]` | Model Runner repository pullSecret |
| image.repository | string | `nil` | Override default registry + image.name for Model Runner |
| image.tag | string | `"2.4.0"` | Model Runner image tag to use |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Set to true to enable ingress |
| ingress.extraPaths | object | `{}` | Any additional arbitrary paths that may need to be added to the ingress under the main host |
| ingress.hostname | string | `"chart-example.local"` | Hostname used for the ingress |
| ingress.labels | object | `{}` | Labels to add to the ingress |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type |
| ingress.tls | list | `[]` | TLS configuration for ingress |
| initContainers | list | `[]` | Allow to specify init containers for the Model Runner Deployment |
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
| nodeSelector | object | `{}` | Allow the Model Runner Deployment to be scheduled on selected nodes |
| podAnnotations | object | `{}` | Annotations to add to the model-runner's pod(s) |
| podLabels | object | `{}` | Labels to add to the model-runner's pod(s) |
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
| replicaCount | int | `1` | Specify the number of model runner replicas |
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
| volumeMounts | list | `[]` | Specify additional volumes to mount in the model-runner container |
| volumes | list | `[]` | Specify additional volumes to mount in the model-runner container |
