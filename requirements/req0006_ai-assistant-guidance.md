---
id: "0006"
title: "Fynesse Provides AI Assistant Rules that Guide LLMs to Follow the AAA Framework"
status: "Proposed"
priority: "High"
created: "2026-05-13"
last_updated: "2026-05-13"
related_tenets:
  - "separation-of-concerns"
  - "assess-without-the-question"
  - "systems-engineering-mindset"
stakeholders:
  - "data scientists using AI coding assistants"
  - "students"
  - "LLM coding assistants"
tags:
  - ai-assistance
  - rules
  - guidance
---

# REQ-0006: Fynesse Provides AI Assistant Rules that Guide LLMs to Follow the AAA Framework

## Description

The Fynesse framework must install AI assistant rules that guide LLM coding assistants (Cursor, Claude Code, GitHub Copilot, OpenAI Codex) to generate and modify code in a way that respects the Access-Assess-Address separation. Without these rules, LLMs will default to writing monolithic data science scripts that mix access, assessment, and analysis. The rules must cover the AAA module boundaries, common anti-patterns to avoid, the configuration pattern, and the workflow for adding new analyses.

**Why this matters**: The primary audience for Fynesse in practice is data scientists who use AI coding assistants to generate and iterate on code. If the AI assistant does not know the framework, it will generate code that violates it, undoing the framework's benefits. The rules are the mechanism by which the framework's principles are communicated to the AI assistant at the point of code generation.

**Who benefits**: Data scientists using AI coding assistants; students learning the framework with AI help; any project where LLMs contribute code.

## Acceptance Criteria

- [ ] AI assistant rules are installed for Cursor (`.cursor/rules/fynesse-framework.mdc`), Claude Code (`CLAUDE.md` section), Codex (`AGENTS.md` section), and GitHub Copilot (`.github/copilot-instructions.md` section)
- [ ] The rules explain the AAA module boundaries and what each module must and must not contain
- [ ] The rules list the most common anti-patterns (e.g. mixing access and addressing, question-specific assessment) with examples
- [ ] The rules are derived from a single canonical source (`rules/fynesse-framework.md`) to avoid inconsistency
- [ ] The rules are updated when the install script is re-run, so framework updates are reflected in AI guidance

## Notes

The Cursor rule is scoped to `fynesse/**` so it activates when editing files in the fynesse module directory. The CLAUDE.md and AGENTS.md sections use a fenced marker so they can be replaced on reinstall without affecting user content.

## References

- **Related Tenets**: separation-of-concerns, assess-without-the-question, systems-engineering-mindset
- **Related CIPs**: cip0003 (canonical AI rules design)

## Progress Updates

### 2026-05-13
Requirement created as part of the initial Fynesse framework bootstrap.
