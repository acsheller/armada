SHELL := /bin/bash
.ONESHELL:
.DEFAULT_GOAL := help

.PHONY: help venv install prune retag kind-up kind-down lint clean fake-metrics fake-metrics-delete fake-metrics-status

# Toggles
DRYRUN ?= 0
RUN = $(if $(filter 1 yes true on,$(DRYRUN)),echo,)
ANSIBLE_FLAGS ?=

# Helper
ACT = source .venv/bin/activate

KUBECONFIG ?=
ANSIBLE_PLAYBOOK ?= ansible-playbook
FAKE_METRICS_NAMESPACE ?= swinglines
FAKE_METRICS_NAME ?= fake-metrics-app
FAKE_METRICS_IMAGE ?= python:3.11-slim
FAKE_METRICS_PORT ?= 8000

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

bootstrap:
	python3 -m venv .venv
	. .venv/bin/activate && pip install -r requirements.txt
	. .venv/bin/activate && ansible-galaxy collection install -r requirements.yml

fake-metrics: ## Deploy fake metrics app into Kubernetes
	$(ACT); KUBECONFIG=$(KUBECONFIG) FAKE_METRICS_NAMESPACE=$(FAKE_METRICS_NAMESPACE) FAKE_METRICS_NAME=$(FAKE_METRICS_NAME) FAKE_METRICS_IMAGE=$(FAKE_METRICS_IMAGE) FAKE_METRICS_PORT=$(FAKE_METRICS_PORT) \
		$(RUN) $(ANSIBLE_PLAYBOOK) $(ANSIBLE_FLAGS) playbooks/fake_metrics.yml

fake-metrics-delete: ## Delete fake metrics app resources from Kubernetes
	$(ACT); KUBECONFIG=$(KUBECONFIG) FAKE_METRICS_NAMESPACE=$(FAKE_METRICS_NAMESPACE) FAKE_METRICS_NAME=$(FAKE_METRICS_NAME) \
		$(RUN) $(ANSIBLE_PLAYBOOK) $(ANSIBLE_FLAGS) playbooks/fake_metrics_delete.yml

fake-metrics-status: ## Show fake metrics app resource status
	KUBECONFIG=$(KUBECONFIG) kubectl -n $(FAKE_METRICS_NAMESPACE) get all -l app=$(FAKE_METRICS_NAME)
