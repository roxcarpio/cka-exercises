#!/bin/bash

echo "# Create the network-policy-test-1 namespace"
kubectl create ns network-policy-test-1

echo -e "\n# Create the nginx-a and nginx-b pods"
kubectl run --generator=run-pod/v1 nginx-a --image=nginx --port=80 --expose -n network-policy-test-1
kubectl run --generator=run-pod/v1 nginx-b --image=nginx --port=80 --expose -n network-policy-test-1

echo -e "\n# Wait until the pod is running ..."
sleep 15s

echo -e "\n# Update the ubuntu OS in the nginx-a and nginx-b pods"
kubectl exec nginx-a -n network-policy-test-1 -- bash -c 'apt-get update && apt-get install wget -y'
kubectl exec nginx-b -n network-policy-test-1 -- bash -c 'apt-get update && apt-get install wget -y'

echo -e "\n# Create a default deny all ingress traffic in the default namespace"
kubectl create -f https://raw.githubusercontent.com/roxcarpio/cka-exercises/master/exercices/e.security/deny-policy.yaml -n network-policy-test-1
