# Benchmark mapping policy

## Baselines

The module contains complete Level 1 Server inventories for these source
benchmarks:

| Identifier | Benchmark version | Published | Automated | Manual | Unspecified | Total |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| `ubuntu-24.04-l1-server` | Ubuntu Linux 24.04 LTS v2.0.0 | 2026-05-28 | 246 | 12 | 0 | 258 |
| `debian-13-l1-server` | Debian Linux 13 v1.0.0 | 2025-12-16 | 249 | 13 | 0 | 262 |
| `almalinux-10-l1-server` | AlmaLinux OS 10 v1.0.0 | 2025-09-30 | 231 | 17 | 0 | 248 |
| `rhel-10-l1-server` | Red Hat Enterprise Linux 10 v1.0.1 | 2025-09-30 | 231 | 17 | 0 | 248 |
| `rocky-linux-10-l1-server` | Rocky Linux 10 v1.0.0 | 2025-09-30 | 231 | 17 | 0 | 248 |
| `amazon-linux-2-l1-server` | Amazon Linux 2 v4.0.0 | 2026-03-26 | 0 | 0 | 225 | 225 |

Each profile records the source document SHA-256 in its report metadata so
catalog provenance can be checked without redistributing the PDFs.

Amazon Linux 2 v4.0.0 omits Automated and Manual labels from its rendered
recommendation pages. The catalog preserves those assessments as unspecified;
it does not infer labels from older benchmark versions or audit prose.

These profiles are NixOS-native interpretations of security intent. They are
not implementations of the source distributions, CIS Build Kits, or evidence
of CIS certification. The generated report records this distinction in
`profile.alignment`.

## Evaluator reuse

Recommendation numbers are local to a benchmark and are never assumed to have
the same meaning across profiles. Shared evaluators are inherited only when the
reviewed recommendation title matches exactly. Profile-family overlays then
handle controls whose NixOS adaptation differs, including APT and RPM package
management, SELinux-to-AppArmor intent, firewalld-to-NixOS-firewall intent,
time synchronization, and journal upload.

## Complete catalog and applicability

Every Level 1 Server recommendation is represented in the generated report,
including controls that static Nix evaluation cannot prove. Each has exactly
one applicability classification:

| Value | Meaning |
| --- | --- |
| `native` | The intent maps directly to evaluated NixOS options. |
| `adapted` | The intent applies, but NixOS implements it differently. |
| `runtime` | Evaluation cannot prove the resulting runtime state. |
| `not-applicable` | The recommendation is distribution-specific or superseded by the NixOS architecture. |
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

Distribution package-manager checks, mutable file ownership and mode checks,
and commands that assume distribution-specific filesystem paths are not
translated mechanically. They are classified as not applicable, deferred to
build-artifact/runtime validation, or left unsupported until a reliable NixOS
invariant exists.

## Source usage

CIS retains rights in its benchmark content. This repository stores the short
inventory identifiers and titles required to identify recommendations, plus
original NixOS-specific mappings. It does not redistribute the source PDF or
copy its detailed rationale, audit, or remediation prose. Project language
uses “CIS-aligned” and “derived mapping” and does not claim certification.
