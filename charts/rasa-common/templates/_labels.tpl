{{/*
Common labels
*/}}
{{- define "rasa-common.labels.standard" -}}
helm.sh/chart: {{ include "rasa-common.names.chart" . }}
{{ include "rasa-common.labels.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rasa-common.labels.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rasa-common.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
