{{/*
Determine rasa server to run with arguments
*/}}
{{- define "rasa.rasa.server.type" -}}
{{- if .Values.applicationSettings.rasaX.enabled -}}
- x
- --no-prompt
- --production
{{- if .Values.applicationSettings.rasaX.useConfigEndpoint }}
- --config-endpoint
- {{ .Values.applicationSettings.rasaX.url }}/api/config?token=$(RASA_X_TOKEN)
{{- end }}
{{- else -}}
- run
{{- if .Values.applicationSettings.enableAPI }}
- --enable-api
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Determine if a model server endpoint is used
*/}}
{{- define "rasa.endpoints.models.enabled" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) .Values.applicationSettings.endpoints.models.enabled (not .Values.applicationSettings.endpoints.models.useRasaXasModelServer.enabled) -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if Tracker Store is used
*/}}
{{- define "rasa.endpoints.trackerStore.enabled" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) .Values.applicationSettings.endpoints.trackerStore.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if Lock Store is used
*/}}
{{- define "rasa.endpoints.lockStore.enabled" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) .Values.applicationSettings.endpoints.lockStore.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}


{{/*
Determine if Lock Store is used
*/}}
{{- define "rasa.endpoints.eventBroker.enabled" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) .Values.applicationSettings.endpoints.eventBroker.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if credential configuration for channel connectors is used
*/}}
{{- define "rasa.credentials.enabled" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) .Values.applicationSettings.credentials.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if a initial model should be downloaded
*/}}
{{- define "rasa.initialModel.download" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) (not .Values.applicationSettings.endpoints.models.enabled) (not (empty .Values.applicationSettings.initialModel)) (not .Values.applicationSettings.trainInitialModel) -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Determine if a initial model should be trained
*/}}
{{- define "rasa.initialModel.train" -}}
{{- if and (not .Values.applicationSettings.rasaX.useConfigEndpoint) (not .Values.applicationSettings.endpoints.models.enabled) .Values.applicationSettings.trainInitialModel -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}
