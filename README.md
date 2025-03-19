# Rancher RKE2 Single Node Cluster with AWX Installation

This repository provides a structured approach to deploying a **Rancher RKE2 single-node cluster** and then installing **AWX** on top of Rancher. The setup is divided into two main parts:

1. **Rancher RKE2 Setup** - Using a script to automate the installation.
2. **AWX Installation** - Using Ansible to deploy AWX on top of the Rancher-managed Kubernetes cluster.

## Part 1: Deploying a Rancher RKE2 Single Node Cluster

### Prerequisites
- A Linux server (Ubuntu 20.04+ or RHEL-based OS recommended)
- Root or sudo privileges
- Internet connectivity

### Steps to Install RKE2

1. **Run the RKE2 Installation Script**

   Navigate to the `Rancher/Single_Node_Cluster/` directory and execute the installation script:
   
   ```bash
   chmod +x rke2_script.sh
   ./rke2_script.sh
   ```

   This script will:
   - Install RKE2 (lightweight Kubernetes from Rancher)
   - Start and enable the RKE2 server
   - Configure `kubectl` to use the new cluster
   - Install Helm (for Rancher installation)
   - Install Rancher Cluster Management (optional)

2. **Verify the Installation**

   ```bash
   kubectl get nodes
   ```

   You should see a single node in `Ready` state.

3. **Access Rancher UI**
   - Open `https://rancher.example.com` in a browser.
   - Log in using the default username `admin` and the bootstrap password.

---

## Part 2: Installing AWX using Ansible

### Prerequisites
- Ansible installed on your machine.
- `kubectl` configured to interact with the RKE2 cluster.
- A running Rancher-managed Kubernetes cluster.

### Steps to Deploy AWX

1. **Navigate to the AWX Directory**
   ```bash
   cd AWX/
   ```

2. **Run the Ansible Playbook**
   ```bash
   ansible-playbook provision_awx.yaml
   ```

   This playbook will:
   - Create necessary namespaces for AWX.
   - Deploy AWX Operator using Helm.
   - Configure PostgreSQL for AWX.
   - Deploy the AWX instance.

3. **Verify the Deployment**
   ```bash
   kubectl get pods -n awx
   ```
   Ensure that all AWX-related pods are running.

4. **Monitor Logs**
   - Monitor AWX Pods logs:
     ```bash
     kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager -n awx
     ```
   - Once the AWX jobs get completed it will print the Ansible job status. 
     ```bash
     PLAY RECAP *********************************************************************
     localhost                  : ok=88   changed=0    unreachable=0    failed=0    skipped=85   rescued=0    ignored=1   

     ```


5. **Access AWX UI**
   - Get the AWX service URL:
     ```bash
     kubectl get svc -n awx
     ```
   - Open the AWX URL in a browser and log in with the default credentials.

---