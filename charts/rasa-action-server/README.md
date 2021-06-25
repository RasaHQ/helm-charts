# rasa-action-server

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.7.0](https://img.shields.io/badge/AppVersion-2.7.0-informational?style=flat-square)

Rasa Action Server Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Rasa | hi@rasa.com |  |

## Source Code

* <https://github.com/RasaHQ/charts/rasa-bot>
* <https://rasa.com/>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../rasa-common | rasa-common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Allow the Action Server Deployment to schedule using affinity rules |
| applicationSettings.port | int | `5055` | Port on which Rasa Action Server runs |
| applicationSettings.scheme | string | `"http"` | Scheme by which the service are accessible |
| args | list | `[]` | Override the default arguments for the container |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `20` | Upper limit for the number of pods that can be set by the autoscaler. It cannot be smaller than minReplicas. |
| autoscaling.minReplicas | int | `1` | Lower limit for the number of pods that can be set by the autoscaler |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Fraction of the requested CPU that should be utilized/used, e.g. 70 means that 70% of the requested CPU should be in use. |
| command | list | `[]` | Override the default command for the container |
| deploymentAnnotations | object | `{}` | Annotations to add to the action-server deployment |
| deploymentLabels | object | `{}` | Labels to add to the action-server deployment |
| extraEnv | list | `[]` | Add extra environment variables |
| fullnameOverride | string | `nil` | Override the full qualified app name |
| image.name | string | `"rasa-x-demo"` | Action Server image name to use (relative to `registry`) |
| image.pullPolicy | string | `"IfNotPresent"` | Action Server image pullPolicy |
| image.pullSecrets | list | `[]` | Action Server repository pullSecret |
| image.repository | string | `nil` | Override default registry + image.name for Action Server |
| image.tag | string | `"0.40.0"` | Action Server image tag to use |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Set to true to enable ingress |
| ingress.extraPaths | object | `{}` | Any additional arbitrary paths that may need to be added to the ingress under the main host |
| ingress.hostname | string | `"chart-example.local"` | Hostname used for the ingress |
| ingress.labels | object | `{}` | Labels to add to the ingress |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type |
| ingress.tls | list | `[]` | TLS configuration for ingress |
| initContainers | list | `[]` | Allow to specify init containers for the Action Server Deployment |
| livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings |
| nameOverride | string | `nil` | Override name of app |
| nodeSelector | object | `{}` | Allow the Action Server Deployment to be scheduled on selected nodes |
| podAnnotations | object | `{}` | Annotations to add to the action-server's pod(s) |
| podLabels | object | `{}` | Labels to add to the action-server's pod(s) |
| podSecurityContext | object | `{}` | Defines pod-level security attributes and common container settings |
| readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings |
| registry | string | `"docker.io/rasa"` | Registry to use for all Rasa images (default docker.io) |
| replicaCount | int | `1` | Specify the number of Action Server replicas |
| resources | object | `{}` | Resource requests and limits |
| securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.externalTrafficPolicy | string | `"Cluster"` | Enable client source IP preservation |
| service.loadBalancerIP | string | `nil` | Exposes the Service externally using a cloud provider's load balancer |
| service.nodePort | string | `nil` | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types |
| service.port | int | `80` | Set port of action-server service (Kubernetes >= 1.15) |
| service.type | string | `"ClusterIP"` | Set type of action-server service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Allow the deployment to perform a rolling update |
| tolerations | list | `[]` | Tolerations for pod assignment |
| volumeMounts | list | `[]` | Specify additional volumes to mount in the action-server container |
| volumes | list | `[]` | Specify additional volumes to mount in the action-server container |
