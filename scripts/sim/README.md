# scripts/sim — Simulation Helpers

ngspice control, `.raw` file parsing, S-parameter extraction,
openEMS run drivers, and parametric sweep orchestration.

## Inventory

| Script | Status | Description |
|--------|--------|-------------|
| *(none yet)* | — | — |

*(Add rows here as scripts are created.)*

## Planned utilities (parking lot)

- `raw_to_df.py` — parse ngspice `.raw` binary/ASCII → pandas DataFrame
- `sp_extract.py` — extract S-parameters, NF, gain, P1dB, IIP3 from sim outputs
- `sp_to_touchstone.py` — write `.s2p` / `.s1p` Touchstone files
- `sweep_runner.py` — parametric sweep orchestrator (PVT corners, component values)
- `openems_driver.py` — openEMS run + port definitions + S-parameter export

## Dependencies

All third-party deps must be listed in `requirements-sim.txt` (to be created).
Current expected deps: `numpy`, `pandas`, `scipy` (optional for `.raw` parsing).
