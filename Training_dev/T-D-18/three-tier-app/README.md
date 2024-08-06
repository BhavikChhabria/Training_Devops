# Three-Tier Web Application Deployment

## Overview

This project deploys a three-tier web application using Ansible roles. The application consists of:
- An Nginx frontend
- A Node.js backend
- A MySQL database

## Prerequisites

- Ansible installed on the control node
- SSH access to all the target hosts

## Project Structure

```
three-tier-app/
├── group_vars/
│   ├── all.yml
├── host_vars/
├── inventory/
│   ├── hosts.ini
├── roles/
│   ├── frontend/
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   ├── templates/
│   │   ├── meta/
│   │   │   ├── main.yml
│   ├── backend/
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   ├── templates/
│   │   ├── meta/
│   │   │   ├── main.yml
│   ├── database/
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   ├── templates/
│   │   ├── meta/
│   │   │   ├── main.yml
├── playbooks/
│   ├── deploy.yml
│   ├── test.yml
├── README.md
```

## Usage

1. Clone the repository.
2. Install the required roles from Ansible Galaxy.
3. Update the inventory file with your hosts.
4. Customize variables in `group_vars/all.yml`.
5. Run the deployment playbook:
    ```sh
    ansible-playbook playbooks/deploy.yml -i inventory/hosts.ini
    ```
6. Test the deployment:
    ```sh
    ansible-playbook playbooks/test.yml -i inventory/hosts.ini
    ```

## Role Dependencies

Dependencies for each role are defined in the `meta/main.yml` files.

```
frontend/meta/main.yml:
dependencies:
  - role: geerlingguy.nginx

backend/meta/main.yml:
dependencies:
  - role: geerlingguy.nodejs
  - role: database

database/meta/main.yml:
dependencies:
  - role: geerlingguy.mysql
```
