# scripts/setup — Environment & Installation Helpers

Scripts that run **once** (or rarely) to configure the workstation,
check the PDK, or install tool dependencies.

## Inventory

| Script | Status | Description |
|--------|--------|-------------|
| `env.sh` | existing | Sourced by `silicoweave-env` alias; sets `PDK_ROOT`, `PYTHONPATH`, etc. |

*(Add rows here as scripts are created.)*

## Notes

- Shell scripts (`.sh`) are permitted here alongside Python.
- Nothing in this folder should be imported by simulation scripts.
