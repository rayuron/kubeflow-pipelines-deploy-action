#!/bin/bash

gcloud auth activate-service-account ${SA_EMAIL} --key-file=${GOOGLE_APPLICATION_CREDENTIALS_JSON}
python  ./src/main.py