#!/usr/bin/env bash
# install.sh — install the Fynesse framework into a data analysis repository.
#
# Usage (from the root of any data analysis project):
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/lawrennd/fynesse/main/install.sh)
#
# Or, if the repo is already cloned locally:
#
#   bash ~/lawrennd/fynesse/install.sh
#
# What this script does:
#   1. Installs VibeSafe (or updates it) via its own install-minimal.sh.
#      VibeSafe provides the governance layer: tenets, requirements, CIPs,
#      backlog, whats-next, and AI rules infrastructure.
#   2. Clones/updates the fynesse repo locally.
#   3. Adds fynesse tenets to tenets/fynesse/ in the target project.
#   4. Creates fynesse/ module directory and copies template stubs ONLY
#      if the target file does not already exist (user content preserved).
#   5. Installs fynesse AI rules as an additional layer in the project's
#      Cursor/Claude/Codex/Copilot configuration.
#   6. Installs .vibesafe/checks/fynesse_checks.py for whats-next integration
#      (activated once VibeSafe supports user-defined checks — CIP-0004).
#   7. Adds fynesse .gitignore entries (machine.yml).
#
# Clean-installation philosophy: idempotent and predictable.
#   - VibeSafe system files: always updated by vibesafe install
#   - Fynesse AI rules: always overwritten (system files)
#   - Fynesse tenets: always overwritten (system files, not user content)
#   - Fynesse checks: always overwritten (system files)
#   - AAA module stubs: ONLY written if the target file does not exist

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────────────────
VIBESAFE_INSTALL_URL="https://raw.githubusercontent.com/lawrennd/vibesafe/main/scripts/install-minimal.sh"
FYNESSE_REPO="https://github.com/lawrennd/fynesse.git"
FYNESSE_LOCAL="${HOME}/lawrennd/fynesse"
PROJECT_ROOT="$(pwd)"
FYNESSE_SECTION_TAG="<!-- fynesse-framework -->"

# ── Colours (gracefully absent if not a terminal) ──────────────────────────────
if [ -t 1 ]; then
    BOLD="\033[1m"; GREEN="\033[0;32m"; YELLOW="\033[0;33m"; RESET="\033[0m"
else
    BOLD=""; GREEN=""; YELLOW=""; RESET=""
fi

log_info()  { echo -e "${GREEN}[fynesse]${RESET} $*"; }
log_warn()  { echo -e "${YELLOW}[fynesse]${RESET} $*"; }
log_title() { echo -e "${BOLD}[fynesse]${RESET} $*"; }

# ── 1. Install / update VibeSafe ───────────────────────────────────────────────
log_title "Step 1 — Install/update VibeSafe (governance layer)"

if command -v curl &>/dev/null; then
    bash -c "$(curl -fsSL "${VIBESAFE_INSTALL_URL}")"
elif [ -d "${HOME}/lawrennd/vibesafe" ]; then
    log_warn "curl not available; running local VibeSafe install"
    bash "${HOME}/lawrennd/vibesafe/scripts/install-minimal.sh"
else
    log_warn "curl not available and VibeSafe not cloned locally."
    log_warn "Install VibeSafe manually first: https://github.com/lawrennd/vibesafe"
    log_warn "Continuing with fynesse-only installation..."
fi

# ── 2. Ensure the fynesse repo is available locally ───────────────────────────
log_title "Step 2 — Ensure fynesse is available locally"

if [ -d "${FYNESSE_LOCAL}/.git" ]; then
    log_info "Found ${FYNESSE_LOCAL} — pulling latest..."
    git -C "${FYNESSE_LOCAL}" pull --ff-only --quiet
else
    log_info "Cloning fynesse into ${FYNESSE_LOCAL}..."
    mkdir -p "$(dirname "${FYNESSE_LOCAL}")"
    git clone --quiet "${FYNESSE_REPO}" "${FYNESSE_LOCAL}"
fi

# ── 3. Install fynesse tenets into tenets/fynesse/ ────────────────────────────
log_title "Step 3 — Install fynesse tenets"

mkdir -p "${PROJECT_ROOT}/tenets/fynesse"

for tenet_file in "${FYNESSE_LOCAL}/templates/tenets/fynesse/"*.md; do
    tenet_name="$(basename "${tenet_file}")"
    cp "${tenet_file}" "${PROJECT_ROOT}/tenets/fynesse/${tenet_name}"
    log_info "Updated tenets/fynesse/${tenet_name}"
done

# Regenerate combined tenet file if VibeSafe's combine_tenets.py is available
COMBINE_SCRIPT="${PROJECT_ROOT}/tenets/combine_tenets.py"
if [ -f "${COMBINE_SCRIPT}" ]; then
    VENV="${PROJECT_ROOT}/.venv-vibesafe"
    if [ -f "${VENV}/bin/python" ]; then
        log_info "Regenerating combined fynesse tenets..."
        "${VENV}/bin/python" "${COMBINE_SCRIPT}" \
            --tenets-dir "${PROJECT_ROOT}/tenets/fynesse" \
            --output-md "${PROJECT_ROOT}/tenets/fynesse-tenets.md" \
            --output-yaml "${PROJECT_ROOT}/tenets/fynesse-tenets.yaml" \
            2>/dev/null || true
    fi
fi

# ── 4. Create fynesse/ module directory and copy template stubs ───────────────
log_title "Step 4 — Install template stubs (skip if user content already exists)"

mkdir -p "${PROJECT_ROOT}/fynesse"

copy_if_absent() {
    local src="$1"
    local dst="$2"
    if [ -f "${dst}" ]; then
        log_warn "Skipping $(basename "${dst}") — already exists (user content preserved)"
    else
        cp "${src}" "${dst}"
        log_info "Created $(basename "${dst}")"
    fi
}

TEMPLATES="${FYNESSE_LOCAL}/templates/fynesse"
copy_if_absent "${TEMPLATES}/access.py"    "${PROJECT_ROOT}/fynesse/access.py"
copy_if_absent "${TEMPLATES}/assess.py"   "${PROJECT_ROOT}/fynesse/assess.py"
copy_if_absent "${TEMPLATES}/address.py"  "${PROJECT_ROOT}/fynesse/address.py"
copy_if_absent "${TEMPLATES}/config.py"   "${PROJECT_ROOT}/fynesse/config.py"
copy_if_absent "${TEMPLATES}/defaults.yml" "${PROJECT_ROOT}/fynesse/defaults.yml"

if [ ! -f "${PROJECT_ROOT}/fynesse/__init__.py" ]; then
    printf 'from . import access\nfrom . import assess\n' > "${PROJECT_ROOT}/fynesse/__init__.py"
    log_info "Created fynesse/__init__.py"
fi

# ── 5. Install fynesse AI rules ────────────────────────────────────────────────
log_title "Step 5 — Install fynesse AI rules"

RULE_CONTENT="$(cat "${FYNESSE_LOCAL}/rules/fynesse-framework.md")"

write_section() {
    local target_file="$1"
    local heading="$2"
    local content="$3"

    local block
    block="$(printf '%s\n## %s\n\n%s\n\n%s' \
        "${FYNESSE_SECTION_TAG}" "${heading}" "${content}" "${FYNESSE_SECTION_TAG}")"

    if [ -f "${target_file}" ] && grep -q "${FYNESSE_SECTION_TAG}" "${target_file}" 2>/dev/null; then
        python3 - "${target_file}" "${FYNESSE_SECTION_TAG}" "${block}" <<'PYEOF'
import sys, re, pathlib
path = pathlib.Path(sys.argv[1])
tag  = re.escape(sys.argv[2])
block = sys.argv[3]
text  = path.read_text(encoding="utf-8")
new_text = re.sub(rf'{tag}.*?{tag}', block, text, flags=re.DOTALL)
path.write_text(new_text, encoding="utf-8")
PYEOF
        log_info "Updated fynesse section in ${target_file}"
    else
        if [ ! -f "${target_file}" ]; then touch "${target_file}"; fi
        printf '\n%s\n' "${block}" >> "${target_file}"
        log_info "Added fynesse section to ${target_file}"
    fi
}

# Cursor rule (scoped to fynesse/**)
mkdir -p "${PROJECT_ROOT}/.cursor/rules"
cat > "${PROJECT_ROOT}/.cursor/rules/fynesse-framework.mdc" <<CURSOR_EOF
---
description: Architecture rules for fynesse data science projects (Access-Assess-Address)
globs:
  - "fynesse/**/*.py"
  - "fynesse/**/*.yml"
alwaysApply: false
---

${RULE_CONTENT}
CURSOR_EOF
log_info "Wrote .cursor/rules/fynesse-framework.mdc"

# Claude Code, Codex, Copilot — append/replace fenced sections
write_section "${PROJECT_ROOT}/CLAUDE.md" "Fynesse Framework" "${RULE_CONTENT}"
write_section "${PROJECT_ROOT}/AGENTS.md" "Fynesse Framework" "${RULE_CONTENT}"
mkdir -p "${PROJECT_ROOT}/.github"
write_section "${PROJECT_ROOT}/.github/copilot-instructions.md" "Fynesse Framework" "${RULE_CONTENT}"

# ── 6. Install VibeSafe user-defined checks for fynesse ───────────────────────
log_title "Step 6 — Install fynesse whats-next checks"

# .vibesafe/checks/ is the discovery path for VibeSafe's user-defined checks
# mechanism (VibeSafe CIP-to-be — see fynesse cip/cip0004.md).
# The check file is installed now so it is ready when VibeSafe supports it.
mkdir -p "${PROJECT_ROOT}/.vibesafe/checks"
cp "${FYNESSE_LOCAL}/templates/vibesafe-checks/fynesse_checks.py" \
   "${PROJECT_ROOT}/.vibesafe/checks/fynesse_checks.py"
log_info "Installed .vibesafe/checks/fynesse_checks.py"

# ── 7. Update .gitignore ──────────────────────────────────────────────────────
log_title "Step 7 — .gitignore"

GITIGNORE="${PROJECT_ROOT}/.gitignore"
GI_BEGIN="# BEGIN fynesse"
GI_END="# END fynesse"
GI_BLOCK="${GI_BEGIN}
# Machine-specific Fynesse config — managed by install.sh, do not commit.
fynesse/machine.yml
${GI_END}"

if [ -f "${GITIGNORE}" ] && grep -q "${GI_BEGIN}" "${GITIGNORE}" 2>/dev/null; then
    python3 - "${GITIGNORE}" "${GI_BEGIN}" "${GI_END}" "${GI_BLOCK}" <<'PYEOF'
import sys, pathlib
path      = pathlib.Path(sys.argv[1])
begin_tag = sys.argv[2]
end_tag   = sys.argv[3]
block     = sys.argv[4]
lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
out = []
inside = False
for line in lines:
    if line.rstrip() == begin_tag:
        inside = True
        continue
    if line.rstrip() == end_tag:
        inside = False
        continue
    if not inside:
        out.append(line)
out.append("\n" + block + "\n")
path.write_text("".join(out), encoding="utf-8")
PYEOF
    log_info "Updated .gitignore"
else
    printf '\n%s\n' "${GI_BLOCK}" >> "${GITIGNORE}"
    log_info "Wrote .gitignore"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
log_title "Fynesse installation complete."
echo ""
echo "  Project governance (via VibeSafe):"
echo "    tenets/         — tenets/vibesafe/ + tenets/fynesse/ + your own"
echo "    requirements/   — WHAT your analyses should achieve"
echo "    cip/            — HOW each analysis is designed (access/assess/address plan)"
echo "    backlog/        — DO tasks (implement access, assess, address)"
echo "    ./whats-next    — project status dashboard"
echo ""
echo "  Data science modules:"
echo "    fynesse/access.py      — obtain data, document legal basis"
echo "    fynesse/assess.py      — question-agnostic quality checks"
echo "    fynesse/address.py     — answer your specific question"
echo "    fynesse/config.py      — configuration loader"
echo "    fynesse/defaults.yml   — shared configuration"
echo ""
echo "  AI assistant rules installed for: Cursor, Claude Code, Codex, GitHub Copilot"
echo ""
echo "  Suggested first steps:"
echo "    1. Create a Requirement: WHAT should this analysis achieve?"
echo "    2. Create a CIP: HOW will you access the data, assess it, and address the question?"
echo "    3. Create backlog tasks for: implement access.data(), assess.data(), address function"
echo "    4. Implement fynesse/access.py — add your data source and its legal/ethical basis"
echo "    5. Run ./whats-next to see project status"
echo ""
echo "  To update (AI rules and system files only, user code preserved):"
echo "    bash <(curl -fsSL https://raw.githubusercontent.com/lawrennd/fynesse/main/install.sh)"
