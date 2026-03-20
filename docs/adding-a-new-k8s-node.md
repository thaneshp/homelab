# How to add a new K8s worker node to an existing cluster?

## Purpose

This document defines the process for adding a new worker node to the current K8s (`kubeadm`) homelab cluster.

Desired state: automate below process so that the process of onboarding a new node is involves less manual steps.

## Steps

1. Create a new VM in Terraform

    - Add terraform code to [terraform/main.tf](../terraform/main.tf) to create a new VM.

2. Add the host to Ansible [inventory](../ansible/inventory/hosts.yaml)

    ```yaml
    k8s_workers:
      hosts:
        worker-node-1:
          ansible_host: 192.168.4.83
        worker-node-2:
          ansible_host: 192.168.4.84
    ```

3. Bootstrap SSH/sudo access

    Copy your public SSH key over to the host.

    ```
    ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@192.168.4.69
    ```

    SSH into the host and edit the following `sudoers` file. 
    
    This is an additional `sudoers` file that contains rules for the `ubuntu` user.

    ```
    sudo vi /etc/sudoers.d/ubuntu
    ```
    
    Add the following to the `sudoers` file. This allows the `ubuntu` user to execute `sudo` commands without being asked for the password.

    ```
    ubuntu ALL=(ALL) NOPASSWD:ALL
    ```

    Update the permissions of the `sudoers.d` file. 
    
    This permission gives owners and group read only access, and others no access.

    ```
    sudo chmod 440 /etc/sudoers.d/ubuntu
    ```

5. Run the K8s node prep on the new host

    ```
    cd ansible
    ansible-playbook playbooks/k8s-node-prep.yaml --limit <new-host-name>
    # example:
    # ansible-playbook playbooks/k8s-node-prep.yaml --limit worker-node-3
    ```

6. Join the worker node

    SSH into the master node and run the following comamnd to generate a join command.

    ```
    ssh ubuntu@<master-node-ip>
    sudo kubeadm token create --print-join-command
    ```

    SSH into the worker node and run the generated join command.

7. Verify node status
    
    ```
    kubectl get nodes
    ```
