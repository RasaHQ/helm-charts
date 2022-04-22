# duckling

![Version: 1.1.4](https://img.shields.io/badge/Version-1.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.0.2-r0](https://img.shields.io/badge/AppVersion-0.2.0.2--r0-informational?style=flat-square)

Duckling is a Haskell library that parses text into structured data.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Rasa | <hi@rasa.com> |  |

## Source Code

* <https://github.com/RasaHQ/duckling>
* <https://github.com/facebook/duckling>
* <https://github.com/RasaHQ/helm-charts/tree/main/charts/duckling>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.rasa.com | rasa-common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Allow the Duckling Deployment to schedule using affinity rules |
| applicationSettings.port | int | `8000` | Port on which Duckling runs |
| applicationSettings.scheme | string | `"http"` | Scheme by which the service are accessible |
| args | list | `[]` | Override the default arguments for the container |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `20` | Upper limit for the number of pods that can be set by the autoscaler. It cannot be smaller than minReplicas. |
| autoscaling.minReplicas | int | `1` | Lower limit for the number of pods that can be set by the autoscaler |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Fraction of the requested CPU that should be utilized/used, e.g. 70 means that 70% of the requested CPU should be in use. |
| command | list | `[]` | Override the default command for the container |
| deploymentAnnotations | object | `{}` | Annotations to add to the duckling deployment |
| deploymentLabels | object | `{}` | Labels to add to the duckling deployment |
| extraEnv | list | `[]` | Add extra environment variables |
| fullnameOverride | string | `""` | (string) Override the fully qualified app name |
| image.name | string | `"duckling"` | Duckling image name to use (relative to `registry`) |
| image.pullPolicy | string | `"IfNotPresent"` | Duckling image pullPolicy |
| image.pullSecrets | list | `[]` | Duckling repository pullSecret |
| image.repository | string | `""` | Override default registry + image.name for Duckling |
| image.tag | string | `"0.2.0.2-r0"` | Duckling image tag to use |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Set to true to enable ingress |
| ingress.extraPaths | object | `{}` | Any additional arbitrary paths that may need to be added to the ingress under the main host |
| ingress.hostname | string | `"chart-example.local"` | Hostname used for the ingress |
| ingress.labels | object | `{}` | Labels to add to the ingress |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type |
| ingress.tls | list | `[]` | TLS configuration for ingress |
| initContainers | list | `[]` | Allow to specify init containers for the Duckling Deployment |
| livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings |
| nameOverride | string | `""` | (string) Override name of app |
| nodeSelector | object | `{}` | Allow the Duckling Deployment to be scheduled on selected nodes |
| podAnnotations | object | `{}` | Annotations to add to the duckling's pod(s) |
| podLabels | object | `{}` | Labels to add to the duckling's pod(s) |
| podSecurityContext | object | `{}` | Defines pod-level security attributes and common container settings |
| readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings |
| registry | string | `"docker.io/rasa"` | Registry to use for all Rasa images (default docker.io) |
| replicaCount | int | `1` | Specify the number of model runner replicas |
| resources | object | `{}` | Resource requests and limits |
| securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.externalTrafficPolicy | string | `"Cluster"` | Enable client source IP preservation |
| service.loadBalancerIP | string | `nil` |  |
| service.nodePort | string | `nil` |  |
| service.port | int | `8000` | Set port of duckling service (Kubernetes >= 1.15) |
| service.type | string | `"ClusterIP"` | Set type of duckling service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Allow the deployment to perform a rolling update |
| tolerations | list | `[]` | Tolerations for pod assignment |
| volumeMounts | list | `[]` | Specify additional volumes to mount in the duckling container |
| volumes | list | `[]` | Specify additional volumes to mount in the duckling container |
