# OTel Namespace Lab

This lab creates and validates a baseline Kubernetes namespace layout for OpenTelemetry experiments.

## Goal

Create a repeatable namespace and workload setup so telemetry pipelines can be tested without affecting
other workloads in the cluster.

## What this lab provisions

- `swinglines` namespace
  - fake metrics app exposing `/metrics`
- `observability` namespace
  - OpenTelemetry Collector
  - Prometheus
- Namespace labels/annotations for environment and ownership

## Prerequisites

- `kubectl` configured to point to a reachable cluster
- Permissions to create namespaces and workloads

## Run

```bash
ansible-playbook playbooks/otel_namespace_lab_up.yml
```

## Verify

```bash
ansible-playbook playbooks/otel_namespace_lab_verify.yml
```

## Tear down

```bash
ansible-playbook playbooks/otel_namespace_lab_down.yml
```
