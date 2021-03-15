#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS=./credentials.json
echo "${GOOGLE_APPLICATION_CREDENTIALS_JSON}" > "${GOOGLE_APPLICATION_CREDENTIALS}"
echo "${GOOGLE_APPLICATION_CREDENTIALS_JSON}" | gcloud auth activate-service-account "${SA_EMAIL}" --key-file=-

python  ./src/main.py