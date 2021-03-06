/*
 *  Copyright 2016 Cisco Systems, Inc.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package template

import "github.com/cisco/elsy/helpers"

var leinTemplateV1 = template{
	name: "lein",
	composeYmlTmpl: `
{{if .ScratchVolumes}}
mvnscratch:
  image: busybox
  volumes:
    {{.ScratchVolumes}}
  entrypoint: /bin/true
{{end}}
lein: &lein
{{if .TemplateImage}}
  image: {{.TemplateImage}}
{{else}}
  image: clojure:lein-2.6.1
{{end}}
  volumes:
    - ./:/opt/project
  working_dir: /opt/project
  entrypoint: lein
  volumes_from:
    - lc_shared_mvndata
{{if .ScratchVolumes}}
    - mvnscratch
{{end}}
test:
  <<: *lein
  entrypoint: [lein, test]
package:
  <<: *lein
  command: [jar, "-DskipTests=true"]
publish:
  <<: *lein
  entrypoint: /bin/true
clean:
  <<: *lein
  entrypoint: [lein, clean]
`,
	scratchVolumes: `
  - /opt/project/target/classes
  - /opt/project/target/journal
  - /opt/project/target/maven-archiver
  - /opt/project/target/maven-status
  - /opt/project/target/snapshots
  - /opt/project/target/test-classes
  - /opt/project/target/war/work
  - /opt/project/target/webappDirectory
`}

var leinTemplateV2 = template{
	name: "lein",
	composeYmlTmpl: `
version: '2'
services:
  {{if .ScratchVolumes}}
  mvnscratch:
    image: busybox
    volumes:
      {{.ScratchVolumes}}
    entrypoint: /bin/true
  {{end}}
  lein: &lein
{{if .TemplateImage}}
    image: {{.TemplateImage}}
{{else}}
    image: clojure:lein-2.6.1
{{end}}
    volumes:
      - ./:/opt/project
    working_dir: /opt/project
    entrypoint: lein
    volumes_from:
      - container:lc_shared_mvndata
  {{if .ScratchVolumes}}
      - mvnscratch
  {{end}}
  test:
    <<: *lein
    entrypoint: [lein, test]
  package:
    <<: *lein
    command: [jar, "-DskipTests=true"]
  publish:
    <<: *lein
    entrypoint: /bin/true
  clean:
    <<: *lein
    entrypoint: [lein, clean]
`,
	scratchVolumes: `
    - /opt/project/target/classes
    - /opt/project/target/journal
    - /opt/project/target/maven-archiver
    - /opt/project/target/maven-status
    - /opt/project/target/snapshots
    - /opt/project/target/test-classes
    - /opt/project/target/war/work
    - /opt/project/target/webappDirectory
`}

func init() {
	addSharedExternalDataContainer("lein", helpers.DockerDataContainer{
		Image:     "busybox:latest",
		Name:      "lc_shared_mvndata",
		Volumes:   []string{"/root/.m2/repository"},
		Resilient: true,
	})

	addV1(leinTemplateV1)
	addV2(leinTemplateV2)
}
