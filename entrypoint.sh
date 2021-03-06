#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS_JSON=/tmp/credentials.json
echo "${GOOGLE_APPLICATION_CREDENTIALS}" > "${GOOGLE_APPLICATION_CREDENTIALS_JSON}"
gcloud auth activate-service-account "${SA_EMAIL}" --key-file="${GOOGLE_APPLICATION_CREDENTIALS_JSON}"

python  ./src/main.py