---
id: "fynesse-tenets"
title: "Fynesse Tenets"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-14"
review_frequency: "Annual"
generated: "2026-05-15"
source: "tenets/fynesse/"
tags:
  - tenets
  - fynesse
---

# Fynesse Tenets

*Generated on 2026-05-15*

This document combines all individual tenet files from the Fynesse framework project.

---

---
id: "assess-without-the-question"
title: "Assess Without the Question"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-14"
review_frequency: "Annual"
conflicts_with: []
tags:
  - assessment
  - reproducibility
  - data-quality
---

## Tenet: assess-without-the-question

**Title**: Assess Without the Question

**Description**: All work performed in the Assess phase must be independent of the specific analysis question being asked. Assessment is about understanding the data as it is — its structure, quality, encodings, missing values, outliers, and provenance — not about preparing it for a particular model or analysis. This ensures that the assess layer is reusable across multiple analyses and by multiple analysts. Decisions made in assess that are shaped by the downstream question contaminate the data understanding and make it impossible to share or reuse.

**Quote**: *"Assess is only work you can do without the question in mind."*

**Examples**:
- Documenting how missing values are encoded in a dataset (e.g. `-999` as a sentinel) without deciding what to do about them
- Computing summary statistics, visualising distributions, and checking data types as part of assess
- Making the assess layer importable by any analyst working on the same dataset, regardless of their specific question
- Recording that a particular column has 23% missing values and leaving the imputation decision to the address layer

**Counter-examples**:
- Imputing missing values in assess using the mean because the downstream regression model requires complete cases
- Dropping columns in assess because they are not relevant to the specific analysis question
- Normalising feature scales in assess in a way that is specific to a particular ML algorithm
- Filtering rows in assess to match a particular cohort definition that is part of the research question

**Conflicts**:
- Can feel inefficient when an analyst knows exactly what question they are asking and wants to prepare data for it directly
- Resolution: The question-agnostic assess layer is a one-time cost per dataset; it can then be reused by any analysis on that data
- In some domains, cleaning decisions are always question-specific and no universal assess layer exists
- Resolution: Document this explicitly; the assess layer can still record the raw data properties even if downstream cleaning must be question-specific

**Version**: 1.1 (2026-05-14)


---

---
id: "legal-ethical-access"
title: "Legal and Ethical Data Access"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-13"
review_frequency: "Annual"
conflicts_with: []
tags:
  - ethics
  - legal
  - access
  - privacy
---

## Tenet: legal-ethical-access

**Title**: Legal and Ethical Data Access

**Description**: The Access phase must include explicit consideration of the legal and ethical basis for using each data source. This covers intellectual property rights (database copyright, license agreements), individual privacy rights (GDPR, CCPA, and equivalent frameworks), data provenance (where did this data come from, who collected it, and how), and ethical use (consent, potential harms to individuals or groups). Access code and documentation must record these considerations, not treat them as implicit or assumed. Data that cannot be accessed legally or ethically must not be used.

**Quote**: *"Getting the data is not just a technical problem — it is a legal and ethical one too."*

**Examples**:
- Including a comment in access.py recording the license under which a dataset is used
- Documenting in the access layer that a dataset was collected with informed consent and noting the consent scope
- Checking whether an API's terms of service permit the intended use before writing the access code
- Recording data provenance (source URL, access date, version) so the analysis can be reproduced and audited
- Flagging in the access layer when data contains personally identifiable information and what protections apply

**Counter-examples**:
- Writing access code that scrapes a website without checking the terms of service
- Using a dataset without documenting its license or the legal basis for access
- Combining datasets without checking whether the composite use violates any individual license
- Treating provenance as unimportant because "the data is already available"
- Ignoring GDPR obligations because the data was obtained from a public source

**Conflicts**:
- Legal and ethical review can slow down exploratory analysis
- Resolution: A brief, explicit note in the access layer is low cost and prevents serious downstream problems; it also serves as documentation for future analysts
- In some research contexts, datasets are shared internally and licensing is assumed to be clear
- Resolution: Even internally shared data benefits from explicit provenance and consent documentation

**Version**: 1.0 (2026-05-13)


---

---
id: "operational-data-science"
title: "Designed for Operational Data Science"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-13"
review_frequency: "Annual"
conflicts_with: []
tags:
  - operational
  - evolving-data
  - deployment
---

## Tenet: operational-data-science

**Title**: Designed for Operational Data Science

**Description**: The Fynesse framework is designed for the real-world conditions of operational data science, where data is live, evolving, and sometimes messy — not the idealised conditions of a clean benchmark dataset and a fixed research question. Operational contexts include pandemic response, supply chain management, policy analysis, and any setting where decisions must be made from imperfect data under time pressure. In these settings, a clear separation of concerns, repeatable assessment, and ethically grounded access are not luxuries — they are prerequisites for trustworthy analysis. The framework should be lightweight enough to be adopted quickly and robust enough to support ongoing, evolving work.

**Quote**: *"Real data science happens under pressure, with imperfect data, in evolving situations — the framework must be ready for that."*

**Examples**:
- Structuring a pandemic response analysis so that the access layer can be updated as new data streams come online without changing the assess or address layers
- Using the assess layer to track how data quality changes over time in a live data pipeline
- Designing the address layer so that the analysis question can be updated (e.g. shifting from "how many cases?" to "how effective is the intervention?") without rewriting the access and assess layers
- Making the framework installable in minutes so it can be adopted at the start of an urgent project

**Counter-examples**:
- Building a framework that only works well with clean, static, pre-processed benchmark data
- Requiring extensive setup and configuration before any data work can begin
- Designing the access layer in a way that is tightly coupled to a specific data source that may change or disappear
- Assuming that the analysis question is fixed at the start and will not evolve as understanding develops
- Building processes that require significant re-engineering whenever the data source format changes

**Conflicts**:
- Operational pressures can make it tempting to skip the framework structure in favour of speed
- Resolution: The framework is designed to be lightweight; even a quick adoption of the three-module structure provides significant clarity with minimal overhead
- Some data science work is purely research-oriented with no operational component
- Resolution: The framework still provides value in research contexts through reproducibility and shareability; the operational design philosophy does not prevent research use

**Version**: 1.0 (2026-05-13)


---

---
id: "repeatable-assessment"
title: "Repeatable and Shareable Assessment"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-13"
review_frequency: "Annual"
conflicts_with: []
tags:
  - reproducibility
  - collaboration
  - assessment
---

## Tenet: repeatable-assessment

**Title**: Repeatable and Shareable Assessment

**Description**: The assess layer should be written so that any analyst working on the same dataset can use it directly, regardless of their specific analysis question. Assessment work is a public good: understanding the structure, quality, and properties of a dataset benefits everyone who works with it, and that work should not need to be repeated. Assess functions should be deterministic, documented, and free of side effects that depend on the analyst's environment or question. Where possible, assess outputs (quality summaries, visualisations, cleaned data structures) should be shareable with collaborators.

**Quote**: *"Do the assessment work once, well, and share it."*

**Examples**:
- Packaging the assess layer as a module that can be imported by multiple notebooks and analysts
- Writing assess functions that produce the same output when run on the same input, with no hidden state
- Documenting in assess what checks were performed and what properties were found, so others can trust the output
- Making an assess module available in a shared repository so that collaborators do not repeat the same data quality work
- Writing tests for assess functions so that data quality checks can be re-run as the data evolves

**Counter-examples**:
- An assess function that writes results to a hardcoded local path that only exists on one machine
- Assessment code that is buried inside a single analysis notebook and never extracted for reuse
- An assess function with parameters that are set to values specific to one analyst's question
- Performing data quality checks interactively in a notebook without recording what was found
- Treating assessment as a private step that does not need to be shared or documented

**Conflicts**:
- Writing shareable, reproducible assessment code takes more effort than quick interactive exploration
- Resolution: The investment pays off when the same dataset is used for a second analysis or by a second analyst; even a simple module is better than nothing
- Some datasets change frequently and repeatable assessment may require versioning strategies
- Resolution: Version the dataset and the assess output together; document the data snapshot date in the assess layer

**Version**: 1.0 (2026-05-13)


---

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


---

---
id: "systems-engineering-mindset"
title: "Structured Exploration: Repeatable Outputs from an Iterative Process"
status: "Active"
created: "2026-05-13"
last_reviewed: "2026-05-13"
review_frequency: "Annual"
conflicts_with: []
tags:
  - engineering
  - exploration
  - reproducibility
  - deployment
---

## Tenet: systems-engineering-mindset

**Title**: Structured Exploration: Repeatable Outputs from an Iterative Process

**Description**: Data science is fundamentally exploratory — a spiral of iteration in which understanding of the data, the question, and the method co-evolve. This is not a weakness to be engineered away; it is intrinsic to the discipline. The Fynesse framework does not try to eliminate exploration. Instead it provides structure so that the *outputs* of exploration are repeatable and the *decisions made during* exploration are documented. The distinction between Access, Assess, and Address is a record of where the analyst is in the spiral, not a waterfall of sequential steps. Systems engineering thinking applies not to the process itself but to the artefacts it produces: a deployed pipeline must handle real-world constraints; a shared assess layer must be reproducible; an access function must remain maintainable as data sources evolve.

**Quote**: *"The process is a spiral; the outputs should be a ladder — each rung solid enough to stand on."*

**Examples**:
- Exploring data interactively in a notebook, then distilling the quality checks into a repeatable `assess.data()` function
- Iterating through several modelling approaches in address.py, documenting why earlier approaches were rejected in code comments or a CIP
- Revisiting the access layer as a new data source is discovered during exploration, without invalidating the existing assess work
- Delivering an analysis with documented assumptions so the next analyst (or the same analyst next month) can re-run and extend it
- Asking "how will this be updated when the data changes?" and encoding the answer in the access layer — even if the analysis itself was exploratory

**Counter-examples**:
- Producing a notebook that reaches an interesting conclusion but cannot be re-run by anyone else
- Making cleaning decisions during exploration and leaving them buried in a notebook without extracting them into assess
- Treating the first working model as the final answer without documenting what was tried and why alternatives were rejected
- Building an analysis pipeline that works on a static data snapshot with no plan for refreshing when the data changes
- Optimising model performance on a benchmark without considering whether the model can be deployed under real-world constraints

**Conflicts**:
- Documenting the spiral of exploration takes time that feels at odds with the urgency of getting to an answer
- Resolution: Even brief notes in code comments or a CIP stub preserve enough context to make the work reusable; perfect documentation is the enemy of any documentation
- Some exploration is genuinely throwaway and does not warrant structure
- Resolution: Work that informs a decision or will be shared with others is never truly throwaway; apply the minimum structure that makes it reproducible

**Version**: 1.1 (2026-05-13)
