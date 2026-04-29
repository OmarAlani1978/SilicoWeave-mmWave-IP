# SilicoWeave Utility Scripts

Reusable Python helpers used across all mmWave IP blocks.
Block-specific scripts that will never be reused live inside
the relevant block folder (`01_lna_60ghz_sg13g2/`, etc.), **not here**.

## Subfolders

| Folder | Purpose |
|--------|---------|
| `setup/` | Environment setup, PDK checks, dependency installers |
| `sim/` | ngspice / openEMS run helpers, `.raw` post-processing |
| `layout/` | gdsfactory / KLayout wrappers for SG13G2 passives |
| `report/` | PDF builders, datasheet generators, figure exporters |

## Conventions

- **Standard library first.** Third-party only when it earns its place.
- Every script has a top-of-file docstring with a one-line summary
  and a `Usage:` example.
- Every user-facing script uses `argparse` with a `--help`.
- `if __name__ == "__main__":` guard on every script.
- Type hints where they aid readability; not enforced everywhere.
- Plotting: matplotlib + DejaVu fonts. PDFs: ReportLab + DejaVu.
- Tests for non-trivial logic live in `tests/` at repo root (pytest).

## Python version

Ubuntu 22.04 default (Python 3.10+). Activate the project venv before
running any script:

```bash
silicoweave-env          # alias → sources scripts/setup/env.sh
```
