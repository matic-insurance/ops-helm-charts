#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly CLUSTER_NAME=chart-testing
readonly K8S_VERSION=v1.13.4

create_kind_cluster() {
    kind create cluster --name "$CLUSTER_NAME" --image "kindest/node:$K8S_VERSION" --wait 60s
    KUBECONFIG="$(kind get kubeconfig-path --name="$CLUSTER_NAME")"
    export KUBECONFIG

    kubectl cluster-info || kubectl cluster-info dump
    echo

    kubectl get nodes
    echo

    echo 'Cluster ready!'
    echo
}

install_tiller() {
    echo 'Installing Tiller...'
    kubectl --namespace kube-system --output yaml create serviceaccount tiller --dry-run | kubectl apply -f -
    kubectl create --output yaml clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller --dry-run | kubectl apply -f -
    helm init --service-account tiller --upgrade --wait
    echo
}

helm_e2e() {
    go get github.com/ghodss/yaml
    go run test/helm/main.go
}

cleanup() {
    kind delete cluster --name "$CLUSTER_NAME"
    echo 'Done!'
}

main() {
    trap cleanup EXIT
    create_kind_cluster
    install_tiller
    helm_e2e
}

main