# SilicoWeave — mmWave IP Portfolio (IHP SG13G2)

> **Status:** 🚧 Work in progress · Public engineering log of SilicoWeave's mmWave IP portfolio on the open IHP SG13G2 SiGe BiCMOS process.

This repository is the public engineering home of **SilicoWeave**, a small ASIC design studio focused on **low-power mmWave IP blocks** on the [IHP SG13G2](https://github.com/IHP-GmbH/IHP-Open-PDK) 130 nm SiGe BiCMOS process (HBT fT/fmax = 250/340 GHz, with X-Fab production path).

The goal is silicon-proven reference IP for V-band (24–57 GHz) and W-band front-ends, paired with full design methodology, testbenches, measurement data, and integration kits.

---

## Why SG13G2

- **High-fT SiGe HBTs** (npn13G2: fT 250 GHz / fmax 340 GHz) — the right device class for low-noise, low-phase-noise mmWave circuits.
- **Open PDK** with KLayout / xschem / ngspice / magic / netgen flow — fully reproducible, no NDA for the development phase.
- **Production foundry path** via X-Fab's 2024 license of the IHP 130 nm SiGe BiCMOS platform — IP designed here is production-portable.
- **Affordable open-source MPW** — IHP OpenMPW shuttles at €2,800/mm² on the SG13G2 process make silicon validation accessible for an early-stage IP shop.

---

## Portfolio (planned)

| # | Block | Target | Status |
|---|---|---|---|
| **01** | [60 GHz Low-Noise Amplifier (LNA)](./01_lna_60ghz_sg13g2/) | V-band LNA · NF < 4 dB · Gain > 18 dB · sub-10 mW | 🟡 Design starting |
| **02** | [60 GHz VCO with PLL-friendly tuning](./02_vco_60ghz_sg13g2/) | Wide-tuning V-band VCO · Low phase noise · VerilogA model | ⚪ Planned |
| **03** | [V-band PA Driver + RMS Power Detector](./03_pa_driver_sg13g2/) | Pre-PA driver stage with on-chip RMS power detect | ⚪ Planned |
| **04** | [15–20 GHz PLL + 60 GHz LO Generator](./04_pll_lo_60ghz_sg13g2/) | Mid-GHz integer-N PLL + 60 GHz LO macro for presence-sensing radar | ⚪ Architecture phase |
| **00** | [Supporting blocks](./00_supporting_blocks/) | Bandgap, biasing, decoupling, ESD pad cells | ⚪ Planned |

The three headline blocks are deliberately chosen to form the **front-end half of a V-band receive chain** — each can be sold as standalone IP, and together they package as a "V-band RX front-end reference platform." Block 04 adds the frequency-synthesis path that ties them together and enables 60 GHz presence-sensing applications.

### Block 04 — 15–20 GHz PLL + 60 GHz LO Generator

Block 04 fills the missing frequency-synthesis path for the V-band front-end: a mid-GHz integer-N PLL at 16–18 GHz feeding a compact 60 GHz LO multiplier macro. It is positioned for low-power 60 GHz FMCW presence-sensing radar and fixed short-range links, with reuse as a standalone mid-GHz PLL IP.

- Architecture decision: [`04_pll_lo_60ghz_sg13g2/docs/04_pll_lo_60ghz_architecture_decision.md`](./04_pll_lo_60ghz_sg13g2/docs/04_pll_lo_60ghz_architecture_decision.md)
- EU presence-sensing pitch: [`docs/block04_eu_presence_sensing_pitch.md`](./docs/block04_eu_presence_sensing_pitch.md)

---

## Repo layout

```
SilicoWeave-mmWave-IP/
├── 00_supporting_blocks/          # Bandgap, bias, ESD, pad cells (re-used by all blocks)
├── 01_lna_60ghz_sg13g2/           # Block 1 — 60 GHz LNA
├── 02_vco_60ghz_sg13g2/           # Block 2 — 60 GHz VCO
├── 03_pa_driver_sg13g2/           # Block 3 — PA driver + power detect
├── 04_pll_lo_60ghz_sg13g2/        # Block 4 — 15–20 GHz PLL + 60 GHz LO generator
├── docs/                          # Cross-block methodology, design notes, references
├── scripts/                       # Setup scripts, simulation helpers, layout utilities
└── .github/                       # CI / issue templates / contribution guides
```

Each block folder follows the same internal structure:

```
NN_block_name/
├── schematics/         # xschem .sch files
├── layout/             # KLayout .gds / .oas / .lyt
├── testbenches/        # ngspice testbenches + control files
├── simulation_results/ # Plots, .raw, post-processed data (committed selectively)
├── measurements/       # Silicon characterization data once we have it back
└── docs/               # Block-specific design notes, datasheet, integration guide
```

---

## Toolchain

All blocks are designed using a fully open-source, scriptable flow:

| Step | Tool | Notes |
|---|---|---|
| Schematic capture | **xschem** | PDK-agnostic; same flow for SG13G2 and sky130 |
| Simulation | **ngspice** | Transient, AC, noise, S-parameter |
| Layout | **KLayout** | Native flow for IHP SG13G2 PDK; PCells, DRC, LVS |
| LVS | **netgen** + KLayout LVS scripts | |
| DRC | **KLayout DRC** | IHP-supplied rule decks |
| Parasitic extraction | **magic** / KLayout PEX | |
| Documentation | **Markdown + Python (matplotlib, ReportLab)** | Reproducible design guides |

> **Note on layout tools:** KLayout is the primary layout tool for this repo because the IHP SG13G2 PDK is built around it. magic remains useful for quick extraction tasks but is not the supported flow.

See [`docs/setup.md`](./docs/setup.md) for installation and PDK setup instructions.

---

## How this repo relates to [`ASIC-portfolio`](https://github.com/OmarAlani1978/ASIC-portfolio)

- **`ASIC-portfolio`** — personal R&D, sky130 experiments, learning artifacts.
- **`SilicoWeave-mmWave-IP`** (this repo) — focused, commercial-grade SG13G2 portfolio aimed at silicon-proven mmWave IP.

The two are intentionally separated so customers and collaborators landing here see one focused repository with three V-band SiGe blocks, not a mixed bag.

---

## License

- **Designs (schematics, layouts, testbenches):** [Apache-2.0](./LICENSE)
- **Documentation:** [CC BY 4.0](./LICENSE-docs)

Commercial licensing for productized IP releases (post silicon validation) will be offered separately. Get in touch if you're interested.

---

## Contact

- **SilicoWeave** · ASIC design boutique · mmWave & SiGe BiCMOS
- **Maintainer:** Omar Al-Ani — [omar@eastgatex.com](mailto:omar@eastgatex.com)
- **GitHub:** [@OmarAlani1978](https://github.com/OmarAlani1978)

---

## Acknowledgements

This work builds directly on the [IHP Open PDK](https://github.com/IHP-GmbH/IHP-Open-PDK), the IHP OpenMPW programs, and the broader open-source silicon community. None of this is possible without them.
