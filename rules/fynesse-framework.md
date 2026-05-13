# Fynesse Framework

Fynesse is a lightweight framework for structuring data science projects around three distinct phases: **Access**, **Assess**, and **Address**. It is designed for operational data science — contexts where data is live, evolving, and imperfect, and where analyses need to be maintained over time.

## The Three Phases

```
Access → Assess → Address
```

| Phase | Module | Purpose |
|-------|--------|---------|
| **Access** | `fynesse/access.py` | Obtain data from its source |
| **Assess** | `fynesse/assess.py` | Understand the data's properties and quality |
| **Address** | `fynesse/address.py` | Answer a specific analysis question |

The key invariant: **Assess must be possible without knowing the analysis question.** Assessment is a public good — it describes the data as it is, so that multiple analyses from different questions can reuse the same quality assessment work.

---

## Module Boundaries

### `access.py` — Obtaining Data

**Must contain:**
- Functions that fetch, download, or query data from a source
- Documentation of the legal/ethical basis for each data source (license, GDPR, provenance)
- Error handling for access failures (network errors, authentication, missing files)

**Must NOT contain:**
- Data quality checks or cleaning logic (that is Assess)
- Analysis or modelling logic (that is Address)
- Any logic that depends on the specific analysis question

**Key function:**
```python
def data() -> pd.DataFrame | None:
    """Fetch and return the raw data. Document legal/ethical basis here."""
```

**Correct example:**
```python
# Source: ONS open data, OGL v3 license
# Accessed: 2026-05-13, URL: https://...
def data():
    logger.info("Fetching ONS population data")
    try:
        df = pd.read_csv("https://...population.csv")
        return df
    except Exception as e:
        logger.error(f"Failed to access data: {e}")
        return None
```

**Incorrect example:**
```python
def data():
    df = pd.read_csv("population.csv")
    df = df.dropna()  # WRONG: cleaning belongs in assess
    df = df[df['year'] >= 2010]  # WRONG: filtering for a specific question belongs in address
    return df
```

---

### `assess.py` — Understanding Data

**Must contain:**
- Functions that examine the data's structure, quality, and properties
- Checks for missing values, data types, encodings, outliers, distributions
- Visualisation of data properties (distributions, missing value maps, etc.)
- Question-agnostic cleaning (e.g. dropping rows where ALL fields are null)

**Must NOT contain:**
- Any reference to the specific analysis question
- Imputation or cleaning decisions motivated by downstream model requirements
- Filtering or subsetting motivated by the analysis question
- Direct calls to data sources (use `access.data()` instead)

**Key functions:**
```python
def data() -> pd.DataFrame | Any:
    """Load via access, assess quality, return cleaned/annotated data."""

def view(data) -> None:
    """Visualise data properties for quality review."""

def labelled(data) -> pd.DataFrame:
    """Return a labelled subset suitable for supervised learning."""
```

**Correct example:**
```python
def data():
    df = access.data()
    if df is None:
        return None
    # Document what we found — question-agnostic quality assessment
    missing = df.isnull().sum()
    logger.info(f"Missing values per column: {missing.to_dict()}")
    # Drop rows that are entirely empty (always justified, not question-specific)
    df = df.dropna(how='all')
    return df
```

**Incorrect example:**
```python
def data():
    df = access.data()
    # WRONG: imputing based on what the regression model needs
    df['income'].fillna(df['income'].mean(), inplace=True)
    # WRONG: dropping columns because they are not relevant to our question
    df = df[['year', 'population', 'income']]
    return df
```

---

### `address.py` — Answering the Question

**Must contain:**
- Functions that answer a specific analysis question using assessed data
- Statistical modelling, machine learning, visualisation for decision-making
- Question-specific feature engineering and cleaning

**Must NOT contain:**
- Direct data access (do not call `pd.read_csv()` or API functions here)
- Calls to `access.data()` except in exceptional documented circumstances
- Logic that is not specific to the analysis question (that belongs in assess)

**Key function:**
```python
def analyze_data(data: pd.DataFrame) -> dict:
    """Answer the analysis question. Receives assessed data as input."""
```

**Correct example:**
```python
def predict_house_prices(data: pd.DataFrame) -> dict:
    """Predict house prices using assessed property data."""
    # Question-specific feature engineering is fine here
    features = data[['bedrooms', 'floor_area', 'distance_to_centre']].dropna()
    # ... model fitting and evaluation
    return {'model': model, 'rmse': rmse}
```

**Incorrect example:**
```python
def predict_house_prices() -> dict:
    df = pd.read_csv("houses.csv")  # WRONG: access belongs in access.py
    df = df.dropna()               # WRONG: general cleaning belongs in assess.py
    # ...
```

---

## Configuration Pattern

Configuration uses a three-level layered YAML system:

| File | Committed? | Purpose |
|------|-----------|---------|
| `fynesse/defaults.yml` | Yes | Shared defaults for all users |
| `fynesse/machine.yml` | No (gitignored) | Local/machine-specific overrides |
| `_config.yml` | Yes | Project-level overrides |

`config.py` merges these in order; later files override earlier ones.

**Example `defaults.yml`:**
```yaml
data_url: https://raw.githubusercontent.com/...
```

**Example `machine.yml` (gitignored):**
```yaml
db_password: my-local-secret
data_path: /Users/me/datasets/
```

**Never hardcode credentials, paths, or URLs in Python files.** Put them in `defaults.yml` (if shareable) or `machine.yml` (if local).

---

## Common Anti-Patterns

### 1. Monolithic pipeline (mixing all three phases)
```python
# WRONG: access + assess + address in one block
df = pd.read_csv("data.csv")
df = df.dropna()
df['feature'] = df['x'] * df['y']
model.fit(df)
```
Fix: separate into three functions in the three modules.

### 2. Question-specific assessment
```python
# WRONG: in assess.py, imputing based on what the model needs
df['age'].fillna(df['age'].median(), inplace=True)  # "because the regression needs it"
```
Fix: document the missing values in assess; do imputation in address.

### 3. Skipping access
```python
# WRONG: in assess.py or address.py
df = pd.read_csv("raw_data.csv")  # bypasses access
```
Fix: add a `data()` function to access.py and call it from assess.

### 4. Hardcoding credentials or paths
```python
# WRONG: in access.py
conn = psycopg2.connect(host="db.mycompany.com", password="secret123")
```
Fix: put credentials in `machine.yml` and read via `config`.

### 5. No legal/ethical documentation in access
```python
# WRONG: fetching data without any documentation
def data():
    return pd.read_csv("https://some-website.com/dataset.csv")
```
Fix: add a comment documenting the license, provenance, and any privacy considerations.

---

## Workflow: Adding a New Data Source

1. Add a function to `fynesse/access.py` that fetches the data
2. Document the legal/ethical basis in the function's docstring or a comment
3. Add the data URL or connection parameters to `defaults.yml` (if shareable) or `machine.yml`
4. Update `fynesse/assess.py` to call the new access function and perform quality checks
5. Write or update an address function to use the assessed data

## Workflow: Adding a New Analysis

1. Check whether `fynesse/assess.py` already covers the data quality you need — if yes, call it directly
2. If new quality checks are needed, add them to assess.py (question-agnostic only)
3. Add your analysis function to `fynesse/address.py`
4. Pass assessed data as a parameter; do not call access functions from address

---

## Using VibeSafe Governance for Analysis Design

This project uses VibeSafe alongside Fynesse. VibeSafe's CIP/Requirements/Backlog framework maps directly onto the data science workflow:

| VibeSafe artefact | What it means in a data science project |
|------------------|----------------------------------------|
| **Requirement** (WHAT) | The analysis question and its success criteria — e.g. "Predict house prices for Cambridge postcodes with RMSE < £X" |
| **CIP** (HOW) | The analysis design — what data source, what quality checks in assess, what method in address, why this approach |
| **Backlog task** (DO) | Concrete implementation steps — "implement access.data()", "write assess quality checks for missing postcodes", "fit baseline linear model" |
| **Tenet** (WHY) | Fynesse + VibeSafe + project-specific principles that guide all decisions |

### Starting a new analysis

When a user asks you to implement a new analysis or the context shows no CIP for the current work:

1. **First, create a Requirement** — what should the analysis achieve? (outcome, not method)
2. **Then, create a CIP** — how will you access the data, assess its quality, and address the question? Document why you chose this approach.
3. **Then, create backlog tasks** — one per implementation step (access, assess, address)
4. **Then, implement** — starting with `fynesse/access.py`
5. **Run `./whats-next`** to see current project status

Do not start implementing before there is a Requirement and a CIP. If the user asks for quick exploratory code, still create at least a draft CIP that records the design intent.

### Tenet layers

This project has three layers of tenets:
- `tenets/vibesafe/` — VibeSafe governance principles (process, documentation, human authorship)
- `tenets/fynesse/` — Fynesse data science principles (AAA separation, assess without the question, etc.)
- `tenets/myproject/` — Domain-specific principles (created by the analyst for this project)

When making design decisions, reference relevant tenets from all three layers.

---

## Updating Fynesse

To update the framework files in a project:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lawrennd/fynesse/main/install.sh)
```
This updates AI rules, tenets, and system files. Your `access.py`, `assess.py`, and `address.py` are never overwritten.
