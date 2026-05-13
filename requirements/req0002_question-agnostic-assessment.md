---
id: "0002"
title: "Assessment Work is Performable Without the Analysis Question"
status: "Proposed"
priority: "High"
created: "2026-05-13"
last_updated: "2026-05-13"
related_tenets:
  - "assess-without-the-question"
  - "repeatable-assessment"
stakeholders:
  - "data scientists"
  - "analysts"
  - "research collaborators"
tags:
  - assessment
  - reproducibility
  - data-quality
---

# REQ-0002: Assessment Work is Performable Without the Analysis Question

## Description

All work in the Assess phase must be completable without knowledge of the specific analysis question the data will be used to answer. Assessment covers understanding the data as it is: its structure, encodings, missing value patterns, outliers, data types, and provenance. Cleaning and preparation decisions made in the Assess phase must be justified by properties of the data itself, not by requirements of a downstream model or analysis.

**Why this matters**: When assessment decisions are shaped by the analysis question, the assess layer becomes question-specific and cannot be reused. Another analyst working on the same dataset for a different question would need to redo the assessment from scratch, potentially making different (and incompatible) decisions. Question-agnostic assessment is a public good that benefits every analyst who uses the data.

**Who benefits**: Research collaborators who want to share data understanding across analyses; data science teams working on multiple analyses from the same data source; anyone who needs to audit or reproduce an analysis.

## Acceptance Criteria

- [ ] The `assess` module contains no references to the specific analysis question, model architecture, or downstream task
- [ ] Cleaning and imputation decisions in assess are documented with justifications based on data properties (e.g. "dropping rows where all fields are null")
- [ ] The assess module can be run on a new data snapshot and produce meaningful output without modification
- [ ] A second analyst could use the assess module on the same dataset without needing to understand the original analysis question
- [ ] Where cleaning decisions are necessarily question-specific, they are recorded as notes and deferred to the address layer

## Notes

This does not mean that assess cannot be informative for the address layer. Assess may produce summaries, quality flags, or cleaned dataframes that address can use. The constraint is only that the decisions made in assess are not shaped by the analysis question.

## References

- **Related Tenets**: assess-without-the-question, repeatable-assessment

## Progress Updates

### 2026-05-13
Requirement created as part of the initial Fynesse framework bootstrap.
