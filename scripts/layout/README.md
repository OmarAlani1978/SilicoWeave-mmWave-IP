# scripts/layout — Layout Helpers

gdsfactory wrappers for SG13G2 passives, KLayout automation,
DRC/LVS helpers, and PEX utilities.

## Inventory

| Script | Status | Description |
|--------|--------|-------------|
| *(none yet)* | — | — |

*(Add rows here as scripts are created.)*

## Planned utilities (parking lot)

- `sg13g2_passives.py` — gdsfactory parameterised cells: spiral inductors,
  microstrip T-lines, MIM caps, GSG probe pads
- `drc_runner.py` — KLayout DRC batch wrapper with per-rule summary
- `lvs_runner.py` — netgen + KLayout LVS automation

## PDK dependency

All scripts here assume `PDK_ROOT` is set to the IHP-Open-PDK root
(default: `~/silicoweave/pdks/IHP-Open-PDK`).
