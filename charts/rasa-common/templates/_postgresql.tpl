{{/*
Return the postgresql host.
*/}}
{{- define "rasa-common.psql.host" -}}
  {{- if .Values.postgresql.install -}}
    {{- template "rasa-common.psql.fullname" . -}}
  {{- else if .Values.postgresql.external.enabled -}}
    {{- .Values.postgresql.external.host -}}
  {{- end -}}
{{- end -}}

{{/*
Override the fullname template of the subchart.
*/}}
{{- define "rasa-common.psql.fullname" -}}
{{- printf "%s-postgresql" .Release.Name -}}
{{- end -}}

{{/*
Return the db database name.
*/}}
{{- define "rasa-common.psql.database" -}}
{{- coalesce .databaseName .Values.global.postgresql.postgresqlDatabase "rasa" -}}
{{- end -}}

{{/*
Return the db username.
*/}}
{{- define "rasa-common.psql.username" -}}
{{- coalesce .Values.global.postgresql.postgresqlUsername "rasa" -}}
{{- end -}}

{{/*
Return the db port.
*/}}
{{- define "rasa-common.psql.port" -}}
{{- coalesce .Values.global.postgresql.servicePort 5432 -}}
{{- end -}}

{{/*
Return the secret name.
*/}}
{{- define "rasa-common.psql.password.secret" -}}
{{- default (include "rasa-common.psql.fullname" .) .Values.global.postgresql.existingSecret | quote -}}
{{- end -}}


{{/*
Return the name of the key in a secret that contains the postgres password.
*/}}
{{- define "rasa-common.psql.password.key" -}}
  {{- if .Values.postgresql.existingSecretKey -}}
    {{- .Values.postgresql.existingSecretKey -}}
  {{- else if (not (eq .Values.global.postgresql.postgresqlUsername "postgres")) -}}
postgresql-postgres-password
  {{- else -}}
postgresql-password
  {{- end -}}
{{- end -}}

{{/*
Determine if PostgreSQL is available
*/}}
{{- define "rasa-common.psql.available" -}}
{{- if or .Values.postgresql.external.enabled .Values.postgresql.install -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return the common database env variables.
*/}}
{{- define "rasa-common.psql.envs" -}}
- name: "DB_USER"
  value: "{{ template "rasa-common.psql.username" . }}"
- name: "DB_HOST"
  value: "{{ template "rasa-common.psql.host" . }}"
- name: "DB_PORT"
  value: "{{ template "rasa-common.psql.port" . }}"
- name: "DB_DATABASE"
  value: "{{ template "rasa-common.psql.database" . }}"
- name: "DB_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ template "rasa-common.psql.password.secret" . }}
      key: {{ template "rasa-common.psql.password.key" . }}
{{- end -}}
