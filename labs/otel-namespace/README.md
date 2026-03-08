# OTel Namespace Lab

This lab creates an isolated Kubernetes namespace layout for OpenTelemetry experiments.

## Goal

Create a repeatable namespace setup so telemetry pipelines can be tested without affecting
other workloads in the cluster.

## What this lab provisions

- `otel-lab` namespace for application workloads
- `otel-system` namespace for shared telemetry components
- Namespace labels/annotations for environment and ownership

## Prerequisites

- `kubectl` configured to point to a reachable cluster
- Permissions to create namespaces

## Run

```bash
ansible-playbook playbooks/otel_namespace_lab_up.yml
```

## Tear down

```bash
ansible-playbook playbooks/otel_namespace_lab_down.yml
```
