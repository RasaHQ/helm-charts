{{/*
Return the Kubernetes version
*/}}
{{- define "rasa-common.capabilities.kubeVersion" -}}
{{- .Capabilities.KubeVersion.Version -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "rasa-common.capabilities.deployment.apiVersion" -}}
{{- if semverCompare "<1.14-0" (include "rasa-common.capabilities.kubeVersion" .) -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "rasa-common.capabilities.statefulset.apiVersion" -}}
{{- if semverCompare "<1.14-0" (include "rasa-common.capabilities.kubeVersion" .) -}}
{{- print "apps/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "rasa-common.capabilities.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" (include "rasa-common.capabilities.kubeVersion" .) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" (include "rasa-common.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end -}}
