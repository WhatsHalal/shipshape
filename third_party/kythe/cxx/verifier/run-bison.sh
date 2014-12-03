#!/bin/bash

# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script regenerates the flex lexer and bison parser used by the verifier.
# It expects Bison to live at ~/bison/bin/bison. The versions used for the
# artifacts in the repository are bison 3.0 and flex 2.5.35.
set -e
BISON=~/bison/bin/bison
FLEX=flex
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
pushd ${SCRIPT_PATH}
rm -f assertions.tab.cc assertions.tab.hh location.hh position.hh stack.hh lex.yy.c lex.yy.cc
${FLEX} assertions.ll
mv lex.yy.c lex.yy.cc
${BISON} assertions.yy
popd