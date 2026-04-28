# Block 01 — 60 GHz Low-Noise Amplifier (LNA) on IHP SG13G2

> **Status:** 🟡 Design starting · First headline block of the SilicoWeave mmWave IP portfolio.

## Goal

A silicon-proven, low-power 60 GHz LNA on IHP SG13G2 SiGe BiCMOS, suitable for V-band 5G FR2 small cells, 60 GHz unlicensed (802.11ad/ay) backhaul, and short-range mmWave radar receivers.

## Target specifications (preliminary — to be refined during architecture phase)

| Parameter | Target | Stretch | Notes |
|---|---|---|---|
| Frequency | 57–66 GHz | 50–70 GHz | V-band core, with margin |
| Gain (S21) | > 18 dB | > 22 dB | Two-stage cascode candidate |
| Noise Figure | < 4.0 dB | < 3.0 dB | Cold-bias / inductive degeneration |
| S11, S22 | < −10 dB | < −15 dB | Across band |
| P1dB (input) | > −20 dBm | > −15 dBm | |
| IIP3 | > −10 dBm | > −5 dBm | |
| DC power | < 10 mW | < 6 mW | "Low-power" is the differentiator |
| Supply | 1.5 V | 1.2 V | Single-rail target |
| Stability | k > 1, B1 > 0 | Unconditional | All conditions |
| Area (active) | < 0.4 mm² | < 0.3 mm² | Excluding pads |

## Design plan (high level)

1. **Architecture exploration** — cascode vs CE-CB stack, single- vs two-stage, source/emitter degeneration choice.
2. **Device sizing** — npn13G2 HBT emitter length, current density for NF_min (typically J_C ≈ 0.2–0.3 mA/μm² at 60 GHz on SG13G2).
3. **Matching network synthesis** — input (NF-optimal), inter-stage (gain), output (P1dB).
4. **Schematic-level verification** — S-parameter, NF, stability, P1dB, IIP3, PVT corners.
5. **Layout** — symmetric, EM-aware passives, ground rings, GSG pad ring.
6. **Post-layout EM/parasitic verification** — co-simulation with extracted passives.
7. **Tape-out preparation** — target IHP OpenMPW SG13G2 shuttle (Oct 2026 slot, GDS deadline Sep 21, 2026).

## Folder layout

- [`schematics/`](./schematics/) — xschem schematic files
- [`layout/`](./layout/) — KLayout `.gds` / `.oas` files
- [`testbenches/`](./testbenches/) — ngspice testbenches (SP, NF, P1dB, IIP3, PVT)
- [`simulation_results/`](./simulation_results/) — selected post-processed plots and data
- [`measurements/`](./measurements/) — silicon characterization data (post tape-out)
- [`docs/`](./docs/) — design notes, datasheet draft, integration guide

## References

To be filled in during the architecture-exploration phase. Initial sources of interest:

- IHP Open PDK documentation and example designs
- GeMiC 2025 / IEEE RFIC papers on 130 nm SiGe BiCMOS V-band LNAs
- IRDS 2024 Outside System Connectivity benchmark circuits
