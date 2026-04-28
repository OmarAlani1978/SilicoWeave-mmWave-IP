# Block 03 — V-band PA Driver + RMS Power Detector on IHP SG13G2

> **Status:** ⚪ Planned · Begins after Block 02 (VCO).

## Goal

A low-power V-band power-amplifier driver stage with on-chip RMS power detection — a niche that's routinely needed inside mmWave transmitters but rarely sold standalone.

## Why a PA *driver* (not a full PA) for Block 03

- Full mmWave PAs require thermal management, load-pull characterization, and packaging that are too costly for an early-stage IP shop's first 18 months.
- A PA *driver* is the stage immediately preceding the final PA: smaller, lower power, cleaner to characterize, and re-usable across many PA architectures.
- Bundling an integrated **RMS power detector** turns this into a small reusable sub-system rather than a single block. Detectors are needed for transmit-power control loops in every mmWave system.

## Target specifications (preliminary)

### PA Driver

| Parameter | Target | Stretch |
|---|---|---|
| Frequency | 57–66 GHz | 50–70 GHz |
| Linear gain | > 12 dB | > 15 dB |
| Output P1dB | > 6 dBm | > 10 dBm |
| Output Psat | > 9 dBm | > 13 dBm |
| PAE @ P1dB | > 12% | > 18% |
| Supply | 1.8 V | 1.5 V |

### RMS Power Detector

| Parameter | Target |
|---|---|
| Detector range | −20 to +10 dBm |
| Frequency | V-band |
| Output | DC voltage proportional to RMS, with calibration LUT |
| Settling time | < 1 µs |
| Power | < 2 mW |

## Deliverables

- PA driver and RMS detector schematics + layouts
- ngspice testbenches incl. AM/PM, P1dB, Psat, PAE
- Measured silicon data (post-MPW)
- Calibration LUT + Python helper for detector curve fitting
- Datasheet + integration guide

## Folder layout

Same structure as Block 01.
