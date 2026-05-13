# Fynesse

Fynesse is a lightweight framework for structuring data science projects around the **Access → Assess → Address** paradigm. It is designed for operational data science: contexts where data is live, evolving, and imperfect, and where analyses need to be maintained and shared over time.

## What is Fynesse?

The Fynesse framework divides data science work into three distinct phases:

- **Access** — Obtain data from its source. Document the legal and ethical basis for each data source (license, GDPR, provenance). Handle errors and authentication.
- **Assess** — Understand the data *without* the analysis question in mind. Check quality, encodings, missing values, and distributions. This work is question-agnostic so it can be reused across analyses.
- **Address** — Answer the specific question. Apply statistical modelling, machine learning, or visualisation. Question-specific feature engineering and cleaning lives here.

The critical insight: **Assess must be possible without knowing the analysis question.** This makes assessment work a public good — reusable by any analyst working on the same dataset.

## Install into a Data Analysis Project

From the root of any data analysis project:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lawrennd/fynesse/main/install.sh)
```

This will:
1. Create a `fynesse/` module directory with template stubs (`access.py`, `assess.py`, `address.py`, `config.py`, `defaults.yml`)
2. Write AI assistant rules for Cursor, Claude Code, OpenAI Codex, and GitHub Copilot
3. Update `.gitignore` to exclude machine-specific configuration

**Template stubs are only written if they don't already exist.** Re-running the install on an existing project updates AI rules without overwriting your code.

## What Gets Installed

```
<your-project>/
├── fynesse/
│   ├── access.py       ← obtain data (implement this first)
│   ├── assess.py       ← assess quality (question-agnostic)
│   ├── address.py      ← answer your question
│   ├── config.py       ← configuration loader
│   └── defaults.yml    ← shared configuration defaults
├── .cursor/rules/
│   └── fynesse-framework.mdc
├── CLAUDE.md           ← Fynesse section added
├── AGENTS.md           ← Fynesse section added
└── .github/
    └── copilot-instructions.md
```

## Updating

Re-running `install.sh` updates AI rules and system files. Your `access.py`, `assess.py`, and `address.py` are never overwritten.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lawrennd/fynesse/main/install.sh)
```

## Framework Principles

Fynesse is guided by six tenets — see [`tenets/fynesse-tenets.md`](tenets/fynesse-tenets.md):

1. **Separation of Concerns** — Access, Assess, and Address are always distinct
2. **Assess Without the Question** — Assessment is question-agnostic and reusable
3. **Legal and Ethical Access** — Data access requires explicit legal and ethical documentation
4. **Repeatable Assessment** — Assessment outputs are reproducible and shareable
5. **Systems Engineering Mindset** — Treat data science as engineering, not just exploration
6. **Operational Data Science** — Designed for live, evolving data under real-world conditions

## Repository Structure

This repository follows a dogfooding approach — it uses [VibeSafe](https://github.com/lawrennd/vibesafe) for its own project management while providing the Fynesse framework for others:

```
fynesse/
├── README.md                  # This file
├── install.sh                 # Install into a target data analysis repo
├── rules/
│   └── fynesse-framework.md   # Canonical AI assistant rules (source of truth)
├── templates/
│   └── fynesse/               # Template stubs installed into target projects
│       ├── access.py
│       ├── assess.py
│       ├── address.py
│       ├── config.py
│       └── defaults.yml
├── tenets/
│   ├── fynesse/               # Individual tenet files
│   ├── fynesse-tenets.md      # Combined tenets document
│   └── fynesse-tenets.yaml    # Machine-readable tenets
├── requirements/              # WHAT outcomes the framework provides
├── cip/                       # HOW the framework is designed (Code Improvement Plans)
├── backlog/                   # Task tracking
└── .cursor/rules/             # AI rules for developing fynesse itself
```

## Background

The Fynesse paradigm was developed from experience in operational data science — in the Amazon supply chain and in the UK Covid-19 pandemic response — where analyses must be maintained, updated, and shared under time pressure with real, messy data. See the [Engineering Data Science lecture](https://mlatcl.github.io/advds/lectures/04-03-engineering-data-science.html) for the original framing.

The [`fynesse_template`](https://github.com/lawrennd/fynesse_template) repository provides a GitHub template for starting a new fynesse-based project from scratch.

## License

MIT
