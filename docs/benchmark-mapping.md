# Benchmark mapping policy

## Baseline

The profile uses the **CIS Ubuntu Linux 24.04 LTS Benchmark v2.0.0, Level 1
Server**, published 2026-05-28, as its source template. Its identifier is
`ubuntu-24.04-l1-server`.

The source inventory contains 258 recommendations: 246 marked Automated and 12
marked Manual by the benchmark. The project records the source document SHA-256
as `9486caebef04f5d3fbe534930ec4f88506ef6deb292d270ee578488cbc991736` so
catalog provenance can be checked without redistributing the PDF.

This profile is a NixOS-native interpretation of security intent. It is not an
Ubuntu implementation, CIS Build Kit, or evidence of CIS certification. The
generated report records this distinction in `profile.alignment`.

## Complete catalog and applicability

Every Level 1 Server recommendation is represented in the generated report,
including controls that static Nix evaluation cannot prove. Each has exactly
one applicability classification:

| Value | Meaning |
| --- | --- |
| `native` | The intent maps directly to evaluated NixOS options. |
| `adapted` | The intent applies, but NixOS implements it differently. |
| `runtime` | Evaluation cannot prove the resulting runtime state. |
| `not-applicable` | The recommendation is Ubuntu-specific or superseded by the NixOS architecture. |
| `unsupported` | The recommendation applies, but no reliable NixOS validation exists yet. |

`native` and `adapted` recommendations may produce a static pass or failure.
The other classes remain visible as coverage gaps or architectural decisions;
they cannot warn or block a build.

## Validation phases

The report distinguishes how evidence can be obtained:

- `evaluation`: inspect the fully merged NixOS module configuration without
  building the system closure.
- `build-artifact`: inspect generated configuration or another derivation.
- `runtime`: inspect mutable state on a running machine.
- `none` or `unavailable`: no validation is applicable or implemented.

The current implementation performs evaluation checks. Build-artifact and
runtime phases are extension points and are never represented as passing
without evidence.

## Mapping requirements

A static evaluator is ready when it has:

1. The exact recommendation number from the reviewed source inventory.
2. A native or adapted NixOS applicability decision.
3. A deterministic check against the merged NixOS configuration.
4. Original NixOS-specific description and remediation text.
5. Evidence containing expected and evaluated values without secrets.
6. Coverage through the profile and failure-mode flake checks.

Conditional controls can return `not-applicable` for a particular evaluation.
For example, chrony-specific checks are not applicable when chrony is not the
selected time synchronization implementation.

Ubuntu package-manager checks, mutable file ownership and mode checks, and
commands that assume Ubuntu filesystem paths are not translated mechanically.
They are classified as not applicable, deferred to build-artifact/runtime
validation, or left unsupported until a reliable NixOS invariant exists.

## Source usage

CIS retains rights in its benchmark content. This repository stores the short
inventory identifiers and titles required to identify recommendations, plus
original NixOS-specific mappings. It does not redistribute the source PDF or
copy its detailed rationale, audit, or remediation prose. Project language
uses “CIS-aligned” and “derived mapping” and does not claim certification.
