#!/usr/bin/env bash
set -eEuo pipefail

ORGANIZATION=$ORGANIZATION
REPO=$REPO
TOKEN=$TOKEN
NAME=$NAME
_RUNNER_WORKDIR=$_RUNNER_WORKDIR

echo "Configuring"
./config.sh \
  --url "https://github.com/${ORGANIZATION}/${REPO}" \
  --token "${TOKEN}" \
  --name "${NAME}" \
  --unattended \
  --work "${_RUNNER_WORKDIR}"

cleanup() {
  echo "Removing runner ..."
  ./config.sh remove --unattended --token "${TOKEN}"
}

echo "Running"
./run.sh

cleanup
