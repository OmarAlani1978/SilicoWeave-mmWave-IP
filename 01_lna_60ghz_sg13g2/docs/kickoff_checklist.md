# Block 01 — 60 GHz LNA on SG13G2 — Kickoff Checklist

## Purpose

This checklist defines the gates that must be passed before Block 01 moves from architecture exploration into committed schematic capture.

## Checks

- [ ] Confirm SG13G2 open PDK installation and version in `silicoweave-env`.
- [ ] Confirm availability of HBT models and basic passive libraries.
- [ ] Freeze Block 01 working targets in `docs/architecture.md`: band, gain, NF, power, match, and stability.
- [ ] Define common source/load conditions and a shared bias power budget for all candidate topologies A–D.
- [ ] Define a single architecture-exploration simulation convention: frequency sweep range, S-parameter ports, noise setup, and stability evaluation range.
- [ ] Implement minimal exploratory schematics for candidates A–D, without building a full hierarchy yet.
- [ ] Run S-parameter, NF, match, and stability simulations for all candidates under identical conditions.
- [ ] Record the candidate comparison in `docs/architecture.md` or a linked architecture note.
- [ ] Select one baseline topology and record why the others were rejected.
- [ ] Only after this selection, create the full schematic hierarchy under `schematics/` and start layout-aware work.

## Exit condition

Block 01 exits kickoff only when one baseline topology is selected and its choice is documented against the shared scoring conditions above.
