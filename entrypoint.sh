#!/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=/tmp/credentials.json
echo "${GOOGLE_APPLICATION_CREDENTIALS_JSON}" > "${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud auth activate-service-account "${SA_EMAIL}" --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"

python /app/src/main.py
