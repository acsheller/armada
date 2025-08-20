SHELL := /bin/bash
.ONESHELL:
.DEFAULT_GOAL := help

.PHONY: help venv install prune retag kind-up kind-down lint clean

# Toggles
DRYRUN ?= 0
RUN = $(if $(filter 1 yes true on,$(DRYRUN)),echo,)
ANSIBLE_FLAGS ?=

# Helper
ACT = source .venv/bin/activate

help: ## List available targets
	@awk -F':.*##' '/^[a-zA-Z0-9_.-]+:.*##/ {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

venv: ## Create venv and install Python deps & collections
	python3 -m venv .venv
	$(ACT); pip install --upgrade pip
	$(ACT); pip install -r requirements.txt
	$(RUN) ansible-galaxy collection install -r requirements.yml -p ./collections

install: ## Install/refresh Ansible Galaxy collections
	$(RUN) ansible-galaxy collection install -r requirements.yml -p ./collections

prune: ## Remove dangling (<none>) images
	$(ACT); $(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/docker_prune.yml

retag: ## Retag & push images to new registry
	$(ACT); $(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/retag_and_push.yml

kind-up: ## Create KinD cluster
	$(ACT); $(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/kind_up.yml
	@echo "👉 To use this cluster, run:"
	@echo "   export KUBECONFIG=$(PWD)/.kube/kind-armada-dev.yaml"

kind-down: ## Delete KinD cluster
	$(ACT); $(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/kind_down.yml
	@echo "👉 If you had KUBECONFIG set, you may unset it now:"
	@echo "   unset KUBECONFIG"
	$(RUN) rm -f $(PWD)/.kube/kind-armada-dev.yaml

lint: ## Run ansible-lint
	$(ACT); ansible-lint

clean: ## Remove local collections cache
	rm -rf ./collections
