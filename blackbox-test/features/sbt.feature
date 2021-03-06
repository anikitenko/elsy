# Copyright 2016 Cisco Systems, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Feature: sbt template

  Scenario: correct sbt template
    When I run `lc system view-template sbt`
    Then it should succeed
    And the output should contain all of these:
      | sbt:     |
      | test:    |
      | package: |
    And the output should not contain "sbtscratch"
    When I run `lc --enable-scratch-volumes system view-template sbt`
    Then it should succeed
    And the output should contain all of these:
      | sbtscratch:     |
      | sbt:     |
      | test:    |
      | package: |


  Scenario: standard sbt project
    Given a file named "hello.scala" with:
    """scala
    object Hello {
      def main(args: Array[String]) = println("Hello World")
    }
    """
    And a file named "project/assembly.sbt" with:
    """
    addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.0")
    """
    And a file named "build.sbt" with:
    """
    scalaVersion := "2.11.0"
    """
    And a file named "lc.yml" with:
    """yaml
    template: sbt
    """
    When I run `lc bootstrap`
    Then it should succeed
    When I run `lc test`
    Then it should succeed with "Compiling 1 Scala source"
    When I run `lc package`
    Then it should succeed
    And it should succeed with "Packaging /opt/project/target/scala-2.11/project-assembly-0.1-SNAPSHOT.jar"
    And the following folders should not be empty:
    | target/resolution-cache           |
    | target/scala-2.11/classes         |
    | project/project                   |
    | project/target                    |

    Scenario: standard sbt project with compose v2 file
      Given a file named "hello.scala" with:
      """scala
      object Hello {
        def main(args: Array[String]) = println("Hello World")
      }
      """
      And a file named "project/assembly.sbt" with:
      """
      addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.0")
      """
      And a file named "build.sbt" with:
      """
      scalaVersion := "2.11.0"
      """
      And a file named "lc.yml" with:
      """yaml
      template: sbt
      """
      And a file named "docker-compose.yml" with:
      """yaml
      version: '2'
      services:
        sbt:
          image: paulcichonski/sbt
      """
      When I run `lc bootstrap`
      Then it should succeed
      When I run `lc test`
      Then it should succeed with "Compiling 1 Scala source"
      When I run `lc package`
      Then it should succeed
      And it should succeed with "Packaging /opt/project/target/scala-2.11/project-assembly-0.1-SNAPSHOT.jar"
      And the following folders should not be empty:
      | target/resolution-cache           |
      | target/scala-2.11/classes         |
      | project/project                   |
      | project/target                    |

  Scenario: with enable-scratch-volumes
    Given a file named "hello.scala" with:
    """scala
    object Hello {
      def main(args: Array[String]) = println("Hello World")
    }
    """
    And a file named "project/assembly.sbt" with:
    """
    addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.0")
    """
    And a file named "build.sbt" with:
    """
    scalaVersion := "2.11.0"
    """
    And a file named "lc.yml" with:
    """yaml
    template: sbt
    """
    When I run `lc --enable-scratch-volumes bootstrap`
    Then it should succeed
    When I run `lc --enable-scratch-volumes test`
    Then it should succeed with "Compiling 1 Scala source"
    When I run `lc --enable-scratch-volumes package`
    Then it should succeed
    And it should succeed with "Packaging /opt/project/target/scala-2.11/project-assembly-0.1-SNAPSHOT.jar"
    And the following folders should be empty:
    | target/resolution-cache           |
    | target/scala-2.11/classes         |
    | project/project                   |
    | project/target                    |

    Scenario: with enable-scratch-volumes and a compopse v2 file
      Given a file named "hello.scala" with:
      """scala
      object Hello {
        def main(args: Array[String]) = println("Hello World")
      }
      """
      And a file named "project/assembly.sbt" with:
      """
      addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.0")
      """
      And a file named "build.sbt" with:
      """
      scalaVersion := "2.11.0"
      """
      And a file named "lc.yml" with:
      """yaml
      template: sbt
      """
      And a file named "docker-compose.yml" with:
      """yaml
      version: '2'
      services:
        sbt:
          image: paulcichonski/sbt
      """
      When I run `lc --enable-scratch-volumes bootstrap`
      Then it should succeed
      When I run `lc --enable-scratch-volumes test`
      Then it should succeed with "Compiling 1 Scala source"
      When I run `lc --enable-scratch-volumes package`
      Then it should succeed
      And it should succeed with "Packaging /opt/project/target/scala-2.11/project-assembly-0.1-SNAPSHOT.jar"
      And the following folders should be empty:
      | target/resolution-cache           |
      | target/scala-2.11/classes         |
      | project/project                   |
      | project/target                    |
