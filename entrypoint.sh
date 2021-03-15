#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS=./credentials.json
echo "${ENCODED_GOOGLE_APPLICATION_CREDENTIALS_JSON}" | base64 -d > "${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud auth activate-service-account "${SA_EMAIL}" --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"

python  ./src/main.py