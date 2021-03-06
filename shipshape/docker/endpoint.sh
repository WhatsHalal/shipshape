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

# Start dispatchers
./go_dispatcher &> /shipshape-output/shipshape.go_dispatcher.log &
java -jar java_dispatcher.jar &> /shipshape-output/shipshape.java_dispatcher.log &
java -jar javac_dispatcher.jar &> /shipshape-output/shipshape.javac_dispatcher.log &

# Start main shipshape service
if [ -z "$START_SERVICE" ]
then
  echo 'Running shipping container in streaming mode' > /shipshape-output/shipshape.shipping_container.log
  ./shipshape --analyzer_services="$(eval echo $ANALYZERS)"
else
  ./shipshape --start_service --analyzer_services="$(eval echo $ANALYZERS)" &> /shipshape-output/shipshape.shipping_container.log
fi

