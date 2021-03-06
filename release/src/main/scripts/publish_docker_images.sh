#!/bin/bash
#
#    Licensed to the Apache Software Foundation (ASF) under one or more
#    contributor license agreements.  See the NOTICE file distributed with
#    this work for additional information regarding copyright ownership.
#    The ASF licenses this file to You under the Apache License, Version 2.0
#    (the "License"); you may not use this file except in compliance with
#    the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

# This script will generate and publish docker images for each language version to Docker Hub:
# 1. Generate images tagged with :{RELEASE}
# 2. Publish images tagged with :{RELEASE}
# 3. Tag images with :latest tag and publish.
# 4. Clean up images.

set -e

PYTHON_VER=("python2.7" "python3.5" "python3.6" "python3.7")
FLINK_VER=("1.7" "1.8" "1.9")

echo "Publish SDK docker images to Docker Hub."

echo "================Setting Up Environment Variables==========="
echo "Which release version are you working on: "
read RELEASE

echo "================Setting Up RC candidate Variables==========="
echo "From which RC candidate do you create publish docker image? (ex: rc0, rc1) "
read RC_VERSION

echo "================Confirmimg Release and RC version==========="
echo "We are using ${RC_VERSION} to create docker images for ${RELEASE}."
echo "Do you want to proceed? [y|N]"
read confirmation
if [[ $confirmation = "y" ]]; then

  echo '-------------------Generating and Pushing Python images-----------------'
  for ver in "${PYTHON_VER[@]}"; do
    # Pull varified RC from dockerhub.
    docker pull apachebeam/${ver}_sdk:${RELEASE}_${RC_VERSION}

    # Tag with ${RELEASE} and push to dockerhub.
    docker tag apachebeam/${ver}_sdk:${RELEASE}_${RC_VERSION} apachebeam/${ver}_sdk:${RELEASE}
    docker push apachebeam/${ver}_sdk:${RELEASE}

    # Tag with latest and push to dockerhub.
    docker tag apachebeam/${ver}_sdk:${RELEASE}_${RC_VERSION} apachebeam/${ver}_sdk:latest
    docker push apachebeam/${ver}_sdk:latest

    # Cleanup images from local
    docker rmi -f apachebeam/${ver}_sdk:${RELEASE}_${RC_VERSION}
    docker rmi -f apachebeam/${ver}_sdk:${RELEASE}
    docker rmi -f apachebeam/${ver}_sdk:latest
  done

  echo '-------------------Generating and Pushing Java images-----------------'
  # Pull varified RC from dockerhub.
  docker pull apachebeam/java_sdk:${RELEASE}_${RC_VERSION}

  # Tag with ${RELEASE} and push to dockerhub.
  docker tag apachebeam/java_sdk:${RELEASE}_${RC_VERSION} apachebeam/java_sdk:${RELEASE}
  docker push apachebeam/java_sdk:${RELEASE}

  # Tag with latest and push to dockerhub.
  docker tag apachebeam/java_sdk:${RELEASE}_${RC_VERSION} apachebeam/java_sdk:latest
  docker push apachebeam/java_sdk:latest

  # Cleanup images from local
  docker rmi -f apachebeam/java_sdk:${RELEASE}_${RC_VERSION}
  docker rmi -f apachebeam/java_sdk:${RELEASE}
  docker rmi -f apachebeam/java_sdk:latest

  echo '-------------------Generating and Pushing Go images-----------------'
  # Pull varified RC from dockerhub.
  docker pull apachebeam/go_sdk:${RELEASE}_${RC_VERSION}

  # Tag with ${RELEASE} and push to dockerhub.
  docker tag apachebeam/go_sdk:${RELEASE}_${RC_VERSION} apachebeam/go_sdk:${RELEASE}
  docker push apachebeam/go_sdk:${RELEASE}

  # Tag with latest and push to dockerhub.
  docker tag apachebeam/go_sdk:${RELEASE}_${RC_VERSION} apachebeam/go_sdk:latest
  docker push apachebeam/go_sdk:latest

  # Cleanup images from local
  docker rmi -f apachebeam/go_sdk:${RELEASE}_${RC_VERSION}
  docker rmi -f apachebeam/go_sdk:${RELEASE}
  docker rmi -f apachebeam/go_sdk:latest

  echo '-------------Generating and Pushing Flink job server images-------------'
  echo "Publishing images for the following Flink versions:" "${FLINK_VER[@]}"
  echo "Make sure the versions are correct, then press any key to proceed."
  read
  for ver in "${FLINK_VER[@]}"; do
    FLINK_IMAGE_NAME=apachebeam/flink${ver}_job_server

    # Pull verified RC from dockerhub.
    docker pull "${FLINK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}"

    # Tag with ${RELEASE} and push to dockerhub.
    docker tag "${FLINK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}" "${FLINK_IMAGE_NAME}:${RELEASE}"
    docker push "${FLINK_IMAGE_NAME}:${RELEASE}"

    # Tag with latest and push to dockerhub.
    docker tag "${FLINK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}" "${FLINK_IMAGE_NAME}:latest"
    docker push "${FLINK_IMAGE_NAME}:latest"

    # Cleanup images from local
    docker rmi -f "${FLINK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}"
    docker rmi -f "${FLINK_IMAGE_NAME}:${RELEASE}"
    docker rmi -f "${FLINK_IMAGE_NAME}:latest"
  done

  echo '-------------Generating and Pushing Spark job server image-------------'
  SPARK_IMAGE_NAME="apachebeam/spark_job_server"

  # Pull verified RC from dockerhub.
  docker pull "${SPARK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}"

  # Tag with ${RELEASE} and push to dockerhub.
  docker tag "${SPARK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}" "${SPARK_IMAGE_NAME}:${RELEASE}"
  docker push "${SPARK_IMAGE_NAME}:${RELEASE}"

  # Tag with latest and push to dockerhub.
  docker tag "${SPARK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}" "${SPARK_IMAGE_NAME}:latest"
  docker push "${SPARK_IMAGE_NAME}:latest"

  # Cleanup images from local
  docker rmi -f "${SPARK_IMAGE_NAME}:${RELEASE}_${RC_VERSION}"
  docker rmi -f "${SPARK_IMAGE_NAME}:${RELEASE}"
  docker rmi -f "${SPARK_IMAGE_NAME}:latest"
fi
