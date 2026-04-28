# Toolchain & PDK Setup

> Setup guide for the SilicoWeave mmWave IP portfolio. Targets Ubuntu 22.04 LTS or newer (native or WSL2).

## Tools required

| Tool | Purpose | Recommended version |
|---|---|---|
| **xschem** | Schematic capture | ≥ 3.4 |
| **ngspice** | Simulation | ≥ 42 |
| **KLayout** | Layout, DRC, LVS (primary) | ≥ 0.29 |
| **magic** | Layout / extraction (secondary) | ≥ 8.3 |
| **netgen** | LVS netlisting | ≥ 1.5 |
| **gdsfactory** *(optional)* | Parametric layout / mmWave passives | latest |
| **Python 3.11+** | Glue scripts, plotting | |

## PDK

This repo targets the **IHP Open PDK** for SG13G2 (and friends). The PDK is **not** committed to this repo — clone it separately.

```bash
# Recommended: clone outside the project tree
mkdir -p ~/pdks
cd ~/pdks
git clone https://github.com/IHP-GmbH/IHP-Open-PDK.git
```

Then export the PDK root in your shell environment (e.g. `~/.bashrc`):

```bash
export PDK_ROOT="$HOME/pdks/IHP-Open-PDK"
export PDK="sg13g2"
```

## Per-repo environment

Each block uses a small `setup.sh` (placed at the repo root, see [`scripts/setup/`](../scripts/setup/)) that exports the necessary env vars for xschem, ngspice, and KLayout. Source it before opening tools:

```bash
cd SilicoWeave-mmWave-IP
source ./scripts/setup/env.sh
```

## Two-laptop workflow

SilicoWeave is developed primarily on a **native Ubuntu / WSL2** workstation. A secondary **macOS Tiny Tapeout VM** is used for sky130 personal experiments (separate repo) and lightweight schematic sketching.

- **GitHub is the single source of truth.** Both machines clone this repo via `git`.
- **PDKs live outside the repo**, referenced by `PDK_ROOT`.
- **Never sync project folders via Dropbox/iCloud** — symlinks and includes break.
- A `setup.sh` per machine pins the right PDK paths so the same project files work everywhere.

## Verifying the install

After setup, run:

```bash
xschem --version
ngspice --version
klayout -v
magic -version
netgen -batch quit
```

All five should print a version string. If any complain, see the troubleshooting section below.

## Troubleshooting

*(To be expanded as we hit issues.)*

- **KLayout slow on WSL2** — consider native Ubuntu dual-boot for heavy mmWave layouts.
- **PDK paths not found** — check `PDK_ROOT` is exported in the same shell where you launch tools.
- **ngspice missing osdi/code-models** — ensure ngspice was built with `--enable-osdi` for HBT / Verilog-A models used by the IHP PDK.
