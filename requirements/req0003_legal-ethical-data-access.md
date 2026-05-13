---
id: "0003"
title: "Access Layer Documents Legal and Ethical Basis for Each Data Source"
status: "Proposed"
priority: "High"
created: "2026-05-13"
last_updated: "2026-05-13"
related_tenets:
  - "legal-ethical-access"
stakeholders:
  - "data scientists"
  - "data governance teams"
  - "legal and compliance teams"
  - "research ethics boards"
tags:
  - access
  - ethics
  - legal
  - privacy
---

# REQ-0003: Access Layer Documents Legal and Ethical Basis for Each Data Source

## Description

The Access phase of a Fynesse project must include explicit documentation of the legal and ethical basis for using each data source. This includes: the license or terms of service under which the data is accessed; the legal framework governing individual privacy rights (e.g. GDPR, CCPA); the provenance of the data (where it came from, who collected it, when); and any known ethical concerns about the data or its collection method. This documentation must be present in the access code or its associated documentation, not just assumed or left implicit.

**Why this matters**: Data access that ignores legal or ethical constraints can cause serious harm to individuals and to the project. In the EU, database schemas and indices are subject to copyright. Combining datasets with different licenses can create compliance problems that only become apparent late in a project. Many datasets collected without proper consent or with biased collection methods can harm the populations they represent. Making these considerations explicit early in the Access phase catches problems when they are cheapest to fix.

**Who benefits**: Analysts who need to understand whether they can use a data source; legal and compliance teams who need an audit trail; research participants whose data is being used; anyone who needs to reproduce or extend the analysis.

## Acceptance Criteria

- [ ] Each data source accessed by the `access` module has an associated note documenting its license or access terms
- [ ] The access layer records the provenance of each data source (origin, access date, version if applicable)
- [ ] Where data contains personally identifiable information, the access layer notes the applicable privacy framework and any protections in place
- [ ] Ethical concerns about a data source (e.g. consent scope, collection bias) are documented even if they do not prevent use
- [ ] The access layer does not silently use data sources whose license is unknown or whose use is legally uncertain

## Notes

The documentation does not need to be extensive — a one-line comment per data source is often sufficient for straightforward cases. The requirement is that the consideration is made explicitly and recorded, not that it is exhaustive.

## References

- **Related Tenets**: legal-ethical-access
- **External Links**: [GDPR summary for researchers](https://gdpr.eu/)

## Progress Updates

### 2026-05-13
Requirement created as part of the initial Fynesse framework bootstrap.
