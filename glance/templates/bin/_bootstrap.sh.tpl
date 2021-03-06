#!/bin/bash

# Copyright 2017 The Openstack-Helm Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex
export HOME=/tmp

{{ if .Values.bootstrap.enabled }}

cd /tmp/images

{{ range .Values.bootstrap.images }}
openstack image show {{ .name  | quote }} || \
  { curl -O {{ .source_url }}{{ .image_file }}; \
  openstack image create {{ .name | quote }} \
  --min-disk {{ .min_disk }} \
  --disk-format {{ .image_type }} \
  --file {{ .image_file }} \
  {{ if .properties -}} {{ range $key, $value := .properties }}--property {{$key}}={{$value}} {{ end }}{{ end -}} \
  --container-format {{ .container_format | quote }} \
  {{ if .private -}}
  --private
  {{- else -}}
  --public
  {{- end -}}; }
{{ end }}

{{ end }}
exit 0
