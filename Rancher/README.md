# Rancher with K3S Installation Script

This repository provides a script to automate the installation of Rancher using K3S on a Linux server. The script installs K3S, kubectl, Helm, and sets up Rancher along with the necessary prerequisites.

## Prerequisites

- A Linux server (e.g., CentOS, RHEL) with `sudo` privileges.
- Internet access for downloading packages.

## Script Overview

The script performs the following tasks:

1. **Install K3S**: A lightweight Kubernetes distribution.
2. **Install kubectl**: The command-line tool for interacting with Kubernetes.
3. **Set up the Kubernetes configuration path**: Allows access to the K3S cluster.
4. **Install Helm**: A package manager for Kubernetes.
5. **Add Rancher prerequisites**: Sets up necessary Helm repositories and installs cert-manager.
6. **Install Rancher**: Deploys the Rancher server.

## Variables

The following variables can be adjusted at the beginning of the script:

- `INSTALL_K3S_VERSION`: Specifies the version of K3S to install. 
- `CERTIFICATE_MANAGER`: URL for the cert-manager Custom Resource Definitions (CRDs).
- `HOSTNAME`: The hostname for accessing the Rancher UI.
- `BOOTSTRAP_PASSWORD`: The initial password for the Rancher admin user.