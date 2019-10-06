#!/bin/bash

echo "# Create the namespaces"
kubectl create ns development
kubectl create ns ui-development
kubectl create ns ui-production

echo -e "\n# Label ui-development namespace"
kubectl label namespace/ui-development purpose=dev

echo -e "\n# Create pods"
kubectl run --generator=run-pod/v1 backend-dev --image=nginx --port=80 --expose -n development
kubectl run --generator=run-pod/v1 ui-dev --image=nginx --port=80 --expose -n ui-development
kubectl run --generator=run-pod/v1 ui-prod --image=nginx --port=80 --expose -n ui-production

echo -e "\n# Wait until pods are running ..."
sleep 20s

echo -e "\n# Update and install wget in all pods"
kubectl exec backend-dev -n development -- bash -c 'apt-get update && apt-get install wget -y'
kubectl exec ui-dev -n ui-development -- bash -c 'apt-get update && apt-get install wget -y'
kubectl exec ui-prod -n ui-production -- bash -c 'apt-get update && apt-get install wget -y'

echo -e "\n# Create a default deny all ingress traffic in the default namespace"
kubectl create -f https://raw.githubusercontent.com/roxcarpio/cka-exercises/master/exercices/e.security/deny-policy.yaml -n development
kubectl create -f https://raw.githubusercontent.com/roxcarpio/cka-exercises/master/exercices/e.security/deny-policy.yaml -n ui-development
kubectl create -f https://raw.githubusercontent.com/roxcarpio/cka-exercises/master/exercices/e.security/deny-policy.yaml -n ui-production