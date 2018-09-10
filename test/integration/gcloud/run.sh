#!/bin/bash
# Copyright 2018 Google LLC
# # Licensed under the Apache License, Version 2.0 (the "License"); # you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TEMPDIR=$(pwd)/test/integration/tmp
TESTDIR=${BASH_SOURCE%/*}

# Activate test working directory
function make_testdir() {
  mkdir -p "$TEMPDIR"
  cp -r "$TESTDIR"/* "$TEMPDIR"
}

# Activate test config
function activate_config() {
  # shellcheck disable=SC1091
  source config.sh
}

# Preparing environment
make_testdir
cd "$TEMPDIR" || exit
activate_config

terraform init
terraform apply -input=false -auto-approve
inspec exec ../inspec -t gcp://

# # # Clean the environment
cd - || exit
echo "Integration test finished"
