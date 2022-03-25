{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "ahoy.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ include "postgresql.primary.fullname" $postgresContext }}
{{- end }}
