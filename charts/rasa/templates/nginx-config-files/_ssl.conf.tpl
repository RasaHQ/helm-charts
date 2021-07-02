{{- define "rasa.nginx.ssl.conf" -}}
{{- if and .Values.nginx.enabled .Values.nginx.tls.enabled (or .Values.nginx.tls.generateSelfSignedCert .Values.nginx.tls.certificateSecret) }}
listen                  {{ .Values.nginx.tls.port }} ssl;

# # server_name           example.com;
ssl_certificate         /etc/nginx/certs/cert.pem;
ssl_certificate_key     /etc/nginx/certs/key.pem;
{{- end }}
{{- end -}}
