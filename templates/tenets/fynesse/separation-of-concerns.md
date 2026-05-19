---
id: "separation-of-concerns"
title: "Separation of Access, Assess, and Address"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-14"
review_frequency: "Annual"
conflicts_with: []
tags:
  - architecture
  - design
  - data-science
---

## Tenet: separation-of-concerns

**Title**: Separation of Access, Assess, and Address

**Description**: The three phases of data science work — Access, Assess, and Address — must remain distinct and separated. Access is concerned with obtaining data from its source; Assess is concerned with understanding the nature of that data; Address is concerned with answering a specific question using that data. Each phase has a clear boundary, a distinct purpose, and must not bleed into the others. Code, documentation, and notebooks should make this separation explicit.

**Quote**: *"Three phases, three concerns, two boundaries — the clarity of each protects the integrity of all."*

**Examples**:
- Implementing `access.py`, `assess.py`, and `address.py` as separate Python modules with clear interfaces between them
- An assess function that loads data via the access module and performs quality checks, with no reference to any analysis question
- An address function that receives already-assessed data and applies a statistical model to answer a specific question
- Keeping database connection logic entirely within access, so assess and address are never aware of the data source
- A corpus word-count distribution or chunk-length histogram belongs in assess — informative about the data regardless of downstream question
- LLM-based extraction or embedding generation belongs in address — it operates on question-specific outputs and encodes what we are looking for

**Counter-examples**:
- A single monolithic processing notebook that must be run top-to-bottom to get any artefacts, conflating all three stages
- An assess function that imputes missing values using a method chosen because it suits the downstream model
- Putting SQL queries inside address.py to fetch additional data needed for a specific analysis
- Running quality diagnostics inside the same cell as LLM extraction, making it impossible to reuse the diagnostics without triggering API costs
- Mixing metadata joins (access) with question-specific filtering (address) in the same function

**Conflicts**:
- Can create apparent friction when a quick exploratory analysis seems easier to write as a single pipeline
- Resolution: accept a monolithic structure during early exploration, but enforce the separation before code enters the shared package — scratch notebooks are not the boundary, the package is
- May feel over-engineered for very simple one-off analyses
- Resolution: Even a short script benefits from the separation, as the assess layer can be shared with future analyses on the same data

**Version**: 1.1 (2026-05-14)
