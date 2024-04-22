#!/usr/bin/env bash
#

set -e

release="v0.27.0"
base_url="https://github.com/operator-framework/operator-lifecycle-manager/releases/download/"
url="${base_url}/${release}"
namespace=olm

echo "Apply OLM CRDs..."
kubectl create -f ${url}/crds.yaml --dry-run=client -o yaml | kubectl apply --server-side=true -f -
if [ $? -eq 1 ]; then
    echo "failed to create OLM crds"
      exit 1
fi

kubectl wait --for=condition=Established -f ${url}/crds.yaml --timeout=120s

echo "Apply OLM manifests..."

kubectl create -f ${url}/olm.yaml --dry-run=client -o yaml | kubectl apply --server-side=true -f -
if [ $? -eq 1 ]; then
    echo "failed to create OLM manifests"
    exit 1
fi

sleep 5
echo "Waiting for deployments to be ready..."
kubectl rollout status -w deployment/olm-operator --namespace="${namespace}" --timeout=120s
kubectl rollout status -w deployment/catalog-operator --namespace="${namespace}" --timeout=120s

echo "Waiting for CSV packageserver to be ready..."
retries=30
until [[ $retries == 0 ]]; do
    rst=$(kubectl get csv -n "${namespace}" packageserver -o jsonpath='{.status.phase}' | tail -1 2>/dev/null)
    if [[ "$rst" == "Succeeded" ]]; then
        break
    fi
    sleep 10
    retries=$((retries - 1))
done

if [ $retries == 0 ]; then
    echo "failed to wait CSV packageserver to be ready"
    exit 1
fi

kubectl rollout status -w deployment/packageserver --namespace="${namespace}" --timeout=120s

echo "!!! OLM ${release} is installed successfully !!!"
