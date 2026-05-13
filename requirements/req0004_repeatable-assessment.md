---
id: "0004"
title: "Assessment Outputs are Reproducible and Shareable"
status: "Proposed"
priority: "Medium"
created: "2026-05-13"
last_updated: "2026-05-13"
related_tenets:
  - "repeatable-assessment"
  - "assess-without-the-question"
stakeholders:
  - "data scientists"
  - "research collaborators"
  - "data engineering teams"
tags:
  - reproducibility
  - collaboration
  - assessment
---

# REQ-0004: Assessment Outputs are Reproducible and Shareable

## Description

The Assess phase must produce outputs that are reproducible — given the same data input, the assess functions must return the same results — and shareable — the assess module must be usable by collaborators who want to work with the same dataset without repeating the quality assessment work. This means assess functions should be deterministic, side-effect-free where possible, and documented clearly enough that another analyst can understand what checks were performed and trust the output.

**Why this matters**: Reproducibility is a prerequisite for scientific integrity. Shareability is the mechanism by which the investment in quality assessment is multiplied across the team or community. Without these properties, every analyst who works with a dataset starts from scratch, potentially reaching inconsistent conclusions about data quality and introducing inconsistent cleaning decisions.

**Who benefits**: Teams working collaboratively on the same data; analysts who return to a dataset after a gap; reviewers and auditors who need to verify the analysis.

## Acceptance Criteria

- [ ] Assess functions are deterministic: running them twice on the same data produces the same output
- [ ] Assess functions do not depend on global state, hardcoded paths, or environment-specific configuration that would prevent them running on a collaborator's machine
- [ ] The assess module includes documentation describing what quality checks are performed and what the outputs represent
- [ ] Assess outputs (e.g. cleaned dataframes, quality summaries) can be passed to address functions without modification
- [ ] Where the underlying data changes, re-running the assess module produces updated outputs that reflect the new data

## Notes

Perfect reproducibility may not be achievable for all data sources (e.g. live APIs that return different data at different times). In these cases, the assess module should document this and record the data snapshot date. The goal is reproducibility given a fixed data snapshot.

## References

- **Related Tenets**: repeatable-assessment, assess-without-the-question

## Progress Updates

### 2026-05-13
Requirement created as part of the initial Fynesse framework bootstrap.
