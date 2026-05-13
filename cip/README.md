# Code Improvement Plans (CIPs)

## Overview

Code Improvement Plans (CIPs) describe HOW to achieve the requirements defined in `requirements/`. They serve as self-contained design documents that capture the rationale behind technical decisions, track implementation progress, and provide context for contributors and AI assistants.

CIPs implement requirements. Before writing a CIP, check whether there is an existing requirement it relates to.

## Process

1. **Create a New CIP**:
   - Copy `cip_template.md`
   - Name it `cipXXXX.md` where `XXXX` is a four-digit hex ID (e.g. `cip0004.md`)
   - Fill in `related_requirements` with the requirement IDs this CIP addresses
   - Set `status: Proposed`

2. **Review and Accept**:
   - Share the CIP for feedback
   - Update based on feedback
   - Change status to `Accepted` when ready to implement

3. **Implementation**:
   - Update the `Implementation Status` checkboxes as tasks complete
   - Change status to `In Progress` when work begins
   - Change status to `Implemented` when work is complete

4. **Closure and Compression**:
   - Change status to `Closed` after verification
   - Set `compressed: true` once key decisions have been incorporated into permanent documentation (README, Sphinx, etc.)

## CIP Status Values

| Status | Meaning |
|--------|---------|
| `Proposed` | Initial idea documented, not yet reviewed |
| `Accepted` | Approved and ready to implement |
| `In Progress` | Actively being implemented |
| `Implemented` | Work complete, awaiting verification |
| `Closed` | Verified and complete |
| `Rejected` | Will not be implemented |
| `Deferred` | Postponed (use `blocked_by` field) |

## Current CIPs

| CIP | Title | Status |
|-----|-------|--------|
| [CIP-0001](cip0001.md) | Core Access-Assess-Address Module Architecture | Proposed |
| [CIP-0002](cip0002.md) | Installation Mechanism for Target Data Analysis Repos | Proposed |
| [CIP-0003](cip0003.md) | Canonical AI Rules for the Fynesse Framework | Proposed |
| [CIP-0004](cip0004.md) | VibeSafe Integration: User-Defined Checks and Tenet Layering | Proposed |

## What Makes a Good CIP

A good CIP should:

1. Clearly state the problem being solved and link to the relevant requirements
2. Explain the proposed solution in enough detail that another contributor could implement it
3. Consider alternative approaches and explain why they were rejected
4. Address backward compatibility
5. Include a testing strategy
6. Be self-contained — do not create separate design documents; put all design rationale here
7. If supplementary materials are needed, use a subdirectory: `cip/cip0001/`
