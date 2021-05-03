# rasa-bot

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.0](https://img.shields.io/badge/AppVersion-2.5.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Rasa | contact@rasa.com |  |

## Source Code

* <https://github.com/RasaHQ/charts/rasa-bot>
* <https://rasa.com/>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../rasa-action-server | rasa-action-server | 0.38.0 |
| file://../rasa-common | rasa-common | 1.x.x |
| https://charts.bitnami.com/bitnami | postgresql | ~10.3.18 |
| https://charts.bitnami.com/bitnami | rabbitmq | ~8.12.1 |
| https://charts.bitnami.com/bitnami | redis | ~14.1.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Allow the Model Runner Deployment to schedule using affinity rules |
| applicationSettings.credentials.additionalChannelCredentials | object | `{}` | Additional channel credentials which should be used by Rasa to connect to various input channels |
| applicationSettings.credentials.enabled | bool | `true` | Enable credentials configuration for channel connectors |
| applicationSettings.debugMode | bool | `false` | Enable debug mode |
| applicationSettings.endpoints.action.endpointURL | string | `"/webhook"` | the URL which Rasa Open Source calls to execute custom actions |
| applicationSettings.endpoints.additionalEndpoints | object | `{}` | Additional endpoints |
| applicationSettings.endpoints.eventBroker.customConfiguration | object | `{}` | Custom configuration for Event Broker |
| applicationSettings.endpoints.eventBroker.enabled | bool | `true` | Enable endpoint for Event Broker |
| applicationSettings.endpoints.eventBroker.queue | string | `"rasa_events"` | Send all messages to a given queue |
| applicationSettings.endpoints.lockStore.customConfiguration | object | `{}` | Custom configuration for Lock Store |
| applicationSettings.endpoints.lockStore.database | string | `"1"` | The database in redis which Rasa uses to store the conversation locks |
| applicationSettings.endpoints.lockStore.enabled | bool | `true` | Enable endpoint for Lock Store |
| applicationSettings.endpoints.models.enabled | bool | `false` | Enable endpoint for a model server |
| applicationSettings.endpoints.models.token | string | `"token"` | Token used authentication token |
| applicationSettings.endpoints.models.url | string | `"http://my-server.com/models/default"` | URL address that models will be pulled from |
| applicationSettings.endpoints.models.waitTimeBetweenPulls | int | `100` | Time in seconds how often the URL will be querying |
| applicationSettings.endpoints.trackerStore.customConfiguration | object | `{}` | Custom configuration for Tracker Store |
| applicationSettings.endpoints.trackerStore.enabled | bool | `true` | Enable endpoint for Tracker Store |
| applicationSettings.endpoints.trackerStore.useLoginDatabase | bool | `true` | Create the database for the tracker store. If `false` the tracker store database must have been created previously. |
| applicationSettings.enterprise.configEndpoint | string | `""` | Rasa X (Enterprise) endpoint URL from which to pull the runtime config |
| applicationSettings.enterprise.enabled | bool | `false` | Run Rasa X (Enterprise) server |
| applicationSettings.enterprise.port | int | `5002` | Port to run the Rasa X (Enterprise) server at |
| applicationSettings.enterprise.production | bool | `true` | Run Rasa X (Enterprise) in a production environment |
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
| networkPolicy.enabled | bool | `true` | Enable Kubernetes Network Policy |
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
| service.loadBalancerIP | string | `nil` |  |
| service.nodePort | string | `nil` |  |
| service.port | int | `5005` | Set port of action-server service (Kubernetes >= 1.15) |
| service.type | string | `"ClusterIP"` | Set type of action-server service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Allow the deployment to perform a rolling update |
| tolerations | list | `[]` | Tolerations for pod assignment |
| volumeMounts | list | `[]` | Specify additional volumes to mount in the model-runner container |
| volumes | list | `[]` | Specify additional volumes to mount in the model-runner container |
