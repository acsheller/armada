.PHONY: install prune retag kind-up kind-down

DRYRUN ?= 0
RUN = $(if $(filter 1 yes true on,$(DRYRUN)),echo,)

ANSIBLE_FLAGS ?=

install:
	$(RUN) ansible-galaxy collection install -r requirements.yml

prune:
	$(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/docker_prune.yml

retag:
	$(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/retag_and_push.yml

kind-up:
	$(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/kind_up.yml

kind-down:
	$(RUN) ansible-playbook $(ANSIBLE_FLAGS) playbooks/kind_down.yml
