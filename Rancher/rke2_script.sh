#!/bin/bash

set -e

# Define variables
INSTALL_K3S_VERSION="v1.30.5+k3s1"
CERTIFICATE_MANAGER="https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.crds.yaml"
HOSTNAME="node3.localdomain.local"
BOOTSTRAP_PASSWORD="Admin@123"

echo "##############################"
echo "Installing K3S"
echo "##############################"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$INSTALL_K3S_VERSION sh -s - server --cluster-init

echo "##############################"
echo "Install kubectl"
echo "##############################"
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF

yum repolist
yum install -y kubectl

echo "##############################"
echo "Setup Kubernetes path"
echo "##############################"
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
source ~/.bashrc

echo "##############################"
echo "Install Helm"
echo "##############################"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
./get_helm.sh

echo "##############################"
echo "Adding Rancher Prerequisites"
echo "##############################"
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
kubectl apply -f $CERTIFICATE_MANAGER
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace

echo "##############################"
echo "Installing Rancher"
echo "##############################"
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=$HOSTNAME \
  --set replicas=1 \
  --set bootstrapPassword=$BOOTSTRAP_PASSWORD

echo "-----------------------------------------------------"
echo "Rancher installation completed successfully!"
echo "-----------------------------------------------------"