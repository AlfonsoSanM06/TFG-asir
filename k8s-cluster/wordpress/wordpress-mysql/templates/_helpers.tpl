{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress-mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wordpress-mysql.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wordpress-mysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wordpress-mysql.labels" -}}
helm.sh/chart: {{ include "wordpress-mysql.chart" . }}
{{ include "wordpress-mysql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: frontend
app.kubernetes.io/part-of: wordpress-stack
{{- end }}

{{/*
Selector labels — usados en matchLabels y selector del Service
*/}}
{{- define "wordpress-mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wordpress-mysql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
owner: alfonso
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wordpress-mysql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wordpress-mysql.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Nombre del Service de WordPress (usado en Ingress y backend refs)
*/}}
{{- define "wordpress-mysql.serviceName" -}}
{{- printf "%s-svc" (include "wordpress-mysql.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Nombre del PVC de WordPress
*/}}
{{- define "wordpress-mysql.pvcName" -}}
{{- if .Values.persistence.claimName }}
{{- .Values.persistence.claimName }}
{{- else }}
{{- printf "%s-wp-pvc" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
StorageClass efectivo de WordPress: usa persistence.storageClassName si se define,
si no cae en global.storageClass
*/}}
{{- define "wordpress-mysql.storageClass" -}}
{{- if .Values.persistence.storageClassName }}
{{- .Values.persistence.storageClassName }}
{{- else }}
{{- .Values.global.storageClass }}
{{- end }}
{{- end }}

{{/*
Tamaño efectivo del PVC de WordPress
*/}}
{{- define "wordpress-mysql.storageSize" -}}
{{- if .Values.persistence.size }}
{{- .Values.persistence.size }}
{{- else }}
{{- .Values.global.storageSize }}
{{- end }}
{{- end }}

{{/*
Nombre del Secret del subchart MySQL que WordPress necesita para conectarse.
Usando la convención: <release>-mysql-subchart-secret
*/}}
{{- define "wordpress-mysql.mysqlSecretName" -}}
{{- if .Values.wordpress.secretName }}
{{- .Values.wordpress.secretName }}
{{- else }}
{{- printf "%s-mysql-subchart-secret" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Host de MySQL que verá el contenedor WordPress.
Si el usuario define wordpress.dbHost lo usa; si no, construye el FQDN
headless del subchart: <release>-mysql-subchart.<namespace>.svc.cluster.local
BASICAMENTE, SI NO SE DEFINE NADA, EL SUBCHART CREA EL HOST
*/}}
{{- define "wordpress-mysql.mysqlHost" -}}
{{- if .Values.wordpress.dbHost }}
{{- .Values.wordpress.dbHost }}
{{- else }}
{{- printf "%s-mysql-subchart" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Host del Ingress de WordPress.
Si el usuario define ingress.host lo usa; si no, usa global.domain.
*/}}
{{- define "wordpress-mysql.ingressHost" -}}
{{- if .Values.ingress.host }}
{{- .Values.ingress.host }}
{{- else }}
{{- .Values.global.domain }}
{{- end }}
{{- end }}
