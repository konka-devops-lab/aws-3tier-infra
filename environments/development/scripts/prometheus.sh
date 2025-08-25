#!/bin/bash
sudo dnf update -y
sudo dnf install ansible git -y
git clone https://github.com/konka-devops-lab/ansible-roles.git
cd ansible-roles/playbooks
ansible-playbook prometheus.yml -i "localhost," --connection=local