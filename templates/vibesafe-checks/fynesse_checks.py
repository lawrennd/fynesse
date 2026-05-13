#!/usr/bin/env python3
"""
Fynesse user-defined checks for VibeSafe's whats-next script.

This file is installed by fynesse's install.sh into:
    .vibesafe/checks/fynesse_checks.py

VibeSafe's whats-next discovers and runs any Python files in .vibesafe/checks/
that expose a `run_checks()` function. The function returns a list of
CheckResult objects (or dicts) describing issues and suggestions.

These checks are specific to the Fynesse AAA framework and tell the analyst:
- Which AAA modules are still unimplemented stubs
- Whether machine.yml is present for local configuration
- Whether any CIPs exist that design an analysis (AAA-cycle CIPs)
- Whether there are requirements describing the analysis questions

This file is a system file — it is overwritten on `install.sh` re-run.
Do not edit it directly; edit the source at:
    ~/lawrennd/fynesse/templates/vibesafe-checks/fynesse_checks.py
"""

import os
import ast
from pathlib import Path
from typing import Any


# ── Compatibility shim ────────────────────────────────────────────────────────
# VibeSafe may pass results as namedtuples, dataclasses, or dicts depending on
# the version. We use plain dicts here for maximum compatibility.

def _result(level: str, message: str, suggestion: str = "") -> dict:
    return {"level": level, "message": message, "suggestion": suggestion}


# ── Individual checks ─────────────────────────────────────────────────────────

def _check_aaa_modules(project_root: Path) -> list[dict]:
    """Check whether access/assess/address modules are implemented or still stubs."""
    results = []
    fynesse_dir = project_root / "fynesse"

    if not fynesse_dir.exists():
        results.append(_result(
            "warning",
            "fynesse/ module directory not found",
            "Run install.sh to create the fynesse/ module stubs"
        ))
        return results

    stubs = []
    for module in ["access", "assess", "address"]:
        module_file = fynesse_dir / f"{module}.py"
        if not module_file.exists():
            stubs.append(f"fynesse/{module}.py (missing)")
            continue
        # Heuristic: still a stub if it contains the stub warning log message
        source = module_file.read_text(encoding="utf-8")
        if "stub implementation" in source.lower() or "notimplemented" in source.lower():
            stubs.append(f"fynesse/{module}.py")

    if stubs:
        results.append(_result(
            "info",
            f"Fynesse stub(s) not yet implemented: {', '.join(stubs)}",
            "Implement the stub functions — start with access.py (data source + legal basis), "
            "then assess.py (quality checks), then address.py (analysis question)"
        ))
    else:
        results.append(_result(
            "ok",
            "All three Fynesse AAA modules have been implemented"
        ))

    return results


def _check_machine_yml(project_root: Path) -> list[dict]:
    """Check whether machine.yml exists for local configuration."""
    machine_yml = project_root / "fynesse" / "machine.yml"
    defaults_yml = project_root / "fynesse" / "defaults.yml"

    results = []

    if not defaults_yml.exists():
        results.append(_result(
            "warning",
            "fynesse/defaults.yml not found",
            "Create fynesse/defaults.yml with shared configuration (data URLs, project settings)"
        ))
    else:
        content = defaults_yml.read_text(encoding="utf-8")
        # Check if defaults.yml still has only the placeholder comment
        non_comment = [l for l in content.splitlines()
                       if l.strip() and not l.strip().startswith("#")]
        if not non_comment:
            results.append(_result(
                "info",
                "fynesse/defaults.yml has no configuration values yet",
                "Add your data source URL or other shared configuration to fynesse/defaults.yml"
            ))

    if not machine_yml.exists():
        results.append(_result(
            "info",
            "fynesse/machine.yml not found (optional)",
            "Create fynesse/machine.yml for local credentials and paths "
            "(this file is gitignored — never commit it)"
        ))

    return results


def _check_legal_documentation(project_root: Path) -> list[dict]:
    """Check whether access.py has any legal/ethical documentation."""
    access_file = project_root / "fynesse" / "access.py"
    if not access_file.exists():
        return []

    source = access_file.read_text(encoding="utf-8")
    results = []

    # Look for signs of legal documentation: license/license, GDPR, provenance, source:
    legal_keywords = ["license", "licence", "gdpr", "provenance", "source:", "privacy", "copyright"]
    has_legal = any(kw in source.lower() for kw in legal_keywords)

    # But if still a stub, don't flag — the stub warning check covers it
    if "stub implementation" in source.lower():
        return []

    if not has_legal:
        results.append(_result(
            "warning",
            "fynesse/access.py has no legal/ethical documentation for data sources",
            "Add a comment documenting the license, provenance, and any privacy "
            "considerations for each data source (Fynesse tenet: legal-ethical-access)"
        ))

    return results


def _check_assess_question_independence(project_root: Path) -> list[dict]:
    """Heuristic check: does assess.py import address.py (which would be a red flag)?"""
    assess_file = project_root / "fynesse" / "assess.py"
    if not assess_file.exists():
        return []

    source = assess_file.read_text(encoding="utf-8")
    results = []

    if "from . import address" in source or "from .address" in source or "import address" in source:
        results.append(_result(
            "error",
            "fynesse/assess.py imports from address — this violates the AAA separation",
            "Assess must not depend on address. Move any address-specific logic out of assess.py "
            "(Fynesse tenet: assess-without-the-question)"
        ))

    return results


def _check_cip_aaa_alignment(project_root: Path) -> list[dict]:
    """Check whether any CIPs describe analysis designs (tag: access-assess-address)."""
    cip_dir = project_root / "cip"
    if not cip_dir.exists():
        return []

    results = []
    analysis_cips = []

    for cip_file in sorted(cip_dir.glob("cip*.md")):
        content = cip_file.read_text(encoding="utf-8")
        if any(tag in content.lower() for tag in
               ["access-assess-address", "analysis", "data-science", "aaa"]):
            analysis_cips.append(cip_file.name)

    fynesse_dir = project_root / "fynesse"
    has_implementations = (
        fynesse_dir.exists() and
        any((fynesse_dir / f"{m}.py").exists() for m in ["access", "assess", "address"])
    )

    if has_implementations and not analysis_cips:
        results.append(_result(
            "info",
            "No CIPs describe the analysis design (access/assess/address approach)",
            "Consider creating a CIP that describes HOW you are addressing the analysis question: "
            "what data source, what quality checks, what model or method. "
            "Tag it with 'access-assess-address' in the frontmatter."
        ))

    return results


# ── Entry point ───────────────────────────────────────────────────────────────

def run_checks(project_root: str | None = None) -> list[dict]:
    """Run all Fynesse checks and return a list of result dicts.

    Called by VibeSafe's whats-next when it discovers this file in
    .vibesafe/checks/. Each result dict has keys:
        level:      "ok" | "info" | "warning" | "error"
        message:    str  — what was found
        suggestion: str  — what to do about it (empty string if level=="ok")
    """
    root = Path(project_root) if project_root else Path.cwd()

    results = []
    results.extend(_check_aaa_modules(root))
    results.extend(_check_machine_yml(root))
    results.extend(_check_legal_documentation(root))
    results.extend(_check_assess_question_independence(root))
    results.extend(_check_cip_aaa_alignment(root))

    return results


if __name__ == "__main__":
    # Allow running directly for testing: python fynesse_checks.py
    import json
    results = run_checks()
    for r in results:
        level = r["level"].upper()
        print(f"[{level}] {r['message']}")
        if r.get("suggestion"):
            print(f"       → {r['suggestion']}")
