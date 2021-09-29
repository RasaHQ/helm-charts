{{/* RabbitMQ related templates */}}

{{/* Overwrite the rabbit fullname template. */}}
{{- define "rasa-common.rabbitmq.fullname" -}}
{{- printf "%s-rabbitmq" .Release.Name -}}
{{- end -}}

{{/*
Return the rabbitmq host.
*/}}
{{- define "rasa-common.rabbitmq.host" -}}
  {{- if .Values.rabbitmq.install -}}
    {{- template "rasa-common.rabbitmq.fullname" . -}}
  {{- else if .Values.rabbitmq.external.enabled -}}
    {{- .Values.rabbitmq.external.host -}}
  {{- end -}}
{{- end -}}

{{/*
Return the rabbitmq password secret name.
*/}}
{{- define "rasa-common.rabbitmq.password.secret" -}}
{{- default (include "rasa-common.rabbitmq.fullname" .) .Values.rabbitmq.auth.existingPasswordSecret | quote -}}
{{- end -}}

{{/*
Return the rabbitmq port.
*/}}
{{- define "rasa-common.rabbitmq.port" -}}
{{- default 5672 ((.Values.rabbitmq).service).port -}}
{{- end -}}

{{/*
Return the rabbitmq password secret key.
*/}}
{{- define "rasa-common.rabbitmq.password.key" -}}
  {{- if .Values.rabbitmq.install -}}
"rabbitmq-password"
  {{- end -}}
{{- end -}}

{{/*
Determine if RabbitMQ is available
*/}}
{{- define "rasa-common.rabbitmq.available" -}}
{{- if or .Values.rabbitmq.external.enabled .Values.rabbitmq.install -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return the common RabbitMQ env variables.
*/}}
{{- define "rasa-common.rabbitmq.envs" -}}
- name: "RABBITMQ_USERNAME"
  value: "{{ .Values.rabbitmq.auth.username }}"
- name: "RABBITMQ_HOST"
  value: "{{ template "rasa-common.rabbitmq.host" . }}"
- name: "RABBITMQ_QUEUE"
  value: "{{ index .Values.applicationSettings.endpoints.eventBroker.queues 0 }}"
- name: "RABBITMQ_PORT"
  value: "{{ template "rasa-common.rabbitmq.port" . }}"
- name: "RABBITMQ_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ template "rasa-common.rabbitmq.password.secret" . }}
      key: "rabbitmq-password"
{{- end -}}
