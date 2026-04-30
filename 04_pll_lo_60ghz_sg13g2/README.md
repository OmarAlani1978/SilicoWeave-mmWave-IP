# Block 04 — 15–20 GHz PLL + 60 GHz LO Generator on IHP SG13G2

> **Status:** ⚪ Architecture / spec phase · Frequency-synthesis macro for the SilicoWeave V-band front-end.

## Goal

A reference-grade integer-N PLL operating in the 15–20 GHz range, paired with a 60 GHz LO multiplier macro, on IHP SG13G2 SiGe BiCMOS. Provides the missing frequency-synthesis path for the SilicoWeave 60 GHz RX/TX front-end (Blocks 01–03) and a reusable mid-GHz PLL IP for adjacent bands.

## Target use

- Drive the 60 GHz LNA/mixer (Block 01) and PA driver (Block 03) from a single, locked LO.
- Enable short-range FMCW presence-sensing radar and fixed 60 GHz point-to-point links.
- Serve as a standalone mid-GHz integer-N PLL macro for partner projects targeting 16–18 GHz.

## Target specifications (preliminary — v1, "reference-grade")

| Parameter | Target | Stretch | Notes |
|---|---|---|---|
| PLL output band | 16–18 GHz | 15–20 GHz | Single-band, integer-N |
| Reference clock | 100–200 MHz | 100–200 MHz | External, single-ended or differential |
| 60 GHz LO output | 1 differential / pseudo-diff port | — | Drives RX mixer + PA driver |
| Phase noise / jitter | Sufficient for short-range 60 GHz FMCW | Better than -90 dBc/Hz @ 1 MHz at 60 GHz | Not yet automotive-grade |
| PLL core power (15–20 GHz) | 10–30 mW | < 10 mW | |
| 60 GHz multiplier power | Minimized, secondary to robust LO | — | |
| Lock time | Compatible with presence-sensing chirps | — | |
| Supply | 1.5 V | 1.2 V | Shared with Blocks 01–03 |
| Area | OpenMPW-shuttle compatible | — | No aggressive optimization in v1 |

## Sub-blocks

- **4.1 — 15–20 GHz VCO** · Differential LC VCO using SG13G2 HBT + MIM caps; ships a Verilog-A model for fast PLL simulation.
- **4.2 — PFD + charge pump + loop-filter interface** · Tri-state PFD, current-steering charge pump, off-chip RC loop filter for first silicon.
- **4.3 — Divider chain** · Static / CML divider chain from 15–20 GHz down to the reference, with optional divided clock for lock detect.
- **4.4 — 60 GHz multiplier / injection-locked stage** · Compact RF macro (×3 from ~20 GHz or ×4 from ~15 GHz); future option: ILFD locked to the mid-GHz PLL.

## Deliverables

- xschem schematics for each sub-block and the integrated PLL + LO macro.
- ngspice testbenches: PLL loop dynamics (Verilog-A first), VCO PSS / phase noise, divider self-test, 60 GHz multiplier conversion gain and harmonic suppression.
- KLayout layout cells for each sub-block, with EM-extracted passives (openEMS) for VCO tank and 60 GHz multiplier.
- Verilog-A behavioural models for VCO, PFD, charge pump, divider, loop filter.
- Architecture decision document and integration guide for Blocks 01–03.

## Folder layout

- [`schematics/`](./schematics/) — xschem schematic files
  - [`04_1_vco_15to20ghz/`](./schematics/04_1_vco_15to20ghz/)
  - [`04_2_pfd_cp_loopfilter_if/`](./schematics/04_2_pfd_cp_loopfilter_if/)
  - [`04_3_divider_chain/`](./schematics/04_3_divider_chain/)
  - [`04_4_lo_60ghz_multiplier/`](./schematics/04_4_lo_60ghz_multiplier/)
- [`layout/`](./layout/) — KLayout `.gds` / `.oas` files (same sub-block split)
- [`testbenches/`](./testbenches/) — ngspice + Verilog-A testbenches (same sub-block split)
- [`simulation_results/`](./simulation_results/) — selected post-processed plots and data
- [`measurements/`](./measurements/) — silicon characterization data (post tape-out)
- [`docs/`](./docs/) — architecture decision, design notes, integration guide

## References

- [`docs/04_pll_lo_60ghz_architecture_decision.md`](./docs/04_pll_lo_60ghz_architecture_decision.md) — v1 architecture decision and sub-block partition.
- [Global EU pitch](../docs/block04_eu_presence_sensing_pitch.md) — commercial framing for Belgium/EU presence-sensing partners.
- IHP Open PDK documentation and OpenMPW VCO / PLL examples.
- IEEE RFIC / GeMiC papers on mid-GHz integer-N PLLs and 60 GHz LO multipliers in SiGe BiCMOS.
