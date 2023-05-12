{{/* Vault related templates */}}

{{/* Overwrite the vault fullname template. */}}
{{- define "rasa-common.vault.fullname" -}}
{{- printf "%s-vault" .Release.Name -}}
{{- end -}}

{{/*
Return the vault host.
*/}}
{{- define "rasa-common.vault.host" -}}
  {{ .Values.vault.host }}
{{- end -}}

{{/*
Return the vault port.
*/}}
{{- define "rasa-common.vault.port" -}}
{{- coalesce .Values.vault.port 8200 -}}
{{- end -}}

{{/*
Return the vault password secret name.
*/}}
{{- define "rasa-common.vault.token.key" -}}
vault-token
{{- end -}}


{{/*
Return the secret name.
*/}}
{{- define "rasa-common.vault.token.secret" -}}
{{- .Release.Name -}}
{{- end -}}


{{- define "rasa-common.vault.transitEngineMountPoint"}}
{{- default "transit" .Values.vault.transitEngineMountPoint | quote -}}
{{- end -}}

{{/*

{{/*
Return the common vault env variables.
*/}}
{{- define "rasa-common.vault.envs" -}}
- name: "VAULT_HOST"
  value: "{{ template "rasa-common.vault.host" . }}"
- name: "VAULT_RASA_SECRETS_PATH"
  value: "{{ template "rasa-common.vault.secretsPath" . }}"
{{- if not (empty .Values.vault.transitEngineMountPoint) }}
- name: "VAULT_TRANSIT_MOUNT_POINT"
  value: "{{ template "rasa-common.vault.transitEngineMountPoint" . }}"
{{- end -}}
- name: "VAULT_TOKEN"
  valueFrom:
    secretKeyRef:
      name: {{ template "rasa-common.vault.token.secret" . }}
      key: {{ template "rasa-common.vault.token.key" . }}
{{- end -}}