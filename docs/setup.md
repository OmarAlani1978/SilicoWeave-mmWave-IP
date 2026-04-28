# Toolchain & PDK Setup — WSL2 + Ubuntu 22.04 + IHP SG13G2

> Setup guide for the SilicoWeave mmWave IP portfolio on **Windows + WSL2 + Ubuntu 22.04 LTS**.
> This is the maintainer's primary working environment. macOS / native Linux notes follow at the end.

This guide is **purely additive**. It does not touch existing sky130 PDK installs, project folders, or schematics. Two upgrades are required (ngspice and KLayout); everything else you may already have stays as-is.

---

## 0. Pre-flight: what you should already have

Run these in your WSL2 Ubuntu terminal and confirm each tool exists and is recent enough:

```bash
xschem --version 2>&1 | head -3
klayout -v 2>&1 | head -3
magic --version 2>&1 | head -3
netgen -batch quit 2>&1 | head -3
ngspice --version 2>&1 | head -3
```

| Tool | Minimum required | Notes |
|---|---|---|
| **xschem** | ≥ 3.4.5 | Schematic capture, PDK-agnostic |
| **KLayout** | ≥ 0.28 (0.29+ recommended) | Primary layout / DRC / LVS for SG13G2 |
| **magic** | ≥ 8.3 | Secondary layout / extraction |
| **netgen** | ≥ 1.5 | LVS netlisting |
| **ngspice** | ≥ 42 with OSDI | Required for the IHP HICUM/L2 HBT model |

If your `ngspice` is < 42 or your `klayout` is < 0.28, follow the upgrade steps below. Everything else can stay.

---

## 1. One-time WSL2 housekeeping

### Update the package index

```bash
sudo apt update
sudo apt upgrade -y
```

### Silence the WSL2 runtime-directory warning (optional but tidy)

If you see `QStandardPaths: wrong permissions on runtime directory /run/user/1000/`, fix it once:

```bash
sudo chmod 0700 /run/user/$(id -u)
```

WSL2 resets this on each boot. To make it persistent, append to `~/.bashrc`:

```bash
echo 'sudo chmod 0700 /run/user/$(id -u) 2>/dev/null' >> ~/.bashrc
```

### Confirm WSLg (the GUI bridge) is working

```bash
echo $DISPLAY
```

Should print something like `:0`. If it's empty, update Windows (Windows 11 or recent Windows 10 with WSLg) and run `wsl --update` from a PowerShell prompt on the Windows side.

### Decide on a working layout

Recommended directory layout (everything inside the WSL2 home, **never** under `/mnt/c/`):

```
~/silicoweave/
├── pdks/
│   └── IHP-Open-PDK/        # Cloned from GitHub (new)
├── repos/
│   └── SilicoWeave-mmWave-IP/   # This repo (cloned from GitHub)
└── scratch/                  # Throwaway sims, exploration
```

WSL2 filesystem performance on `~` is roughly 10–20× faster than on `/mnt/c/`. Keep PDKs and repos in `~`. Always.

```bash
mkdir -p ~/silicoweave/{pdks,repos,scratch}
```

---

## 2. Upgrade ngspice to ≥ 42 with OSDI support

The IHP SG13G2 PDK uses **HICUM/L2** for the npn13G2 SiGe HBT. This model is distributed as a Verilog-A `.osdi` plug-in and requires ngspice ≥ 42 built with `--enable-osdi`. ngspice-36 (the Ubuntu 22.04 default) does **not** have OSDI support, so we upgrade.

### Path A — apt PPA (recommended)

```bash
# Add the ngspice maintainer's PPA (provides recent ngspice with OSDI)
sudo add-apt-repository -y ppa:ngspice/ng-spice
sudo apt update

# Replace the older ngspice package
sudo apt install -y ngspice ngspice-doc

# Verify
ngspice --version
```

Look for a version ≥ 42 in the banner. Then verify OSDI is compiled in:

```bash
ngspice -b /dev/null 2>&1 | grep -i osdi
```

If the build advertises OSDI, you're done. If not, fall back to Path B below.

### Path B — Build ngspice from source (fallback)

Use this only if Path A fails or your distribution mirrors are out of date.

```bash
# Build deps
sudo apt install -y build-essential bison flex libreadline-dev libxaw7-dev \
    libxmu-dev libxpm-dev libx11-dev libxft-dev libtool autoconf automake \
    libfftw3-dev pkg-config

# Get a recent stable release (adjust version as needed)
cd ~/silicoweave/scratch
wget https://sourceforge.net/projects/ngspice/files/ng-spice-rework/44/ngspice-44.tar.gz
tar xzf ngspice-44.tar.gz
cd ngspice-44

# Configure with OSDI + shared model support
./autogen.sh
mkdir -p release && cd release
../configure --with-x --with-readline=yes --enable-osdi --disable-debug \
    --prefix=/usr/local
make -j$(nproc)
sudo make install
sudo ldconfig

# Confirm the new binary takes precedence
which ngspice           # expect /usr/local/bin/ngspice
ngspice --version       # expect ≥ 44
```

> **Note on coexistence with sky130:** The new ngspice is fully backward compatible. Your existing sky130 testbenches continue to work unchanged.

---

## 3. Upgrade KLayout to a current version

Ubuntu 22.04's default KLayout is far too old for the IHP PCells. Use the official KLayout apt repo.

### Remove old KLayout (if from apt)

```bash
sudo apt remove -y klayout
```

This removes the binary only; it does not touch your `.lyp` layer-property files or any `.gds` files in your project folders.

### Install current KLayout

Visit the [KLayout build server](https://www.klayout.org/klayout-pypi/) and download the latest `.deb` for Ubuntu 22.04 (`focal`/`jammy`). At time of writing, this looks like:

```bash
cd ~/silicoweave/scratch
wget https://www.klayout.org/downloads/Ubuntu-22/klayout_0.29.X-1_amd64.deb
sudo apt install -y ./klayout_0.29.X-1_amd64.deb

klayout -v
```

> Replace `0.29.X` with the current version on the download page. **Do not** install via `pip install klayout` for the GUI — the `.deb` package gives you the full Qt GUI, scripting, and integrated DRC/LVS.

### Verify KLayout GUI launches over WSLg

```bash
klayout &
```

A KLayout window should appear on your Windows desktop. Close it for now.

---

## 4. Clone the IHP Open PDK

This is purely additive — it does not modify any other PDK install.

```bash
cd ~/silicoweave/pdks
git clone https://github.com/IHP-GmbH/IHP-Open-PDK.git
cd IHP-Open-PDK
git status        # confirm clean clone
ls ihp-sg13g2/    # confirm the SG13G2 PDK is present
```

The relevant subtrees (paths inside `ihp-sg13g2/`):

```
libs.tech/
├── ngspice/         # SPICE models (HICUM/L2 .osdi, BSIM4, .modelcards)
├── klayout/         # PCells, DRC, LVS, technology files
├── xschem/          # xschem symbol library and template circuits
└── magic/           # magic tech file (secondary)
libs.ref/            # Reference cell libraries
```

> Optional: also fetch the IHP example designs and OpenMPW reference flow:
> ```bash
> cd ~/silicoweave/pdks
> git clone https://github.com/IHP-GmbH/TO_Apr2025.git
> git clone https://github.com/IHP-GmbH/TO_May2025.git
> ```
> These contain real community submissions (VCOs, ring oscillators) you can study as reference designs.

---

## 5. Set up environment switching for SG13G2 ↔ sky130 coexistence

The pattern is two small shell scripts, one per PDK. Source the one you need; both never load at once.

### SG13G2 environment (already in this repo at `scripts/setup/env.sh`)

After cloning **this repo** into `~/silicoweave/repos/SilicoWeave-mmWave-IP/`, verify:

```bash
cd ~/silicoweave/repos/SilicoWeave-mmWave-IP
cat scripts/setup/env.sh
```

Edit the `PDK_ROOT` default if your IHP clone path differs. Then source it from the repo root:

```bash
source ./scripts/setup/env.sh
```

You should see:

```
[SilicoWeave] env ready
  PDK_ROOT          = /home/<you>/silicoweave/pdks/IHP-Open-PDK
  PDK               = sg13g2
  SILICOWEAVE_ROOT  = /home/<you>/silicoweave/repos/SilicoWeave-mmWave-IP
```

### sky130 environment (your existing setup)

Whatever `setup.sh` / env-export pattern you currently use for sky130 stays as-is. We do not modify it. If you want a parallel, equally clean script, create `~/silicoweave/sky130-env.sh`:

```bash
#!/usr/bin/env bash
export PDK_ROOT="$HOME/path/to/your/sky130/pdk"   # adjust to your real path
export PDK="sky130A"
echo "[sky130] env ready · PDK_ROOT=$PDK_ROOT  PDK=$PDK"
```

### Optional — handy shell aliases

Add to `~/.bashrc`:

```bash
alias silicoweave-env='source ~/silicoweave/repos/SilicoWeave-mmWave-IP/scripts/setup/env.sh'
alias sky130-env='source ~/silicoweave/sky130-env.sh'
```

Now any new terminal:
- `silicoweave-env` → SG13G2 mode
- `sky130-env` → sky130 mode

Each terminal is independent — the env vars don't leak across windows.

---

## 6. Verification battery

Three tests. If all pass, the install is complete.

### Test 1 — KLayout opens an SG13G2 cell

```bash
silicoweave-env
klayout $PDK_ROOT/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds &
```

KLayout should open and render standard-cell GDS without errors. Close it.

### Test 2 — ngspice loads the HICUM/L2 HBT model

```bash
silicoweave-env
mkdir -p ~/silicoweave/scratch/hbt_check && cd ~/silicoweave/scratch/hbt_check

cat > hbt_smoke.cir <<'EOF'
* Tiny smoke test: bias an npn13G2 HBT and read Ic
.include $PDK_ROOT/ihp-sg13g2/libs.tech/ngspice/models/cornerHBT.lib

* substitute correct subckt name from the IHP modelcard once verified
* (this file is a placeholder; final smoke test will be committed alongside Block 01 testbenches)

vcc vcc 0 1.5
vbb bb  0 0.85
* Q1 c b e s npn13G2 m=1
.op
.control
run
print v(vcc) v(bb)
.endc
.end
EOF

ngspice -b hbt_smoke.cir
```

A clean `.op` run (no missing-model errors) confirms OSDI + IHP models are loading. The placeholder `.cir` will be replaced with the real LNA bias-point smoke test once Block 01's testbench scaffold is in place.

### Test 3 — xschem loads the IHP symbol library

```bash
silicoweave-env
xschem -b $PDK_ROOT/ihp-sg13g2/libs.tech/xschem/sg13g2_pr/npn13G2.sym 2>&1 | head -20
```

Should report symbol loaded without errors. (If your IHP clone lays the symbol library out at a different path, adjust accordingly — the test is just "does xschem read an IHP symbol".)

---

## 7. Cloning this repo

Once the toolchain and PDK are in place:

```bash
cd ~/silicoweave/repos
git clone https://github.com/OmarAlani1978/SilicoWeave-mmWave-IP.git
cd SilicoWeave-mmWave-IP
silicoweave-env
```

You're ready to design.

---

## 8. Troubleshooting

### KLayout GUI doesn't appear / WSLg errors

- Update Windows (`Settings → Update`) and run `wsl --update` in PowerShell.
- Check `echo $DISPLAY` returns `:0`. If empty, restart WSL: `wsl --shutdown` from PowerShell, then reopen Ubuntu.
- If KLayout starts but is sluggish on large layouts, this is a known WSL2 graphics ceiling. Plan: tolerate it for Blocks 01–03; revisit native dual-boot if/when integrating multiple blocks.

### `ngspice: error while loading shared libraries: libosdi.so`

Run `sudo ldconfig` after a source build, or reinstall via Path A.

### `Model npn13G2 not found`

`PDK_ROOT` is wrong, or the testbench `.include` path doesn't match where you cloned the IHP PDK. Re-source `silicoweave-env` and double-check `echo $PDK_ROOT` resolves to a folder containing `ihp-sg13g2/`.

### sky130 sims now fail after the ngspice upgrade

Extremely unlikely (ngspice is rigorously backward compatible) but if it happens, paste the error and we'll diagnose. As a safety net, you can also keep ngspice-36 alongside the new build:

```bash
sudo apt install ngspice36   # if available; otherwise build from source as Path B with --prefix=$HOME/.local
```

…and switch via PATH. Not normally necessary.

### KLayout PCell errors loading IHP HBT

Means KLayout is too old. Re-run Section 3 to install ≥ 0.29.

---

## 9. macOS / native Linux notes (secondary platforms)

- **macOS Tiny Tapeout VM** — kept exclusively for sky130 personal experiments. Do not install the IHP PDK on it; the VM is sky130-tuned and adding SG13G2 risks breaking the VM's pre-baked configuration.
- **Native Ubuntu / dual-boot** — same instructions as WSL2, minus the WSLg / runtime-permissions sections. KLayout will be noticeably faster on native than on WSL2 for very large layouts.

---

## Reference links

- [IHP Open PDK on GitHub](https://github.com/IHP-GmbH/IHP-Open-PDK)
- [KLayout downloads](https://www.klayout.org/klayout-pypi/)
- [ngspice releases](https://sourceforge.net/projects/ngspice/files/ng-spice-rework/)
- [WSL2 documentation](https://learn.microsoft.com/windows/wsl/)
- [IHP OpenMPW programs (TO_Apr2025, TO_May2025)](https://github.com/IHP-GmbH)
