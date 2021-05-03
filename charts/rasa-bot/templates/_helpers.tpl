{{/*
Determine rasa server to run with arguments
*/}}
{{- define "rasa-bot.rasa.server.type" -}}
{{- if .Values.applicationSettings.enterprise.enabled -}}
- x
- --production
- --no-prompt
{{- else -}}
- run
{{- end -}}
{{- end -}}


{{/*
Determine if a model server endpoint is used
*/}}
{{- define "rasa-bot.endpoints.models.enabled" -}}
{{- if and (not .Values.applicationSettings.enterprise.enabled) .Values.applicationSettings.endpoints.models.enabled -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if Tracker Store is used
*/}}
{{- define "rasa-bot.endpoints.trackerStore.enabled" -}}
{{- if and (not .Values.applicationSettings.enterprise.enabled) .Values.applicationSettings.endpoints.trackerStore.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if Lock Store is used
*/}}
{{- define "rasa-bot.endpoints.lockStore.enabled" -}}
{{- if and (not .Values.applicationSettings.enterprise.enabled) .Values.applicationSettings.endpoints.lockStore.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}


{{/*
Determine if Lock Store is used
*/}}
{{- define "rasa-bot.endpoints.eventBroker.enabled" -}}
{{- if and (not .Values.applicationSettings.enterprise.enabled) .Values.applicationSettings.endpoints.eventBroker.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if credential configuration for channel connectors is used
*/}}
{{- define "rasa-bot.credentials.enabled" -}}
{{- if and (not .Values.applicationSettings.enterprise.enabled) .Values.applicationSettings.credentials.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}
