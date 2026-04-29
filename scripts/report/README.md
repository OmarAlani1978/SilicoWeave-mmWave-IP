# scripts/report — PDF & Figure Builders

Publication-quality figure exporters and per-block PDF builders
(design guides, datasheets, monthly progress reports).

## Inventory

| Script | Status | Description |
|--------|--------|-------------|
| *(none yet)* | — | — |

*(Add rows here as scripts are created.)*

## Planned utilities (parking lot)

- `fig_sparams.py` — publication-quality S-parameter plot (matplotlib / DejaVu)
- `fig_nf.py` — noise figure vs. frequency plot
- `fig_phase_noise.py` — phase-noise plot (dBc/Hz vs. offset)
- `block_pdf.py` — per-block design-guide PDF builder (ReportLab + DejaVu)
- `datasheet_builder.py` — datasheet PDF generator reusing `block_pdf` template
- `progress_report.py` — monthly progress report builder

## Font rule

**DejaVu Sans / DejaVu Sans Mono — always.  NOT DM Sans.**
DejaVu has full Unicode + math glyph coverage required for spec tables.

```python
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
# Register before first use:
pdfmetrics.registerFont(TTFont('DejaVuSans', 'DejaVuSans.ttf'))
pdfmetrics.registerFont(TTFont('DejaVuSans-Bold', 'DejaVuSans-Bold.ttf'))
```
