#!/usr/bin/env bash
set -e
set -x

gcloud --version
gcloud auth activate-service-account --key-file $SERVICE_ACCOUNT_FILE

# lets setup git 
git config --global --add user.name JenkinsXBot
git config --global --add user.email jenkins-x@googlegroups.com

jx create terraform -o ${CLUSTER_NAME,,} \
    --install-dependencies \
    --cluster 'dev=gke' \
    --skip-login=true \
    --batch-mode \
    --gke-project-id ${PROJECT_ID} \
    --gke-zone ${ZONE} \
    --gke-machine-type n1-standard-2 \
    --gke-min-num-nodes=3 \
    --gke-max-num-nodes=5 \
    --default-admin-password ${JENKINS_PASSWORD} \
    --git-provider-url ${GIT_PROVIDER_URL} \
    --local-cloud-environment=true \
    --default-environment-prefix=b${BUILD_NUMBER} \
    --environment-git-owner=jenkins-x-tests

jx namespace jx
