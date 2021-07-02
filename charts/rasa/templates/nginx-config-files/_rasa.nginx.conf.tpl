{{- define "rasa.nginx.rasa.conf" -}}
upstream rasa-oss {
  server 127.0.0.1:{{ .Values.applicationSettings.port }} max_fails=0;
}

server {
  listen            {{ .Values.nginx.port }};

{{- if and .Values.nginx.enabled .Values.nginx.tls.enabled (or .Values.nginx.tls.generateSelfSignedCert .Values.nginx.tls.certificateSecret) }}
  include           /etc/nginx/conf.d/ssl.conf;
{{- end }}

  keepalive_timeout   30;
  client_max_body_size 800M;

  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $host;
    proxy_pass {{ .Values.applicationSettings.scheme }}://rasa-oss/;
  }

  location /socket.io {
    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_pass {{ .Values.applicationSettings.scheme }}://rasa-oss/;
  }

  location /robots.txt {
    return 200 "User-agent: *\nDisallow: /\n";
  }

}
{{- end -}}
