# Contributing to SilicoWeave mmWave IP

> SilicoWeave is currently a single-maintainer project. External contributions are welcomed but limited in scope until the first headline block (60 GHz LNA) is silicon-validated.

## What we accept right now

- **Bug reports** — broken testbenches, simulation errors, doc typos.
- **Documentation improvements** — clearer design notes, references, integration guides.
- **Methodology suggestions** — better testbench templates, EM-aware layout tips for SG13G2.
- **Cross-checks** — independent simulation of committed schematics on a different setup.

## What we do not accept right now

- New top-level blocks — the portfolio scope (LNA → VCO → PA driver) is intentionally narrow.
- Pull requests against silicon-validated cells without prior discussion.
- IP contributions without clear provenance and a signed contributor agreement (see below).

## Contributor IP / provenance

Because this repo is the foundation of a commercial IP portfolio, **all contributions to circuit designs (schematics, layouts, testbenches that meaningfully affect a design)** require:

1. A statement that the contributor is the sole author and has the right to license the work.
2. Agreement that the contribution is licensed under the repo's Apache-2.0 design license.
3. For non-trivial design contributions: a brief signed Contributor License Agreement (will be provided on request).

Documentation contributions (CC BY 4.0) only require attribution.

## Workflow

1. Open an issue describing the proposed change before opening a PR.
2. Branch off `main` with a descriptive name (e.g. `lna/feedback-cap-tweak`).
3. Keep PRs focused — one logical change per PR.
4. Include simulation results / DRC / LVS clean reports for any design change.

## Code of conduct

Be technically honest and personally respectful. That's it.
