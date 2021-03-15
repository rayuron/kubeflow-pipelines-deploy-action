#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS=./credentials.json
echo "${GOOGLE_APPLICATION_CREDENTIALS_JSON}" > "${GOOGLE_APPLICATION_CREDENTIALS}"
head "${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud auth activate-service-account "${SA_EMAIL}" --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"

python  ./src/main.py