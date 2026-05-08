---
name: add-k8s-worker
description: Use when adding a new worker node to the homelab kubeadm Kubernetes cluster. Follows the repo's Terraform and Ansible patterns, updates the worker inventory, and guides the remaining bootstrap, join, and verification steps.
---

# Add K8s Worker

Use this skill when the user wants to add a new worker node to the existing homelab Kubernetes cluster.

The goal is to automate repo changes where possible and keep manual operational steps explicit.

## Inputs to gather

- Worker hostname, for example `worker-node-3`
- Worker IP address
- Any VM-specific settings not inferable from existing worker definitions in `terraform/main.tf`

If these inputs are missing, inspect the existing Terraform and Ansible patterns first, then ask only for the missing values.

## Workflow

1. Inspect `terraform/main.tf` and existing worker node definitions.
2. Before running any Terraform command, load credentials from `terraform/.env`:

```bash
cd terraform
set -a
source .env
set +a
```

3. Confirm the required Terraform credentials are present in the environment after loading `.env`. If they are missing, stop and tell the user Terraform cannot be run yet.
4. Add the new VM to Terraform by following the existing worker node pattern closely.
5. Run or recommend the appropriate Terraform command from the `terraform` directory after loading `.env`.
6. Update `ansible/inventory/hosts.yaml` under `k8s_workers` with the new host and IP.
7. Check whether passwordless SSH and passwordless `sudo` are already handled elsewhere in the repo or image template.
8. If bootstrap is still manual, read `references/node-bootstrap.md` and tell the user exactly which steps remain manual.
9. Run or recommend:

```bash
cd ansible
ansible-playbook playbooks/k8s-node-prep.yaml --limit <new-host-name>
```

10. Instruct the user to generate a join command on a control-plane node:

```bash
sudo kubeadm token create --print-join-command
```

11. Tell the user to run the generated join command on the new worker.
12. Verify cluster membership with:

```bash
kubectl get nodes
```

## Editing guidance

- Preserve the naming and formatting conventions already used in Terraform and Ansible.
- Do not invent new infrastructure patterns if the existing worker definitions are clear.
- Prefer `set -a; source .env; set +a` from the `terraform` directory when Terraform credentials are stored in `terraform/.env`.
- Do not print secret values back to the user. It is enough to confirm whether required variables are present.
- If the repo state suggests SSH bootstrap or `sudoers` is already automated, prefer the repo implementation over the manual reference.
- Keep the user informed about which steps were completed in-repo and which must still be run against live hosts.

## References

- For manual SSH and `sudoers` bootstrap, read `references/node-bootstrap.md`.
