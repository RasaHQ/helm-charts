{{/*
Determine if endpoint for Rasa Action Server is used
*/}}
{{- define "rasa.endpoints.action" -}}
{{- if or (index .Values "rasa-action-server").install (and (index .Values "rasa-action-server").external.enabled (not (empty (index .Values "rasa-action-server").external.url))) -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return Rasa Action Server URL
*/}}
{{- define "rasa.actionServer.url" -}}
{{- if and (index .Values "rasa-action-server").install (not (index .Values "rasa-action-server").external.enabled) -}}
{{- printf "%s://%s-rasa-action-server.%s.svc:%d%s" (index .Values "rasa-action-server").applicationSettings.scheme (include "rasa-common.names.fullname" .) .Release.Namespace ((index .Values "rasa-action-server").service.port | int) .Values.applicationSettings.endpoints.action.endpointURL -}}
{{- else if and (not (index .Values "rasa-action-server").install) (index .Values "rasa-action-server").external.enabled (not (empty (index .Values "rasa-action-server").external.url))  -}}
{{- print (index .Values "rasa-action-server").external.url -}}
{{- end -}}
{{- end -}}


{{/*
Return the common Rasa Action Server env variables.
*/}}
{{- define "rasa.actionServer.envs" -}}
- name: "ACTION_SERVER_URL"
  value: "{{ include "rasa.actionServer.url" . }}"
{{- end -}}
