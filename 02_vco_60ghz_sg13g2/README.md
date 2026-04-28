# Block 02 — 60 GHz VCO with PLL-friendly tuning on IHP SG13G2

> **Status:** ⚪ Planned · Begins after Block 01 (LNA) reaches schematic-verified milestone.

## Goal

A wide-tuning, low-power, low-phase-noise 60 GHz VCO on IHP SG13G2 SiGe BiCMOS, packaged with a VerilogA behavioural model for system-level (PLL/transceiver) integration.

## Why VCO is the right Block 02

- Phase noise is the single hardest mmWave parameter to design well — a clean characterized VCO is highly sellable.
- SG13G2's HBTs (fT 250 / fmax 340 GHz) are ideal for low-phase-noise mmWave LC-tank VCOs.
- The IHP OpenMPW community has already taped out VCOs and ring oscillators, so methodology is proven and benchmarks exist.
- Pairs naturally with Block 01 (LNA) and Block 03 (PA driver) as the "front-end half of a V-band RX chain."

## Target specifications (preliminary)

| Parameter | Target | Stretch | Notes |
|---|---|---|---|
| Centre frequency | 60 GHz | 60 GHz | V-band |
| Tuning range | > 8 GHz (≈14%) | > 12 GHz (≈20%) | Switched-cap + varactor |
| Phase noise @ 1 MHz offset | < −95 dBc/Hz | < −105 dBc/Hz | Core differentiator |
| Phase noise @ 10 MHz offset | < −115 dBc/Hz | < −125 dBc/Hz | |
| Output power (single-ended) | > −5 dBm | > 0 dBm | Into 50 Ω |
| DC power | < 20 mW | < 12 mW | Core + buffer |
| Supply | 1.5 V | 1.2 V | |
| Pulling figure of merit (FoM) | > 180 dBc/Hz | > 185 dBc/Hz | |
| Area (active) | < 0.5 mm² | < 0.35 mm² | Excluding pads |

## Deliverables

- xschem schematic and ngspice testbench (PSS / phase noise / pulling)
- KLayout layout with EM-aware tank inductor and varactor matching
- Measured silicon data (post-MPW)
- **VerilogA behavioural model** with frequency, phase noise, and tuning curves — usable in customer transceiver simulations
- Datasheet + integration guide

## Folder layout

Same structure as Block 01.
