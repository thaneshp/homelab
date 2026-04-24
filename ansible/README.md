# Ansible

Current playbooks:

- `playbooks/k8s-node-prep.yaml`: prepares Ubuntu nodes for `kubeadm`
- `playbooks/squid-proxy.yaml`: installs and manages Squid on hosts in the `proxy` inventory group

## Squid

1. Add your node under the `proxy` group in `inventory/hosts.yaml`.
2. Override `ansible_user` there if the Pi does not use the top-level `ubuntu` user.
3. Set `squid_allowed_cidrs` to the client networks that should be allowed to use the proxy.
4. Run:

```bash
cd ansible
ansible-playbook playbooks/squid-proxy.yaml
```

Example inventory entry:

```yaml
proxy:
  hosts:
    raspberry-pi:
      ansible_host: 192.168.4.90
      squid_allowed_cidrs:
        - 192.168.4.0/24
```

The playbook manages:

- the `squid` package
- the `squid` service state
- `/etc/squid/squid.conf`
- UFW rules for `22/tcp` and `3128/tcp` when `ufw` is installed
- UFW default policies of `deny incoming` and `allow outgoing` when `ufw` is installed
