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

Feature: release task

  Scenario: with a git project with at least one commit
    When I run `mkdir releasetest && cd releasetest && git init`
    Then it should succeed
    When I run `cd releasetest && echo "test" > test && git add test && git commit test -m "test"`
    Then it should succeed
    When I run `cd releasetest && lc release --version v0.0.1 --git-commit=HEAD`
    Then it should fail
    And the output should contain all of these:
      | creating, and pushing, git tag v0.0.1 at commit HEAD     |
      | 'origin' does not appear to be a git repository          |

  Scenario: with a git project with at least one commit and invalid release version
    When I run `mkdir releasetest && cd releasetest && git init`
    Then it should succeed
    When I run `cd releasetest && echo "test" > test && git add test && git commit test -m "test"`
    Then it should succeed
    When I run `cd releasetest && lc release --version nextversion --git-commit=HEAD`
    Then it should fail with "release value syntax was not valid, it must adhere to"
