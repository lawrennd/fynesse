---
id: "0005"
title: "Fynesse is Installable into Any Data Analysis Repo with a Single Command"
status: "Proposed"
priority: "High"
created: "2026-05-13"
last_updated: "2026-05-13"
related_tenets:
  - "operational-data-science"
  - "systems-engineering-mindset"
stakeholders:
  - "data scientists"
  - "students"
  - "research teams"
tags:
  - installation
  - usability
  - infrastructure
---

# REQ-0005: Fynesse is Installable into Any Data Analysis Repo with a Single Command

## Description

The Fynesse framework must be installable into an existing data analysis repository with a single command, without requiring complex setup or configuration. The installation should be lightweight — it copies template stubs and AI assistant rules, it does not install a heavy dependency or restructure the project. A data scientist who wants to adopt the Fynesse framework should be able to do so in under a minute, starting from an empty directory or an existing project.

**Why this matters**: Frameworks that are hard to install are not adopted, regardless of their merits. Operational data science contexts often require rapid setup. The framework must be usable from the first day of a project. The install-is-reinstall philosophy (as in VibeSafe) ensures that re-running the install updates system files without touching user content.

**Who benefits**: Data scientists starting new projects; students learning the framework; teams adopting Fynesse mid-project; anyone who wants to update the framework components without losing their work.

## Acceptance Criteria

- [ ] A single `bash` command installs Fynesse into the current directory
- [ ] Installation works on macOS and Linux with only `bash` and `git` as hard requirements
- [ ] Re-running the install command updates system files (AI rules, template utilities) without overwriting user's `access.py`, `assess.py`, or `address.py` if they already exist
- [ ] After installation, AI assistant rules for Cursor, Claude Code, Codex, and GitHub Copilot are present and guide the AAA framework
- [ ] The install command requires no user input and completes without manual steps

## Notes

The install model follows explayner: clone the fynesse repo locally, copy templates and rules into the target project. User-edited stubs (access.py etc.) are treated as user content and not overwritten.

## References

- **Related Tenets**: operational-data-science, systems-engineering-mindset
- **Related CIPs**: cip0002 (installation mechanism design)

## Progress Updates

### 2026-05-13
Requirement created as part of the initial Fynesse framework bootstrap.
