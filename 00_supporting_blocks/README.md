# Supporting Blocks

> Re-usable infrastructure cells used across Blocks 01–03.

These are not headline IP blocks — they are the supporting analog plumbing every mmWave block needs. Designed once, re-used three times.

## Planned cells

| Cell | Purpose | Status |
|---|---|---|
| Bandgap reference (SG13G2) | Stable on-chip V_REF and bias for all blocks | ⚪ Planned |
| Current mirror / bias network | Distributed PTAT/CTAT bias for cascode / cascode-CE stages | ⚪ Planned |
| Decoupling cell (MIM + MOS) | On-chip supply decoupling for mmWave blocks | ⚪ Planned |
| ESD-friendly RF pad cell | GSG and DC pad cells with ESD compliant for V-band | ⚪ Planned |

## Notes

- The SG13G2 bandgap here is the SilicoWeave portfolio version of what was prototyped in the personal `ASIC-portfolio` repo (sky130, BJT + opamp).
- Cells in this folder are versioned independently of headline blocks so a fix here doesn't churn the headline-block repos unnecessarily.
