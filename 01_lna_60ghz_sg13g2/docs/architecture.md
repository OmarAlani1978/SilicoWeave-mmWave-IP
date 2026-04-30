# Block 01 — 60 GHz LNA on SG13G2 — Architecture Decision

## 1. Problem statement

Block 01 targets a compact 60 GHz low-noise amplifier in IHP’s SG13G2 SiGe BiCMOS process as the first element in a three-block V-band receive front-end reference: LNA, low-power mmWave VCO with PLL hooks, and PA driver with power detection.

The primary objective of this document is to lock the working specification and the short list of architectural options before any schematic skeleton is created. Once approved, this decision record governs Block 01 schematic capture, layout, and documentation.

## 2. System and portfolio context

The three initial SilicoWeave mmWave IP blocks are planned as:

- Block 01 — 60 GHz LNA on SG13G2.
- Block 02 — low-power mmWave VCO with PLL-friendly hooks.
- Block 03 — PA driver with integrated or companion power-detect path.

These blocks are intended to be packaged and sold together as a V-band receive-front-end reference platform rather than as isolated IP fragments. That drives Block 01’s requirements: its band, gain, noise, and power targets must leave headroom and compatibility for Blocks 02 and 03, not just look good in isolation.

For the first portfolio iteration, the reference band is the unlicensed 60 GHz range used for short-range wireless and radar-style front-ends.

## 3. Working specification for Block 01

### 3.1 Frequency band

- **Guaranteed operating band:** 57–66 GHz.
- **Stretch band (non-guaranteed):** usable performance up to ~70 GHz.

This framing is more commercially credible than a flat “60–80 GHz” claim, which would compound complexity for the VCO and PA driver without delivering proportionate value on first silicon.

### 3.2 Electrical targets at 60 GHz

| Parameter | Target | Hard limit | Notes |
|---|---:|---:|---|
| Center frequency | 60 GHz | — | Aligned with V-band RX applications. |
| Gain (S21) | 20 dB | >= 17 dB after extraction | Strong enough for a front-end anchor without forcing three stages by default. |
| Noise figure | 3.5 dB | <= 4.0 dB | Competitive but realistic for a first SG13G2 LNA. |
| DC power | 8 mW | <= 10 mW | Leaves budget for VCO and PA driver in the combined RX front-end. |
| Input match (S11) | <= -10 dB | <= -10 dB | Over 57–66 GHz with 50 ohm source. |
| Output match (S22) | <= -10 dB | <= -10 dB | Over 57–66 GHz into 50 ohm or representative next-stage load. |
| Stability (K, mu) | > 1 | > 1 | From ~1 GHz to at least 100 GHz, unconditional stability. |
| Linearity (IIP3) | about -10 to -15 dBm | — | Adequate for a practical RX front-end. |
| Input P1dB | about -20 dBm | — | Typical LNA-class large-signal target. |

These numbers are tuned to favor first-pass success and reuse inside a modest-power RX chain rather than headline-grabbing standalone performance.

## 4. Architecture options

### 4.1 Technology and device style

SG13G2 is a 0.13 um SiGe BiCMOS technology with HBTs suitable for compact V-band gain blocks. For Block 01, the RF signal path uses HBT devices, while MOS devices may be used in biasing and control where helpful.

### 4.2 Candidate topology families

For the first pass, architecture exploration focuses on two-stage HBT LNAs, with a possible escalation to three stages only if post-layout results cannot meet the gain target within the power budget.

| ID | Stage 1 | Stage 2 | Degeneration | Rationale |
|---|---|---|---|---|
| A | CE | CE | None | Simplest two-stage chain, maximizes raw gain but gives weak control of input match and NF. |
| B | CE | CE-CB cascode | None | Adds reverse isolation and bandwidth via a cascode second stage. |
| C | CE | CE | Inductive emitter degeneration in stage 1 | Prioritizes NF and input match while keeping stage 2 simple. |
| D | CE | CE-CB cascode | Inductive emitter degeneration in stage 1 | Baseline candidate: stage 1 for NF/match, stage 2 for gain/isolation. |

### 4.3 Degeneration strategy

At 60 GHz, emitter degeneration is often realized with very small inductors and intentional interconnect segments whose EM behavior must be verified, not assumed from ideal low-frequency models.

For Block 01, the default strategy is:

- Use **inductive emitter degeneration in stage 1**.
- Avoid resistive degeneration in stage 1 unless late-stage stability issues demand it.
- Keep stage 2 without degeneration initially and revisit only if stability or linearity require adjustment.

## 5. Recommended baseline architecture

The recommended baseline architecture for Block 01 is **Topology D**:

- Two HBT stages.
- Stage 1: common-emitter with inductive emitter degeneration, tuned for simultaneous noise and input match around 60 GHz.
- Stage 2: CE-CB cascode, tuned for additional gain and improved reverse isolation.

Three-stage designs are deliberately kept in reserve. If post-layout simulations indicate that a two-stage implementation cannot deliver at least about 17 dB gain at 60 GHz within the 10 mW power ceiling, a third stage may be introduced with a clear design-change note documenting the trade-offs.

## 6. Decision criteria and gates

Before any transistor-level schematic is promoted beyond exploratory benches, the following criteria and gates apply:

1. **Spec alignment.** For each candidate topology family (A–D), pre-layout simulations with realistic passives must report:
   - Gain >= 20 dB at 60 GHz target and >= 18 dB over 57–66 GHz.
   - NF <= 3.5 dB at 60 GHz target and <= 4 dB over 57–66 GHz.
   - DC power <= 8 mW target and <= 10 mW worst case.

2. **Stability.** All candidates must show unconditional stability from about 1 GHz to at least 100 GHz, with particular attention to the second stage for cascode variants.

3. **Robust matching.** Input and output matches must reach at least -10 dB over 57–66 GHz under the same source/load assumptions for all candidates.

4. **Sensitivity to parasitics.** Each candidate must be checked for sensitivity to realistic passive Q and interconnect parasitics.

5. **Architecture-first discipline.** No full schematic hierarchy is to be built for more than one topology family until a comparison, based on the same bias budget and source/load conditions, is captured in writing in this document or an attached architecture-exploration note.

## 7. Integration assumptions for Blocks 02 and 03

The Block 01 LNA is designed under the assumption that it will be followed by:

- A low-power mmWave VCO with PLL hooks covering the same 57–66 GHz band for RX LO generation or nearby bands with simple frequency planning.
- A PA driver or power-detect block that can reuse the same bias infrastructure and RF interface conventions.

Targeting a clean 57–66 GHz band with usable performance up to about 70 GHz allows all three blocks to share a single V-band RX front-end story without overextending the first silicon revision into 80 GHz claims.

## 8. Summary of locked decisions

- Block 01’s **formal operating band** is 57–66 GHz, with usable performance targeted up to about 70 GHz.
- The **spec targets at 60 GHz** are 20 dB gain, 3.5 dB NF, and 8 mW power, with clearly stated hard limits.
- The **baseline architecture** is a two-stage HBT LNA using a CE first stage with inductive emitter degeneration and a CE-CB cascode second stage.
- Three-stage topologies are reserved as contingency if two stages cannot meet gain within the power ceiling after realistic extraction.
- Architecture exploration will compare four topology families (A–D) under identical assumptions before any one topology becomes the schematic baseline.
