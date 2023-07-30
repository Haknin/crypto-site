#!/bin/bash

deployment_name="flask-app-deployment"
deployment_file="/var/lib/jenkins/workspace/pipe-kube/crypto-site/kube_deploy.yml"

# Check if the deployment exists
if kubectl get deployment "$deployment_name" &>/dev/null; then
  echo "Deployment '$deployment_name' already exists. Proceeding to the next command..."
else
  # Deployment doesn't exist, apply the YAML file
  echo "Deployment '$deployment_name' not found. Applying the YAML file..."
  kubectl apply -f "$deployment_file"
fi
