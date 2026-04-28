#!/usr/bin/env bash
# SilicoWeave — environment setup script.
# Source this from the repo root: `source ./scripts/setup/env.sh`

# Fail noisily if PDK_ROOT is not set
if [ -z "${PDK_ROOT}" ]; then
    echo "WARNING: PDK_ROOT is not set. Set it to your IHP-Open-PDK clone, e.g.:"
    echo "    export PDK_ROOT=\$HOME/pdks/IHP-Open-PDK"
fi

# Default to SG13G2 unless caller overrides
export PDK="${PDK:-sg13g2}"

# Repo root (assumes script lives at scripts/setup/env.sh)
SILICOWEAVE_ROOT="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"/../.. &> /dev/null && pwd )"
export SILICOWEAVE_ROOT

# xschem library / sim path
export XSCHEM_USER_LIBRARY_PATH="${SILICOWEAVE_ROOT}/scripts/xschem_lib:${XSCHEM_USER_LIBRARY_PATH:-}"

# ngspice — point at the IHP model includes (path will exist after PDK clone)
if [ -n "${PDK_ROOT}" ] && [ -d "${PDK_ROOT}/ihp-sg13g2/libs.tech/ngspice" ]; then
    export NGSPICE_MODEL_PATH="${PDK_ROOT}/ihp-sg13g2/libs.tech/ngspice"
fi

# KLayout — DRC/LVS scripts
if [ -n "${PDK_ROOT}" ] && [ -d "${PDK_ROOT}/ihp-sg13g2/libs.tech/klayout" ]; then
    export KLAYOUT_PATH="${PDK_ROOT}/ihp-sg13g2/libs.tech/klayout:${KLAYOUT_PATH:-}"
fi

echo "[SilicoWeave] env ready"
echo "  PDK_ROOT          = ${PDK_ROOT:-<unset>}"
echo "  PDK               = ${PDK}"
echo "  SILICOWEAVE_ROOT  = ${SILICOWEAVE_ROOT}"
