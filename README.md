# Armada


    #      ####    #   #     #     ####      #   
  # #     #   #   ## ##    # #     #   #    # #  
 #   #    #   #   # # #   #   #    #    #  #   # 
 #   #    ####    #   #   #   #    #    #  #   # 
 #####    # #     #   #   #####    #    #  ##### 
 #   #    #  #    #   #   #   #    #   #   #   # 
 #   #    #   #   #   #   #   #    ####    #   # 


Armada is a collection of Ansible playbooks for managing Docker images and registries.  
Think of it as your fleet of automation tools for container cleanup, retagging, and migration. 🚢

## Features

- **Prune dangling images**  
  Clean up `<none>` images safely and idempotently.

- **Retag and push images**  
  Retag images to a new registry/namespace and push them, with support for dry-run mode.

## Project Structure

- `ansible.cfg` – base Ansible config
- `requirements.yml` – Ansible collections required (`community.docker`, etc.)
- `inventories/` – inventory files (ships in your fleet!)
- `group_vars/` – variables such as registry creds, namespaces, and image lists
- `playbooks/` – where the magic happens (`docker_prune.yml`, `retag_and_push.yml`)
- `Makefile` – shortcuts for common tasks

## Usage

### Install dependencies
```bash
make install
```

### Run the prune playbook
```bash
make prune
```

### Retag and push images
```bash
make retag
```

### Security 
```.bash
ansible-vault create group_vars/all/registry.vault.yml
```

Then include it in your playbook. 