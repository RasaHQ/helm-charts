{{/* Redis related templates */}}

{{/* Overwrite the redis fullname template. */}}
{{- define "rasa-common.redis.fullname" -}}
{{- printf "%s-redis" .Release.Name -}}
{{- end -}}

{{/*
Return the redis host.
*/}}
{{- define "rasa-common.redis.host" -}}
  {{- if .Values.redis.install -}}
    {{- printf "%s-master" (include "rasa-common.redis.fullname" .) -}}
  {{- else if .Values.redis.external.enabled -}}
    {{- .Values.redis.external.host -}}
  {{- end -}}
{{- end -}}

{{/*
Return the redis port.
*/}}
{{- define "rasa-common.redis.port" -}}
{{- coalesce .Values.redis.master.service.port 6379 -}}
{{- end -}}

{{/*
Return the redis password secret name.
*/}}
{{- define "rasa-common.redis.password.secret" -}}
{{- default (include "rasa-common.redis.fullname" .) .Values.redis.existingSecret | quote -}}
{{- end -}}

{{/*
Return the redis password secret key.
*/}}
{{- define "rasa-common.redis.password.key" -}}
  {{- if and .Values.redis.install .Values.redis.existingSecret -}}
    {{- coalesce .Values.redis.existingSecretPasswordKey "redis-password" | quote -}}
  {{- else if .Values.redis.install -}}
    "redis-password"
  {{- else -}}
    {{- default "redis-password" .Values.redis.existingSecretPasswordKey | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Determine if redis is available
*/}}
{{- define "rasa-common.redis.available" -}}
{{- if or .Values.redis.external.enabled .Values.redis.install -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return the common redis env variables.
*/}}
{{- define "rasa-common.redis.envs" -}}
- name: "REDIS_HOST"
  value: "{{ template "rasa-common.redis.host" . }}"
- name: "REDIS_PORT"
  value: "{{ template "rasa-common.redis.port" . }}"
- name: "REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ template "rasa-common.redis.password.secret" . }}
      key: {{ template "rasa-common.redis.password.key" . }}
{{- end -}}
