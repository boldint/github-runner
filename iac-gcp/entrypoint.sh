#!/usr/bin/env bash
set -eEuo pipefail

cleanup() {
  ./config.sh remove --token "${TOKEN}"
}

./config.sh \
  --url "https://github.com/${OWNER}/${REPO}" \
  --token "${TOKEN}" \
  --name "${NAME}" \
  --unattended \
  --work _work

./run.sh

cleanup
