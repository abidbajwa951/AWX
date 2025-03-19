# README - Ansible Playbook for AWX Installation

## Overview
This playbook automates the installation of **AWX** on a Kubernetes cluster managed by Rancher RKE2. It uses **Kustomize** to deploy the **AWX Operator** and provisions the necessary **Persistent Volumes (PV) and Persistent Volume Claims (PVC)** for project storage.

## Playbook Details
### Hosts:
- The playbook runs on **localhost**, assuming you have `kubectl` configured to interact with the Kubernetes cluster.

### Variables:
| Variable | Description | Default |
|----------|-------------|---------|
| `awx_namespace` | Kubernetes namespace for AWX deployment | `awx` |
| `project_directory` | Directory path for AWX project storage | `/var/lib/awx/projects` |
| `storage_size` | Storage size for persistent volume | `15Gi` |

## Tasks Breakdown

### 1. Install Kustomize
- Downloads and installs **Kustomize** to `/usr/local/bin/` if not already present.

### 2. Create the AWX Namespace
- Ensures the namespace **awx** exists in Kubernetes.

### 3. Generate AWX Resource File (`awx.yaml`)
- Defines an AWX deployment with:
  - **NodePort Service** (Port `30060`)
  - **Persistent Project Storage**

### 4. Fetch Latest AWX Operator Release
- Retrieves the latest release version of **AWX Operator** from GitHub.

### 5. Create Persistent Volume and PVC Configuration
- Generates `pv.yml` and `pvc.yml` for AWX project storage.
- **HostPath** is set to `project_directory` for local storage.

### 6. Create Kustomization Configuration (`kustomization.yaml`)
- Uses **Kustomize** to:
  - Reference the latest **AWX Operator** release.
  - Apply **PV, PVC, and AWX resource configurations**.

### 7. Deploy AWX using Kustomize
- Builds and applies the Kustomization manifest using `kubectl`.

## Deployment Steps
1. Ensure you have **Ansible** installed and `kubectl` configured.
2. Run the playbook:
   ```bash
   ansible-playbook provision_awx.yaml
   ```
3. Verify deployment:
   ```bash
   kubectl get pods -n awx
   ```
   All pods should be in a **Running** state.
4. Access AWX:
   - Find the AWX service:
     ```bash
     kubectl get svc -n awx
     ```
   - Open `http://<node-ip>:30060` in a browser.

