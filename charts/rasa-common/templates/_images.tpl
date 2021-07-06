{{/*
Return a remote image path based
*/}}
{{- define "rasa-common.images.image" -}}
{{- if .Values.image.repository -}}
{{- .Values.image.repository -}}:{{ .Values.image.tag }}
{{- else -}}
{{ .Values.registry }}/{{ .Values.image.name }}:{{ .Values.image.tag }}
{{- end -}}
{{- end -}}
