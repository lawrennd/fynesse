---
id: "0001"
title: "Fynesse Projects Separate Access, Assess, and Address into Distinct Modules"
status: "Proposed"
priority: "High"
created: "2026-05-13"
last_updated: "2026-05-13"
related_tenets:
  - "separation-of-concerns"
  - "assess-without-the-question"
stakeholders:
  - "data scientists"
  - "analysts"
  - "LLM coding assistants"
tags:
  - architecture
  - structure
---

# REQ-0001: Fynesse Projects Separate Access, Assess, and Address into Distinct Modules

## Description

A project following the Fynesse framework must organise its data science work across three distinct modules: `access`, `assess`, and `address`. Each module has a bounded responsibility and a clear interface to the others. The access module is responsible only for obtaining data. The assess module is responsible only for understanding the data's properties and quality. The address module is responsible only for answering specific analysis questions.

**Why this matters**: Without structural separation, the three phases of data science work blend together in ways that make code hard to reuse, results hard to reproduce, and analyses hard to audit. The separation makes each phase explicit, testable, and shareable. It embodies the tenet that data understanding (assess) must be question-agnostic.

**Who benefits**: Data scientists who want to reuse their assess work across multiple analyses; analysts who want to build on existing data access without redoing quality checks; LLM coding assistants that need clear structure to generate correct code.

## Acceptance Criteria

- [ ] A fynesse project contains at least three modules or files named `access`, `assess`, and `address` (or equivalents that map to these phases)
- [ ] The `assess` module imports from `access` but contains no analysis-question-specific logic
- [ ] The `address` module receives assessed data as input and does not directly call data access functions
- [ ] Each module can be imported and used independently of the others' implementation details
- [ ] Documentation or docstrings clearly describe the responsibility of each module

## Notes

The modules are conventionally named `access.py`, `assess.py`, and `address.py` in Python projects. In other languages or notebook-based projects, the separation may take a different form (e.g. separate notebook sections or script files), but the logical boundary must still be explicit.

## References

- **Related Tenets**: separation-of-concerns, assess-without-the-question
- **External Links**: [Fynesse template](https://github.com/lawrennd/fynesse_template)

## Progress Updates

### 2026-05-13
Requirement created as part of the initial Fynesse framework bootstrap.
