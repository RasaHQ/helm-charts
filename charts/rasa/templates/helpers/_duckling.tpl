{{/*
Determine if endpoint for Duckling is used
*/}}
{{- define "rasa.endpoints.duckling" -}}
{{- if or .Values.duckling.install (and .Values.duckling.external.enabled .Values.duckling.external.url) -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return Duckling URL
*/}}
{{- define "rasa.duckling.url" -}}
{{- if and .Values.duckling.install (not .Values.duckling.external.enabled) -}}
{{- printf "%s://%s-duckling.%s.svc:%d" .Values.duckling.applicationSettings.scheme (include "rasa-common.names.fullname" .) .Release.Namespace (.Values.duckling.service.port | int) -}}
{{- else if and (not .Values.duckling.install) .Values.duckling.external.enabled (not (empty .Values.duckling.external.url))  -}}
{{- print .Values.duckling.external.url -}}
{{- end -}}
{{- end -}}


{{/*
Return the common Duckling env variables.
*/}}
{{- define "rasa.duckling.envs" -}}
- name: "RASA_DUCKLING_HTTP_URL"
  value: "{{ include "rasa.duckling.url" . }}"
{{- end -}}
