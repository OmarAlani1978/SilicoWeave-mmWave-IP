# Block 04 – 15–20 GHz PLL + 60 GHz LO Generator (SG13G2)

## 1. Context and goal

SilicoWeave targets a low-power 60 GHz RX/TX reference front-end on IHP SG13G2, built with open-source tools (xschem, ngspice, KLayout, openEMS).
Blocks 01–03 cover LNA, 60 GHz VCO, and PA driver. Block 04 provides the missing frequency synthesis: a mid-GHz PLL plus 60 GHz LO generation suitable for short-range FMCW radar and fixed 60 GHz links.

Primary commercial focus: privacy-preserving presence sensing and smart-building radar in Belgium/EU, with reuse for industrial/robotics and link demos.

## 2. High-level requirements (v1)

- Process: IHP SG13G2 (open PDK).
- Tools: xschem (schematic), ngspice (sim, with HICUM/L2), KLayout (layout/DRC/LVS), openEMS + gdsfactory (EM).
- PLL output band: single band around 16–18 GHz (integer-N, no fractional-N in v1).
- Reference: external 100–200 MHz clock (single-ended or differential).
- 60 GHz LO: one differential/pseudo-differential LO output to drive:
  - RX mixer (future integration with LNA),
  - PA driver in TX mode.

Performance targets (v1, "reference-grade"):
- Phase noise / jitter: sufficient for short-range 60 GHz FMCW presence radar and fixed point-to-point links, not yet optimized for automotive-grade long-range.
- Power:
  - PLL core (15–20 GHz): ~10–30 mW target.
  - 60 GHz multiplier/ILFD: minimized but secondary to achieving robust LO at 60 GHz.
- Area: compatible with IHP OpenMPW shuttle cost; no aggressive area optimization in v1.

## 3. Architecture decision

Chosen architecture:

- Mid-GHz integer-N PLL at ~16–18 GHz:
  - 15–20 GHz HBT LC VCO (Sub-block 4.1).
  - PFD + charge pump + external RC loop filter (Sub-block 4.2).
  - High-speed divider chain to reference frequency (Sub-block 4.3).

- 60 GHz LO generation:
  - Start with a frequency multiplier (×3 from ~20 GHz, or ×4 from ~15 GHz).
  - Implemented as a compact RF macro (Sub-block 4.4) using nonlinear HBT stages and tuned networks, conceptually similar to a small PA/driver optimized for harmonic power.

Rationale:

- Keeps the "hard RF" part (60 GHz) in a small, self-contained macro that can be iterated independently.
- Reuses mid-GHz PLL IP for future bands (24/77 GHz) by changing multiplier and tank design.
- Compatible with open-source flow: PLL loop modeling can be done in Verilog-A/ngspice; EM is localized to VCO passives and 60 GHz multiplier passives.

Non-goals for v1:

- No broadband multi-band synthesizer.
- No sigma-delta fractional-N.
- No on-chip reference (assumes crystal/clock off-chip).
- No full automotive-grade PVT/corner coverage.

## 4. Sub-block partition

- 4.1 – 15–20 GHz VCO
  - Differential LC VCO using SG13G2 HBT + MIM caps.
  - Deliver Verilog-A model for fast PLL simulations.
  - Design for robust startup and reasonable Q, not minimum area.

- 4.2 – PFD + charge pump + loop filter interface
  - Classic tri-state PFD + current-steering charge pump.
  - Loop filter as off-chip RC for first silicon (optionally on-chip later).
  - Specs chosen for stable loop dynamics and acceptable lock time for presence sensing.

- 4.3 – Divider chain
  - Static/CML divider stages to bring 15–20 GHz down to the reference.
  - Optionally expose a low-frequency divided clock for lock detection and digital domains.

- 4.4 – 60 GHz multiplier / injection-locked stage
  - First iteration: passive/active multiplier chain (×3/×4).
  - Future option: injection-locked 60 GHz oscillator locked to the mid-GHz PLL.
  - Deliver one standardized 60 GHz LO port for RX and TX.

Each sub-block gets:
- `schematics/` cell(s),
- dedicated `testbenches/`,
- own `layout/` cell(s),
- documented results in `simulation_results/` and `docs/`.

## 5. Simulation and modeling plan

Phase 1 – Behavioral:
- Verilog-A models for VCO, PFD, charge pump, divider, and loop filter in ngspice.
- Explore loop stability, lock time, and rough phase noise.
- Keep reference frequency and N modest.

Phase 2 – Transistor-level core:
- Replace behavioral VCO and divider with transistor-level implementations.
- Keep PFD/CP mostly behavioral for speed.
- Standalone RF sims for 60 GHz multiplier/ILFD with EM-extracted passives (openEMS).

Phase 3 – Integration:
- Co-simulate PLL + 60 GHz multiplier at a simplified level.
- Verify that 15–20 GHz LO and 60 GHz LO meet amplitude and frequency specs.

## 6. Integration into SilicoWeave portfolio

- Positioned as "15–20 GHz PLL + 60 GHz LO generator macro" for 60 GHz presence sensing and short-range links.
- Primary use: drive 60 GHz LNA/mixer and PA driver (Blocks 01–03).
- Secondary use: standalone PLL IP for mid-GHz bands and custom 60 GHz front-ends.

Roadmap:
- v1: open-source reference design for IHP OpenMPW, focused on presence sensing.
- v2+: improved phase noise, power, and optional fractional-N or multi-band support.
