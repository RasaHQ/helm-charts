# rasa-action-server

![Version: 1.0.3](https://img.shields.io/badge/Version-1.0.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.7.0](https://img.shields.io/badge/AppVersion-2.7.0-informational?style=flat-square)

Rasa Action Server Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Rasa | <hi@rasa.com> |  |

## Source Code

* <https://github.com/RasaHQ/helm-charts/tree/main/charts/rasa-action-server>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.rasa.com | rasa-common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Allow the Action Server Deployment to schedule using affinity rules # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
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
| fullnameOverride | string | `""` | Override the full qualified app name |
| image.name | string | `"rasa-x-demo"` | Action Server image name to use (relative to `registry`) |
| image.pullPolicy | string | `"IfNotPresent"` | Action Server image pullPolicy |
| image.pullSecrets | list | `[]` | Action Server repository pullSecret # See https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod |
| image.repository | string | `""` | Override default registry + image.name for Action Server |
| image.tag | string | `"0.40.0"` | Action Server image tag to use |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Set to true to enable ingress |
| ingress.extraPaths | object | `{}` | Any additional arbitrary paths that may need to be added to the ingress under the main host |
| ingress.hostname | string | `"chart-example.local"` | Hostname used for the ingress |
| ingress.labels | object | `{}` | Labels to add to the ingress |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type # Ref: https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types |
| ingress.tls | list | `[]` | TLS configuration for ingress # See: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls |
| initContainers | list | `[]` | Allow to specify init containers for the Action Server Deployment # Ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| livenessProbe | object | Every 15s / 6 KO / 1 OK | Override default liveness probe settings # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| nameOverride | string | `""` | Override name of app |
| nodeSelector | object | `{}` | Allow the Action Server Deployment to be scheduled on selected nodes # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector # Ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| podAnnotations | object | `{}` | Annotations to add to the action-server's pod(s) |
| podLabels | object | `{}` | Labels to add to the action-server's pod(s) |
| podSecurityContext | object | `{}` | Defines pod-level security attributes and common container settings # See: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| readinessProbe | object | Every 15s / 6 KO / 1 OK | Override default readiness probe settings # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| registry | string | `"docker.io/rasa"` | Registry to use for all Rasa images (default docker.io) # DockerHub - use docker.io/rasa |
| replicaCount | int | `1` | Specify the number of Action Server replicas |
| resources | object | `{}` | Resource requests and limits |
| securityContext | object | `{}` | Allows you to overwrite the pod-level security context |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.externalTrafficPolicy | string | `"Cluster"` | Enable client source IP preservation # Ref: http://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip |
| service.loadBalancerIP | string | `nil` | Exposes the Service externally using a cloud provider's load balancer # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer |
| service.nodePort | string | `nil` | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#nodeport |
| service.port | int | `80` | Set port of action-server service (Kubernetes >= 1.15) |
| service.type | string | `"ClusterIP"` | Set type of action-server service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Allow the deployment to perform a rolling update # ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | list | `[]` | Tolerations for pod assignment # Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| volumeMounts | list | `[]` | Specify additional volumes to mount in the action-server container |
| volumes | list | `[]` | Specify additional volumes to mount in the action-server container # Ref: https://kubernetes.io/docs/concepts/storage/volumes/ |
