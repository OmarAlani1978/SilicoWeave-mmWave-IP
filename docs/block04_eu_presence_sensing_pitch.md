# Block 04 – 60 GHz Presence Sensing LO Macro (EU Focus)

## Problem

European startups, SMEs, and research labs exploring 60 GHz presence sensing and smart-building radar need:
- A proven RF front-end they can tape out quickly on IHP SG13G2.
- A flexible, low-power local oscillator chain for FMCW radar and fixed links.
- Open tooling and documentation to adapt the design to their use case.

## SilicoWeave approach

SilicoWeave provides an open, reference-grade 60 GHz RX/TX front-end on SG13G2 using only open-source EDA tools.
Block 04 adds a mid-GHz PLL with an integrated 60 GHz LO macro that directly drives the 60 GHz LNA, VCO, and PA driver blocks.

Key characteristics:
- Process: IHP SG13G2 (130 nm SiGe BiCMOS, fT/fmax ≈ 250/340 GHz).
- Tools: xschem, ngspice, KLayout, openEMS, gdsfactory (IHP OpenPDK).
- Output: single-band 16–18 GHz PLL + 60 GHz LO, aimed at short-range FMCW radar and fixed presence detection.

## Use cases (Belgium and EU)

- Privacy-preserving presence detection in offices and homes.
- Smart-building occupancy and energy optimization.
- Robotics and industrial safety zones at short range.
- Research and evaluation kits for universities and labs working on 60 GHz radar algorithms.

## Value for partners

- Ready-to-use frequency plan and LO chain for 60 GHz radar experiments.
- Open schematics, layout, and simulation scripts to accelerate learning and customization.
- Design services to adjust PLL parameters, LO drive level, and 60 GHz front-end details for specific modules or products.

## Engagement model

- Phase 1: reference design and documentation available on GitHub (Apache-2.0 for designs, CC BY 4.0 for docs).
- Phase 2: paid design-services projects to:
  - Tune Block 04 to a partner's chirp and LO requirements.
  - Integrate with custom antennas, packages, or additional RF blocks.
  - Prepare shuttle-ready GDS for IHP OpenMPW runs.

Contact: [omar@eastgatex.com](mailto:omar@eastgatex.com)
Location: Brussels, Belgium – serving Benelux, wider EU, then global projects.
