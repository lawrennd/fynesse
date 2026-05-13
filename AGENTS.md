# VibeSafe Project Documentation for Codex

This file provides project context and guidelines to OpenAI Codex (and compatible AI coding assistants).
The information below helps understand the VibeSafe project structure, development practices,
and component-specific guidance.

---

# VibeSafe General Development Guidelines

## 🔧 Essential Development Practices

### 1. Git Operations - Surgical Precision Required

**❌ NEVER use generic git adds:**
```bash
git add .          # ❌ Too broad, commits unintended files
git add -A         # ❌ Too broad, commits unintended files  
git add *          # ❌ Too broad, commits unintended files
```

**✅ ALWAYS add files surgically:**
```bash
git add specific-file.md                    # ✅ Targeted
git add backlog/features/my-task.md         # ✅ Specific user content
git add cip/cip0001.md scripts/my-script.py # ✅ Multiple specific files
```

**Why:** VibeSafe projects contain both system files (templates, generated files) and user content. Generic adds can accidentally commit VibeSafe infrastructure files that shouldn't be in your project repository.

### 2. Python Environment Awareness

**⚠️ ALWAYS verify Python environment before running scripts:**

```bash
# Check current Python and environment
which python3
python3 --version

# Check if you're in a virtual environment
echo $VIRTUAL_ENV

# For VibeSafe scripts, usually run from project root:
./whats-next                          # ✅ Wrapper activates .venv-vibesafe automatically
.venv-vibesafe/bin/python scripts/whats_next.py  # ✅ Direct venv execution
python scripts/whats_next.py          # ❌ May fail if PyYAML not in system Python
```

**📦 VibeSafe Virtual Environment:**
- VibeSafe uses `.venv-vibesafe` for its dependencies (PyYAML)
- This avoids conflicts with user project `.venv` directories
- The `./whats-next` wrapper handles activation/deactivation automatically
- For direct execution: use wrapper OR activate `.venv-vibesafe` manually

**🤔 When in doubt, ASK THE USER:**
- "Should I run this in the current environment or activate a virtual environment?"
- "Which Python environment would you like me to use?"
- "Should I use the project's .venv (yours) or .venv-vibesafe (VibeSafe's)?"

### 3. Date Accuracy for VibeSafe Components

**📅 ALWAYS verify today's date before creating:**

**✅ Check date automatically with shell commands:**
```bash
# Get today's date in YYYY-MM-DD format
date +%Y-%m-%d

# Alternative formats if needed
date +%Y%m%d           # 20250726 format
date "+%B %d, %Y"      # July 26, 2025 format
```

**For Backlog Tasks:**
```bash
# Task naming: YYYY-MM-DD_description.md
# Example: 2025-07-26_implement-feature.md
TODAY=$(date +%Y-%m-%d)
echo "Today: $TODAY"
```

**For CIPs:**
```yaml
# YAML frontmatter requires accurate dates
created: "2025-07-26"
last_updated: "2025-07-26"
```

**🗓️ Process:**
- ✅ **Run `date +%Y-%m-%d`** to get today's date automatically
- ✅ **Use in file naming** and YAML frontmatter
- 🤔 **Only ask user** if date seems wrong or if creating retroactive entries

### 4. VibeSafe File Classification Awareness

**Always distinguish between:**

**🔧 System Files (Don't commit to user projects):**
- `backlog/README.md`, `cip/README.md` - VibeSafe documentation
- `task_template.md`, `cip_template.md` - VibeSafe templates  
- `.cursor/rules/*`, `.github/copilot-instructions.md`, `CLAUDE.md`, `AGENTS.md` - AI assistant context files
- `scripts/whats_next.py`, `update_index.py` - VibeSafe tools

**📝 User Content (Always commit):**
- `README.md` (project root) - User's project documentation
- `backlog/features/YYYY-MM-DD_task.md` - User's tasks
- `cip0001.md`, `cip0002.md` - User's CIPs
- User's actual requirements and project files

### 5. Before Making Changes

**✅ ALWAYS:**
- Check current working directory (`pwd`)
- Verify you're in the right branch (`git branch`)
- Understand what type of files you're working with (system vs user)
- Ask for clarification if unsure about environment or scope

**❌ NEVER:**
- Make assumptions about the current environment
- Commit files without understanding their purpose
- Use broad git operations without explicit permission
- Create dated files without confirming the date

### 6. Testing Before Commits

**🧪 ALWAYS TEST BEFORE COMMITTING:**

**✅ Required Testing Points:**
```bash
# After implementing new features
# Run appropriate test suite for your project
npm test                    # Node.js projects
python -m pytest tests/ -v  # Python projects
bats scripts/test/*.bats    # Shell script projects
go test ./...              # Go projects
cargo test                 # Rust projects
# etc.

# After modifying installation scripts
bats scripts/test/install-test.bats

# After changing core functionality
# Run comprehensive test suite with verbose output

# Before staging any changes
# Ensure all tests pass: npm test && echo "✅ All tests passed"
```

**🎯 Testing Checklist:**
- ✅ **Unit tests pass** for modified modules
- ✅ **Integration tests pass** for affected systems
- ✅ **Installation tests pass** for script changes
- ✅ **No new test failures** introduced
- ✅ **Test coverage maintained** or improved

**⚠️ Why Testing Matters:**
- **Quality**: Ensures changes work as expected
- **Regression Prevention**: Catches unintended side effects
- **Confidence**: Validates implementation against requirements
- **Documentation**: Tests serve as working examples

### 7. Documentation Lifecycle - VibeSafe System First, Formal Docs After

**📚 DOCUMENTATION FOLLOWS A NATURAL LIFECYCLE:**

VibeSafe distinguishes between **active design** (still being discussed) and **finalized documentation** (implementation complete and validated).

**🎯 The Four Phases of Documentation:**

**Phase 1: Design & Discussion → Use VibeSafe System**
- **When**: Planning, designing, discussing architecture
- **Where**: CIPs, backlog tasks, requirements
- **Why**: Flexible, collaborative, easy to update during iteration

**Phase 2: Implementation → Self-Documenting Code**
- **When**: Writing code to implement the design
- **Where**: Clear naming, type hints, docstrings, comments
- **Why**: Code itself explains behavior without separate docs

**Phase 3: Validation → Test & Close CIP**
- **When**: After implementation is complete, testing passes
- **Where**: Update CIP status to "Closed", mark `compressed: false`
- **Why**: Signals implementation is done, compression can follow

**Phase 4: Compression → Update Formal Documentation**
- **When**: After CIP is closed (immediately or periodically)
- **Where**: Sphinx, ReadTheDocs, or other formal doc systems
- **Why**: Distills development history into permanent, accessible documentation

**❌ NEVER create separate design/architecture docs during discussion:**
```bash
❌ docs/architecture.md          # Use CIPs instead while designing
❌ docs/implementation-plan.md   # Use backlog tasks instead  
❌ DESIGN.md                     # Use CIPs instead while planning
❌ TODO.md                       # Use backlog instead
❌ CONTRIBUTING.md               # Document in CIPs/tenets first
```

**✅ The VibeSafe Documentation Flow:**

```bash
# ✅ PHASE 1: Design/Discussion → VibeSafe System
# Create CIP for architecture decisions
cp cip/cip_template.md cip/cip0001.md
# Edit CIP with design rationale, implementation plan
# Iterate on the CIP as discussion evolves

# ✅ PHASE 2: Implementation → Self-Documenting Code
# Write clear, well-named code with good docstrings
def calculate_user_score(user_id: str, period: str) -> float:
    """Calculate aggregated score for a user over a time period.
    
    Args:
        user_id: Unique identifier for the user
        period: Time period ('daily', 'weekly', 'monthly')
        
    Returns:
        Aggregated score as a float between 0.0 and 100.0
    """
    # Implementation with clear variable names and structure

# ✅ PHASE 3: Validation → Test & Close CIP
# Tests pass, implementation validated
git add cip/cip0012.md
# (Mark status: Closed, compressed: false)
git commit -m "Complete CIP-0012 implementation and validation"

# ✅ PHASE 4: Compression → Formal Documentation
# Distill CIP knowledge into permanent docs
git add docs/source/api.rst README.md
git add cip/cip0012.md  # Mark compressed: true
git commit -m "Compress CIP-0012: Update formal docs with API reference"
```

**✅ Table: Where Documentation Belongs by Phase**

| What to Document | Phase 1: Design | Phase 2: Implementation | Phase 3: Validation | Phase 4: Compression |
|---|---|---|---|---|
| **Architecture decisions** | CIPs | Self-doc code | Close CIP | Sphinx/formal docs |
| **Design rationale** | CIP "Motivation" | Self-doc code | Close CIP | Sphinx/formal docs |
| **Implementation plans** | CIP "Implementation" | Self-doc code | Close CIP | Sphinx/formal docs |
| **Tasks and TODOs** | Backlog tasks | Self-doc code | Close tasks | N/A (remove when done) |
| **Requirements** | requirements/ | Self-doc code | Validate reqs | Sphinx/formal docs |
| **API behavior** | CIP sketches | Self-doc code | Close CIP | Sphinx/formal docs |
| **Guiding principles** | Tenets | N/A | N/A | Tenets (permanent) |

**🎯 Key Principle: Don't Duplicate Work**

- **During design**: Use VibeSafe system (easy to change)
- **During implementation**: Code should explain itself
- **After finalization**: Formalize in Sphinx/docs (permanent reference)

**Never create architecture docs that duplicate what's in CIPs while design is still evolving. Wait until implementation is complete and validated, then formalize.**

**✅ Acceptable Standalone Documentation:**
- `README.md` (project root) - Brief overview, links to VibeSafe system and formal docs
- `docs/` with Sphinx - Formal documentation for finalized, implemented features
- `docs/source/` - API reference, user guides, tutorials (post-implementation)

**🤔 When in Doubt:**
- Still designing/discussing? → **Phase 1: Use CIPs, backlog, requirements**
- Implementing? → **Phase 2: Make code self-documenting**
- Implementation done and tested? → **Phase 3: Close CIP, mark `compressed: false`**
- CIP closed? → **Phase 4: Compress into formal docs (Sphinx), mark `compressed: true`**
- Never create standalone design docs that duplicate CIPs during active development

### 8. Git Workflow and Regular Commits

**🔄 COMMIT EARLY AND OFTEN:**

**✅ Required Commit Points:**
```bash
# After creating documentation
git add backlog/features/2025-07-26_my-task.md
git commit -m "Add backlog task for feature implementation"

# After creating CIPs
git add cip/cip000F.md cip/README.md
git commit -m "Add CIP-000F for new feature architecture"

# Before major structural changes
git add src/module.py tests/test_module.py
git commit -m "Checkpoint before refactoring module structure"

# After completing implementation
git add src/ tests/ docs/
git commit -m "Complete feature implementation with tests"
```

**📅 Natural Commit Rhythm:**
- ✅ **After planning**: Create backlog/CIP → commit
- ✅ **Before refactoring**: Save current state → commit  
- ✅ **After implementation**: Complete feature → commit
- ✅ **After testing**: Fix tests and bugs → commit
- ✅ **Before major changes**: Create checkpoint → commit

**🎯 Commit Message Format:**
```bash
# Good commit messages
git commit -m "Add normalize_status() function to update_index.py"
git commit -m "Fix test failures for status normalization"
git commit -m "Update backlog task status to completed"

# Reference related items when appropriate
git commit -m "Implement CIP-000E clean installation philosophy"
git commit -m "Complete backlog task: 2025-07-26_feature-name"
```

**⚠️ Why Regular Commits Matter:**
- **Safety**: Easy to revert problematic changes
- **Progress**: Clear development history and milestones
- **Collaboration**: Others can follow your progress
- **Documentation**: Commit messages tell the story of development

## 🎯 Quick Reference

| Action | Rule | Example |
|--------|------|---------|
| **Git Add** | Always surgical | `git add backlog/features/task.md` |
| **Git Commit** | Regular checkpoints | After backlogs, CIPs, before refactoring |
| **Python Exec** | Verify environment first | `which python3` then ask if unsure |
| **Create Task** | Confirm date | "Today is 2025-12-23, correct?" |
| **File Changes** | Know system vs user | Check file classification guides |
| **Testing** | Test before committing | `npm test` or `pytest tests/` before `git add` |
| **Documentation** | Follow lifecycle | Design→CIPs, Implement→Self-doc, Done→Sphinx |

These guidelines help ensure clean, predictable, and professional VibeSafe development practices.

---

# VibeSafe Update Guide

## Update VibeSafe

```bash
bash <(curl -s https://raw.githubusercontent.com/lawrennd/vibesafe/main/scripts/install-minimal.sh)
```

**Clean Installation Philosophy**: Every installation is a reinstallation. System files are updated, user content is preserved.

## For AI Assistants

- Never manually edit VibeSafe system files (they're overwritten on update)
- Always use the installation script to update
- Preserve user content (backlog tasks, CIPs, tenets, README, code)

---

# VibeSafe Project Status Summarizer ("What's Next" Script)

## What is the "What's Next" Script?

The "What's Next" script is a project status summarizer that helps LLMs and human users quickly understand the current state of the VibeSafe project and identify pending tasks.

## When to Use the "What's Next" Script

Use the "What's Next" script when:

- You are beginning work on the VibeSafe project and need context
- You want to understand the current project priorities
- You need to identify which files need YAML frontmatter
- You are looking for high-priority tasks to work on
- You need to see the Git status, CIPs, and backlog in one view

## How to Run the Script

After installation (using `./install-whats-next.sh`), run the script from the root directory of the VibeSafe repository:

```bash
./whats-next
```

If you prefer to run it directly, make sure to activate the VibeSafe virtual environment first:

```bash
source .venv-vibesafe/bin/activate
python scripts/whats_next.py
deactivate  # When finished
```

**Note**: VibeSafe uses `.venv-vibesafe` for its own dependencies (PyYAML) to avoid conflicts with user project virtual environments that typically use `.venv`.

### Command Line Options

The script supports several command line options:

- `--no-git`: Skip Git status information
- `--no-color`: Disable colored output
- `--cip-only`: Only show CIP information
- `--backlog-only`: Only show backlog information
- `--quiet`: Suppress all output except next steps

Examples:

```bash
# Show only the next steps (useful for quick reference)
./whats-next --quiet

# Focus only on CIPs
./whats-next --cip-only
```

## What the Script Provides

The script provides a comprehensive overview of:

1. **Git Status**: Current branch, recent commits, modified files, untracked files
2. **CIP Status**: All CIPs categorized by status (proposed, accepted, implemented, closed)
3. **Backlog Status**: Backlog items with priority and status information
4. **Recommended Next Steps**: Prioritized actions based on the project's current state
5. **Files Needing YAML Frontmatter**: Specific files missing required metadata

## For LLMs: How to Use This Information

As an LLM working on the VibeSafe project, you should:

1. Run the "What's Next" script at the beginning of your session
2. Review the recommended next steps section for guidance on priorities
3. Pay attention to any files needing YAML frontmatter
4. Focus on high-priority backlog items and accepted CIPs
5. Check the current branch before making changes

This approach ensures you have the necessary context to make informed decisions about what to work on and how to prioritize tasks.

## Installation

The "What's Next" script requires Python 3.6+ and the PyYAML library. It uses a virtual environment to manage dependencies.

To install:

```bash
# This creates a virtual environment and sets up a convenient wrapper
./install-whats-next.sh
```

## YAML Frontmatter

The script checks for YAML frontmatter in CIPs and backlog items. All such files should have proper frontmatter with required metadata fields. For examples, see the [YAML Frontmatter Examples](mdc:../docs/yaml_frontmatter_examples.md) document.

## Documentation

For detailed documentation on the "What's Next" script, see [docs/whats_next_script.md](mdc:../docs/whats_next_script.md).

---


# VibeSafe Project Backlog System

> **Note**: This file provides context to AI coding assistants (Cursor, Claude Code, GitHub Copilot, etc.).  
> The content is standard markdown and works with any AI assistant that can read project files.

## What is the Backlog System?

The Backlog System is a structured approach to tracking tasks, issues, and improvements that need to be implemented in the Lynguine project. The backlog serves as:

1. *Task management* for organizing and prioritizing work items
2. *Documentation* of planned features and improvements
3. *Project planning* tool for coordinating work across the team
4. *Historical record* of completed and abandoned tasks

## When to Use the Backlog System

Add items to the backlog when:

- You identify a bug that doesn't need immediate fixing
- You have an idea for a new feature or enhancement
- You discover technical debt that should be addressed
- You need to track documentation improvements
- You want to propose infrastructure changes

## Backlog Directory Structure

The `backlog/` directory contains all task files and follows this structure:

```
backlog/
├── README.md                 # Overview of the backlog system
├── task_template.md          # Template for creating new tasks
├── index.md                  # Auto-generated index of all tasks
├── update_index.py           # Script to maintain the index
├── documentation/            # Documentation-related tasks
├── infrastructure/           # Infrastructure-related tasks
├── features/                 # Feature-related tasks
└── bugs/                     # Bug-related tasks
```

## VibeSafe File Classification

**⚠️ IMPORTANT: VibeSafe System vs User Files**

When working with VibeSafe projects, be aware of the distinction between system files and user content:

### 🔧 VibeSafe System Files (Don't commit these unless updating VibeSafe itself)
- `backlog/README.md` - System documentation 
- `backlog/task_template.md` - Template file
- `backlog/update_index.py` - Index generation script
- `backlog/index.md` - Auto-generated index (updates frequently)
- `.cursor/rules/*`, `.github/copilot-instructions.md`, `CLAUDE.md`, `AGENTS.md` - AI assistant context files
- `scripts/whats_next.py` - Status script
- `install-whats-next.sh` - Installation script
- `whats-next` - Wrapper script

### 📝 User Content (Always commit these)
- `backlog/features/*.md` - User-created feature tasks
- `backlog/bugs/*.md` - User-created bug tasks  
- `backlog/documentation/*.md` - User-created documentation tasks
- `backlog/infrastructure/*.md` - User-created infrastructure tasks
- Any task files following the `YYYY-MM-DD_description.md` pattern

**Tip**: Focus on committing your actual work (tasks you create) rather than VibeSafe infrastructure files.

## Task Naming Convention

Task files follow one of these naming conventions:

1. `YYYY-MM-DD_short-description.md` (e.g., `2025-05-05_readthedocs-setup.md`)
2. `YYYYMMDD-short-description.md` (e.g., `20250505-readthedocs-setup.md`)

The date-based naming ensures uniqueness and provides a chronological reference.

## Using the Template

To create a new task:

1. Copy the `task_template.md` file to the appropriate category directory
2. Name the file according to the convention (using today's date)
3. Fill out all required sections following the template structure
4. Run the `update_index.py` script to update the index

Example:
```bash
# Copy the template to the appropriate category
cp backlog/task_template.md backlog/features/2023-06-15_search-functionality.md

# Edit the new task
vim backlog/features/2023-06-15_search-functionality.md

# Update the index
python backlog/update_index.py
```

## Using the Backlog System Effectively

Follow these guidelines to make the most of the backlog system:

### 1. Categorize Appropriately

*Rule*: Place tasks in the correct category directory to help with organization.

```
✅ documentation/ for documentation tasks
✅ infrastructure/ for deployment, CI/CD, and system architecture tasks
✅ features/ for new functionality
✅ bugs/ for defect tracking
```

### 2. Status Workflow

*Rule*: Follow the standard status workflow for tasks.

```
Proposed → Ready → In Progress → Completed/Abandoned
```

- *Proposed*: Initial idea or concept
- *Ready*: Fully described and ready for implementation
- *In Progress*: Currently being worked on
- *Completed*: Successfully implemented
- *Abandoned*: Will not be implemented (with explanation)

### 3. Priority Levels

*Rule*: Assign appropriate priority levels to tasks.

```
- High: Critical tasks that should be addressed soon
- Medium: Important tasks that should be addressed in the near future
- Low: Nice-to-have tasks that can be addressed when time permits
```

### 4. Unique Identifiers

*Rule*: Each task should have a unique identifier based on the creation date.

```
✅ 2025-05-05_search-functionality
✅ 2025-05-16_lynguine-compatibility
❌ search-functionality
```

### 5. Update Task Status

*Rule*: Keep the task status up-to-date as implementation progresses.

```
## Progress Updates

### 2025-05-04
Task created with Proposed status.

### 2025-05-20
Updated to Ready status after refining the requirements.

### 2025-06-25
Changed to In Progress as implementation has started.
```

### 6. Integration with GitHub

*Rule*: Link backlog tasks to GitHub issues when applicable.

```
- **GitHub Issue**: #42
```

### 7. Integration with CIPs

*Rule*: Create backlog tasks only when a CIP is **Accepted**, not when it's Proposed.

**Workflow**:
- **CIP Proposed** → Design and discussion phase, no backlog tasks yet
- **CIP Accepted** → Break down into specific backlog tasks for implementation
- **Backlog tasks** → Link back to the CIP they implement

```
✅ CIP-0012: Accepted → Create backlog tasks for each phase
❌ CIP-0012: Proposed → Wait for acceptance before creating tasks

## Related

- CIP: 0002
```

**Why?** Don't create implementation tasks until the design is approved. This avoids wasted effort if the CIP changes or is rejected.

## Task Template Structure

Each task should include these sections:

1. *Title* - Task title (e.g., `# Task: Implement User Authentication`)
2. *Metadata* - ID, title, status, priority, dates, owner, and dependencies
3. *Description* - Detailed description of the task
4. *Acceptance Criteria* - Clear criteria for when the task is complete
5. *Implementation Notes* - Technical approach or considerations
6. *Related* - Links to CIPs, PRs, or documentation
7. *Progress Updates* - Chronological updates on task progress

The template file (`task_template.md`) contains placeholders for all these sections.

## Benefits of Following the Backlog System

- *Improved organization* of project work items
- *Better visibility* into project progress and priorities
- *Clearer communication* about what needs to be done
- *Historical tracking* of completed and abandoned tasks
- *Integration* with CIPs and GitHub issues
- *Categorization* for easier management of different types of tasks

---


# Code Improvement Plans (CIPs)

## What is a CIP?

A Code Improvement Plan (CIP) is a structured approach to proposing, documenting, and implementing meaningful improvements to the codebase. CIPs serve as:

1. *Documentation* for design decisions and architectural changes
2. *Project management* tools to track implementation progress
3. *Communication* mechanisms for sharing ideas with collaborators
4. *Historical records* of why and how code evolved over time

## When to Create a CIP

Create a CIP when you want to make changes that:

- Affect multiple parts of the codebase
- Change fundamental architecture or design patterns
- Introduce new features with significant impact
- Require substantial refactoring or restructuring
- Need coordination across multiple contributors

## CIP Directory Structure

The `cip/` directory in the repository contains all Code Improvement Plans and follows this structure:

```
cip/
├── README.md                 # Overview of the CIP process
├── cip_template.md           # Template for creating new CIPs
├── cip0001.md                # First CIP
├── cip0002.md                # Second CIP
└── ...                       # Additional CIPs
```

## VibeSafe File Classification

**⚠️ IMPORTANT: VibeSafe System vs User Files**

When working with VibeSafe projects, be aware of the distinction between system files and user content:

### 🔧 VibeSafe System Files (Don't commit these unless updating VibeSafe itself)
- `cip/README.md` - System documentation 
- `cip/cip_template.md` - Template file
- `.cursor/rules/*`, `.github/copilot-instructions.md`, `CLAUDE.md`, `AGENTS.md` - AI assistant context files
- `scripts/whats_next.py` - Status script
- `install-whats-next.sh` - Installation script
- `whats-next` - Wrapper script

### 📝 User Content (Always commit these)
- `cip0001.md`, `cip0002.md`, etc. - User-created CIPs
- Any CIP files following the `cip[XXXX].md` pattern (hexadecimal numbering)

**Tip**: Focus on committing your actual CIPs rather than VibeSafe infrastructure files.

### Numbering System

CIPs use a hexadecimal numbering system:

- Starting at `0001` (not `0000`)
- Expressed as four hexadecimal digits (0-9, A-F)
- Examples: `0001`, `000A`, `00FF`, `0100`, etc.
- File naming convention: `cip[number].md` (e.g., `cip0001.md`, `cip00AF.md`)

The hexadecimal system allows for up to 65,535 CIPs (FFFF in hex), which should be more than sufficient for most projects.

### Using the Template

To create a new CIP:

1. Copy the `cip_template.md` file
2. Assign the next available hexadecimal number
3. Name the file `cip[number].md` (e.g., `cip0042.md`)
4. Fill out all required sections following the template structure
5. Add the CIP to the list in `README.md`

Example:
```bash
# Copy the template
cp cip/cip_template.md cip/cip000F.md

# Edit the new CIP
vim cip/cip000F.md

# Update the README
vim cip/README.md
```

## Using CIPs in Code Creation

These guidelines provide a recommended workflow for using CIPs effectively in your development process:

### 1. Plan First, Code Second

*Rule*: Create a CIP before writing any substantial code for the improvement.

```
✅ Create CIP → Get feedback → Refine plan → Implement code
❌ Write code → Document after → Try to explain decisions retrospectively
```

### 1a. CIPs Are Self-Contained Design Documents

*Rule*: Include all design rationale and architectural decisions IN the CIP itself (REQ-000D).

```
✅ Add design details to "Detailed Description" section of CIP
✅ Expand existing CIP sections to include architecture analysis
❌ Create separate files like cip0012-design.md or cip0012-architecture.md
❌ Create standalone DESIGN.md or ARCHITECTURE.md files

If supplementary materials needed:
✅ Create cip/cip0012/ subdirectory for research notes
✅ Keep core design decisions in the CIP itself
```

**Why?** This prevents documentation drift and maintains a single source of truth. Aligns with "Documentation and Implementation as a Unified Whole" tenet.

### 2. One Improvement, One CIP

*Rule*: Each significant improvement should have its own CIP with a unique identifier.

```
✅ CIP-0001: Documentation Improvements
✅ CIP-0002: Test Coverage Enhancement
❌ CIP-0003: Various Code Cleanups and Improvements
```

### 3. Status Tracking

*Rule*: Keep the CIP status accurate and updated as the implementation progresses.

```
- [ ] Proposed → Initial documentation complete
- [ ] Accepted → Plan reviewed and approved
- [ ] Implemented → Code changes complete
- [ ] Closed → Implementation reviewed and merged
```

### 4. Create Backlog Tasks When Accepted

*Rule*: Create backlog tasks only when a CIP moves from Proposed to Accepted.

```
✅ CIP Proposed → Design and discussion, no tasks yet
✅ CIP Accepted → Break down into backlog tasks for implementation
❌ CIP Proposed → Don't create implementation tasks prematurely
```

**Why?** Wait for design approval before creating specific implementation tasks. This avoids wasted effort if the CIP changes or is rejected.

### 5. Branch Naming Convention

*Rule*: Name branches after the CIP they implement.

```
✅ git checkout -b cip000F-refactor-authentication
❌ git checkout -b auth-refactor
```

### 6. Commit Messages

*Rule*: Reference the CIP in your commit messages.

```
✅ CIP-000F: Implement JWT authentication service
❌ Add auth service
```

### 7. Implementation Status Updates

*Rule*: Update the CIP document as you complete implementation steps.

```
## Implementation Status
- [x] Design database schema
- [x] Create migration scripts
- [ ] Implement service layer
- [ ] Add API endpoints
```

### 8. CIP Review Process

*Rule*: Solicit feedback on CIPs before full implementation.

```
✅ Share CIP draft → Get feedback → Revise → Implement
❌ Implement → Request review → Try to retroactively adjust plan
```

### 9. Natural Breakpoints for AI Assistants

*Rule*: AI assistants should pause for user or a potential break in coding at key CIP workflow transitions.

**These are natural stopping points** where the assistant should:
1. Summarize what was done
2. Show the current state (run `./whats-next`)
3. Ask the user if they want to proceed

```
Natural Breakpoints:

1. ✋ After creating a CIP (status: Proposed)
   → Pause: Let user review the design before accepting

2. ✋ After accepting a CIP (status: Proposed → Accepted)
   → Pause: Ask if user wants to create backlog tasks now

3. ✋ After creating backlog tasks (status: Accepted → In Progress)
   → Pause: Let user review progress before implementing

4. ✋ After completing implementation (status: In Progress → Implemented)
   → Pause: Let user test/validate before closing

5. ✋ After validation (status: Implemented → Closed)
   → Done: CIP complete, commit and celebrate!

6. ✋ After CIP closure (status: Closed) ← COMPRESSION STAGE
   → Pause: Ask user about compression
   → Suggest: "CIP-XXXX is closed. Compress into formal docs now or defer?"
   → Options: Compress now, create compression task, skip/defer
```

**Why?** These transitions are:
- Monitored by `./whats-next` script
- Key decision points requiring human judgment
- Natural places to review, test, and adjust course

**Don't do this:**
```
❌ Create CIP → Accept → Create tasks → Start coding → Complete → Close
   (All in one go without pausing)
```

**Do this:**
```
✅ Create CIP (Proposed) → 🛑 PAUSE (user reviews design)
✅ Accept CIP (Proposed → Accepted) → 🛑 PAUSE (ask about creating tasks)
✅ Create tasks & start (Accepted → In Progress) → 🛑 PAUSE (user reviews progress)
✅ Complete implementation (In Progress → Implemented) → 🛑 PAUSE (user tests/validates)
✅ Validate & close (Implemented → Closed) → ✅ CIP complete!
✅ After closure (Closed) → 🛑 PAUSE (ask about compression) → Compress or defer
```

## CIP Template Structure

Each CIP should include these sections:

1. *YAML Frontmatter* - Metadata (author, created, last_updated, status, related_requirements, related_cips, tags)
2. *Header* - CIP number and title (e.g., `# CIP-0042: Authentication Refactoring`)
3. *Status* - Current state checklist (Proposed, Accepted, In Progress, Implemented, Closed, Rejected, Deferred)
4. *Summary* - Brief overview of the proposed improvement and which requirements it addresses
5. *Motivation* - Why this change is needed, what problem it solves
6. *Detailed Description* - Technical details and architectural explanation
7. *Implementation Plan* - Step-by-step plan with specific tasks
8. *Backward Compatibility* - Impact on existing users and systems
9. *Testing Strategy* - How changes will be tested and validated
10. *Related Requirements* - Links to requirements (WHAT) that this CIP implements (HOW)
11. *Implementation Status* - Checklist of completed implementation tasks
12. *References* - Links to relevant documentation, code, or discussions

The template file (`cip_template.md`) contains placeholders for all these sections and provides guidance on what information to include.

## Benefits of Following the CIP Process

- *Improved planning* leads to more cohesive implementations
- *Better communication* among team members about significant changes
- *Higher-quality code* through thoughtful design before implementation
- *Historical record* of why changes were made for future reference
- *Reduced rework* by identifying issues before implementation 
---

---

# VibeSafe Requirements Process

## What Are Requirements?

Requirements define **WHAT** needs to be built - the desired outcomes and states, not implementation details.

## WHAT vs HOW vs DO

VibeSafe uses a clear hierarchy:

| Level | Purpose | Question | Component |
|-------|---------|----------|-----------|
| **WHY** | Foundation principles | Why does this matter? | Tenets |
| **WHAT** | Desired outcomes | What should be true? | **Requirements** (this file) |
| **HOW** | Design approach | How will we achieve it? | CIPs |
| **DO** | Execution tasks | What are we doing now? | Backlog |

### Decision Guide: Am I Writing WHAT or HOW?

When working with requirements, ask:

1. **Does this describe an outcome or a method?**
   - Outcome → Requirement (WHAT)
   - Method → CIP (HOW)

2. **Could multiple approaches achieve this?**
   - Yes → Requirement (WHAT)
   - No, it's specific → CIP or Backlog (HOW/DO)

3. **Does it start with a verb describing work?**
   - "Create...", "Implement...", "Add..." → Usually HOW/DO
   - "Users can...", "System should...", "X must be..." → Usually WHAT

### Good vs Bad Requirements

✅ **Good Requirements (WHAT)**:
- "Users can install VibeSafe with a single command"
- "Project tenets are automatically available to AI assistants"
- "Documentation stays synchronized with implementation"
- "System files don't clutter user repositories"

❌ **Bad Requirements (HOW in disguise)**:
- "Create install-minimal.sh script" ← Implementation (CIP/Backlog)
- "Use PyYAML for parsing" ← Design decision (CIP)
- "Add --no-color flag to whats-next" ← Specific task (Backlog)

## Requirements Directory Structure

```
requirements/
├── README.md                          # Process overview
├── reqXXXX_short-name.md              # Individual requirements (4-digit hex)
└── (optional subdirectories for organization)
```

## Requirements Format

Each requirement uses YAML frontmatter:

```yaml
---
id: "XXXX"  # 4-digit hexadecimal (0001-FFFF)
title: "Requirement Title"
status: "Proposed"  # See statuses below
priority: "Medium"  # High, Medium, Low
created: "YYYY-MM-DD"
last_updated: "YYYY-MM-DD"
related_tenets: []  # Bottom-up: Which tenets inform this?
stakeholders: []  # Optional: Who cares about this?
tags: []  # Optional: Categorization
---
```

## Requirements Status

- **Proposed**: Initial requirement, needs refinement
- **Ready**: Fully defined, ready for CIP creation
- **In Progress**: CIPs and backlog tasks being executed
- **Implemented**: Code complete, needs validation
- **Validated**: Implementation verified against acceptance criteria
- **Deferred**: Postponed (document why)
- **Rejected**: Will not be implemented (document why)

## Bottom-Up Linking Pattern

Requirements link to tenets (WHY), not to CIPs or backlog:

```
Tenets (WHY) ──informs──> Requirements (WHAT) ──guides──> CIPs (HOW) ──breaks into──> Backlog (DO)
```

**In YAML frontmatter**:
- Requirements have `related_tenets` field (bottom-up)
- CIPs have `related_requirements` field (they reference requirements)
- Backlog has `related_cips` field (they reference CIPs)

**Don't do this**:
- ❌ Requirements with `related_cips` or `related_backlog`
- ❌ CIPs with `related_backlog`

**Instead**: Query down from requirements:
- "Which CIPs implement this requirement?" → Query CIPs where `related_requirements` contains this requirement ID
- "Which tasks execute this requirement?" → Query through CIPs to their backlog tasks

## Using Requirements

### 1. Check Requirements Status

```bash
./whats-next  # Shows all component statuses including requirements
```

### 2. Create a New Requirement

```bash
# Copy template
cp templates/requirements/requirement_template.md requirements/reqXXXX_short-name.md

# Fill out YAML and description (focus on WHAT, not HOW)
```

### 3. Connect to Tenets (WHY)

Identify which tenets inform this requirement:

```yaml
related_tenets: ["simplicity-of-use", "user-autonomy"]
```

### 4. Create CIPs (HOW) to Implement

Once a requirement is "Ready", create CIPs that describe HOW to achieve it:

```yaml
# In CIP YAML frontmatter:
related_requirements: ["0001", "0007"]
```

### 5. Status Synchronization

| Requirements Status | CIP Status | Backlog Status |
|---------------------|------------|----------------|
| Proposed/Ready | Proposed | Not Created |
| In Progress | Accepted/In Progress | In Progress |
| Implemented | Implemented | Completed |
| Validated | Closed | Completed |

## Need Help Writing Requirements?

VibeSafe provides thinking tools in `docs/patterns/` (optional reference):
- **Goal Decomposition**: Breaking high-level goals into requirements
- **Stakeholder Identification**: Identifying who benefits from requirements

These are VibeSafe guidance documents, not required user project structure. Consult them when stuck.

See `docs/patterns/README.md` for full pattern catalog and usage guidance.

## VibeSafe File Classification

### 🔧 VibeSafe System Files (Don't commit unless updating VibeSafe)
- `templates/requirements/requirement_template.md` - Template
- `.cursor/rules/*`, `.github/copilot-instructions.md`, `CLAUDE.md`, `AGENTS.md` - AI assistant context files

### 📝 User Content (Always commit)
- `requirements/reqXXXX_*.md` - Your actual requirements

## Benefits of the Requirements Process

- **Improved planning**: Understand WHAT before deciding HOW
- **Better traceability**: Clear links from WHY → WHAT → HOW → DO
- **Reduced rework**: Validate outcomes before implementation
- **Higher quality**: Clear acceptance criteria
- **Better communication**: Stakeholders understand outcomes, not just implementation

---

# VibeSafe Project Tenet System

> **Note**: This file provides context to AI coding assistants (Cursor, Claude Code, GitHub Copilot, etc.).
> The content is standard markdown and works with any AI assistant that can read project files.

## What Are Tenets?

Tenets are guiding principles that inform decision-making in a project. Unlike rigid rules, tenets are principles to consider and balance when making decisions. When different tenets come into conflict, judgment is required to determine which principles should take precedence in a specific context.

**Key characteristics of effective tenets**:

1. **Limited in number**: Typically around 7 (±2) tenets are optimal - enough to cover key principles but few enough to remember and apply consistently
2. **Central to the project**: Tenets should be at the forefront of project thinking, not an afterthought
3. **Memorable and actionable**: Easy to recall and apply in practical situations
4. **Balanced and complementary**: Together provide a comprehensive decision framework

## Tenet Directory Structure

The `tenets/` directory contains project guiding principles:

```
tenets/
├── README.md                 # Tenet system overview
├── vibesafe/                 # VibeSafe's own tenets
│   ├── user-autonomy.md      # Individual tenet files
│   ├── simplicity-of-use.md
│   └── ...
└── [project]/                # User's project tenets
    ├── tenet1.md
    └── tenet2.md
```

## Tenet File Format

Each tenet file uses standard markdown with four required sections:

```markdown
# Project Tenet: [Title]

## Description
[1-2 paragraphs explaining the principle, its importance, and how it guides decisions]

## Quote
*"[Memorable phrase that captures the essence of the tenet]"*

## Examples
- [Concrete example of applying this tenet]
- [Another example in a different context]
- [A third example showing broader application]

## Counter-examples
- [Example of violating this tenet]
- [Another example of what not to do]
- [A third violation example]

## Conflicts
- [Potential conflict with another tenet]
- Resolution: [How to resolve the conflict]
- [Another potential conflict]
- Resolution: [Another resolution approach]
```

## Working with Tenets

### 1. Creating New Tenets

*Rule*: Start with a small set of tenets (5-7 is ideal). More than 9 becomes hard to remember and apply.

```
✅ Create 5-7 focused tenets that cover key principles
✅ Use the tenet template for consistency
✅ Include specific examples and counter-examples
✅ Consider conflicts with other tenets
❌ Create 15+ tenets (too many to remember)
❌ Make tenets too vague or abstract
```

**Process**:
1. Copy `templates/tenets/tenet_template.md` to `tenets/[project]/[tenet-id].md`
2. Fill out all four required sections (Description, Quote, Examples, Counter-examples, Conflicts)
3. Use clear, actionable language
4. Provide concrete examples from the project
5. Commit the individual tenet file

### 2. Referencing Tenets

*Rule*: Link requirements to tenets (bottom-up), not to CIPs or backlog.

```yaml
# In requirements/req0001_example.md
---
related_tenets: ["user-autonomy", "simplicity-of-use"]
---
```

**Hierarchy**:
```
Tenets (WHY) ──informs──> Requirements (WHAT) ──guides──> CIPs (HOW) ──breaks into──> Backlog (DO)
```

**Why?** Tenets are foundational principles. Requirements state what should be true based on those principles. CIPs describe how to achieve requirements. Backlog tasks execute CIPs.

### 3. Balancing Conflicting Tenets

*Rule*: When tenets conflict, explicitly document the trade-off and resolution.

```
✅ Document in CIP: "User Autonomy" vs "Simplicity" - prioritized Simplicity here
✅ Explain rationale: "For first-time users, simplicity reduces friction"
❌ Ignore the conflict
❌ Violate a tenet without acknowledging it
```

**Example from VibeSafe**:
- **Conflict**: "Simplicity at All Levels" vs "User Autonomy Over Prescription"
- **Resolution**: Provide sensible defaults while allowing configuration

### 4. Tenet File Naming

*Rule*: Use kebab-case IDs that are memorable and descriptive.

```
✅ user-autonomy.md
✅ simplicity-of-use.md  
✅ documentation-implementation-unified.md
❌ tenet1.md
❌ UserAutonomy.md
❌ my_tenet.md
```

### 5. Updating Tenets

*Rule*: Tenets should evolve, but changes should be intentional and documented.

```
✅ Update tenet content to reflect project learning
✅ Add examples based on real project decisions
✅ Refine wording for clarity
❌ Change fundamental meaning without discussion
❌ Delete tenets without understanding impact
```

**Process**:
1. Edit the individual tenet file
2. Document why the change was made (in commit message)
3. Consider impact on existing requirements/CIPs that reference this tenet
4. Commit the updated tenet

### 6. VibeSafe's Own Tenets

*Rule*: VibeSafe's tenets are examples and guidelines, not requirements for your project.

VibeSafe's tenets (in `tenets/vibesafe/`) demonstrate the tenet system and guide VibeSafe's own development. Your project should create its own tenets based on its unique principles and constraints.

```
✅ Read VibeSafe tenets for examples of format and depth
✅ Adapt principles that resonate with your project
✅ Create new tenets specific to your domain
❌ Copy all VibeSafe tenets without consideration
❌ Feel constrained by VibeSafe's specific principles
```

### 7. Tenets in Decision-Making

*Rule*: Use tenets actively in design discussions, not as post-hoc justification.

```
✅ CIP motivation: "This aligns with our 'user-autonomy' tenet by..."
✅ Design review: "Which tenets apply to this decision?"
✅ Requirement: "This requirement stems from 'simplicity-of-use' tenet"
❌ Retrofit tenet references after decisions are made
❌ Ignore tenets during actual design process
```

## Tenet Template Structure

Each tenet should include these sections:

1. **Title** - Clear, concise tenet title (e.g., `# Project Tenet: User Autonomy Over Prescription`)
2. **Description** - 1-2 paragraphs explaining the principle and how it guides decisions
3. **Quote** - Memorable phrase capturing the essence (formatted as italic quote)
4. **Examples** - 3+ concrete examples of applying this tenet successfully
5. **Counter-examples** - 3+ examples of violating this tenet
6. **Conflicts** - Potential conflicts with other tenets and how to resolve them

The template file (`templates/tenets/tenet_template.md`) contains placeholders for all these sections.

## Benefits of the Tenet System

- **Improved decision-making**: Clear principles guide design choices
- **Better communication**: Shared understanding of project values
- **Consistency**: Decisions align with project philosophy over time
- **Onboarding**: New contributors quickly understand project principles
- **Conflict resolution**: Framework for balancing competing concerns
- **Documentation**: Rationale for decisions is preserved

## Integration with VibeSafe Components

### Requirements (WHAT)
Requirements link to tenets via `related_tenets` field:
```yaml
related_tenets: ["user-autonomy", "simplicity-of-use"]
```

### CIPs (HOW)
CIPs reference tenets in motivation and design rationale:
```markdown
## Motivation
This change aligns with our "simplicity-of-use" tenet by reducing...
```

### Backlog (DO)
Backlog tasks indirectly benefit from tenets through requirements and CIPs.

## VibeSafe File Classification

### 🔧 VibeSafe System Files (Don't commit these unless updating VibeSafe itself)
- `templates/tenets/tenet_template.md` - Template file
- `templates/tenets/README.md` - System documentation
- `.cursor/rules/*`, `.github/copilot-instructions.md`, `CLAUDE.md`, `AGENTS.md` - AI assistant context files

### 📝 User Content (Always commit these)
- `tenets/[project]/*.md` - Your actual project tenets
- Individual tenet files following the template structure

**Tip**: Focus on committing your actual tenets (the principles you create) rather than VibeSafe infrastructure files.


---

