# Manual Node Bootstrap

Use this reference only if the new VM does not already have passwordless SSH access and passwordless `sudo` configured.

## Terraform credentials

If Terraform operations are needed as part of the node onboarding flow, load the environment from `terraform/.env` before running Terraform:

```bash
cd terraform
set -a
source .env
set +a
```

After loading `.env`, run the required Terraform command from the same shell session.

## Copy SSH key

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@<worker-ip>
```

## Configure passwordless sudo

SSH to the worker and edit:

```bash
sudo vi /etc/sudoers.d/ubuntu
```

Add:

```text
ubuntu ALL=(ALL) NOPASSWD:ALL
```

Then set the expected permissions:

```bash
sudo chmod 440 /etc/sudoers.d/ubuntu
```

## Run node preparation

```bash
cd ansible
ansible-playbook playbooks/k8s-node-prep.yaml --limit <new-host-name>
```

## Join the cluster

On a control-plane node, generate the join command:

```bash
sudo kubeadm token create --print-join-command
```

Run that generated command on the new worker node.

## Verify

```bash
kubectl get nodes
```
