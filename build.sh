#!/usr/bin/env bash

cd raj-shekhar1/k8s-cluster-tf

cd -

./terraform init

if [[ $TRAVIS_BRANCH == 'master' ]]
then
    ./terraform apply -auto-approve
fi