# Design Folder Structure Guide

Complete guide for the auto-generated design folder structure and where to place design assets, HTML prototypes, and Figma links.

---

## ðŸ“‚ Complete Folder Structure

For active feature-specific design, use `dev-doc/[feature-name]/design/`. Use `templates/design/master-ui-templates/` only for shared reusable baselines and legacy references.

```
dev-doc/[feature-name]/design/
â”‚
â”œâ”€â”€ master-ui-templates/                           â† Global fallback UI templates
â”‚   â”‚
â”‚   â”œâ”€â”€ README.md                                  â† How to use master templates
â”‚   â”‚
â”‚   â””â”€â”€ [template-name]/                           â† Reusable visual baseline
â”‚       â”‚
â”‚       â”œâ”€â”€ template-overview.md                   â† Scope, usage, notes
â”‚       â”œâ”€â”€ assets/                                â† Master reference images
â”‚       â”‚   â”œâ”€â”€ preview.png
â”‚       â”‚   â”œâ”€â”€ mockup.png
â”‚       â”‚   â”œâ”€â”€ state-default.png
â”‚       â”‚   â””â”€â”€ ... (other reference states)
â”‚       â”œâ”€â”€ prototype/                             â† Optional shared HTML UI shell
â”‚       â”‚   â”œâ”€â”€ index.html
â”‚       â”‚   â””â”€â”€ assets/
â”‚       â””â”€â”€ figma-link.txt                         â† Optional Figma source
â”‚
â”œâ”€â”€ [page-name]/                                    â† Page level
â”‚   â”‚
â”‚   â”œâ”€â”€ page-overview.md                            â† Page summary & nav
â”‚   â”‚   â”œâ”€â”€ Overview of all sections in page
â”‚   â”‚   â”œâ”€â”€ Links to section-overview.md files
â”‚   â”‚   â”œâ”€â”€ Navigation flow diagram
â”‚   â”‚   â””â”€â”€ Component usage across page
â”‚   â”‚
â”‚   â””â”€â”€ [section-name]/                             â† Section level
â”‚       â”‚
â”‚       â”œâ”€â”€ section-overview.md                    â† Section summary
â”‚       â”‚   â”œâ”€â”€ Overview of all subsections
â”‚       â”‚   â”œâ”€â”€ Links to design.md files
â”‚       â”‚   â”œâ”€â”€ Component inventory for section
â”‚       â”‚   â””â”€â”€ Interaction patterns
â”‚       â”‚
â”‚       â””â”€â”€ [sub-section-name]/                   â† Sub-section level
â”‚           â”‚
â”‚           â”œâ”€â”€ design.md                          â† MAIN SPEC FILE
â”‚           â”‚   â”œâ”€â”€ Visual objective
â”‚           â”‚   â”œâ”€â”€ Design system (colors, typography)
â”‚           â”‚   â”œâ”€â”€ Layout & spacing
â”‚           â”‚   â”œâ”€â”€ Components & states
â”‚           â”‚   â”œâ”€â”€ Interactions
â”‚           â”‚   â”œâ”€â”€ Responsive behavior
â”‚           â”‚   â”œâ”€â”€ Accessibility
â”‚           â”‚   â”œâ”€â”€ Developer notes
â”‚           â”‚   â””â”€â”€ Links to Figma (reference to figma-link.txt)
â”‚           â”‚
â”‚           â”œâ”€â”€ layout.md                          â† Layout specs
â”‚           â”‚   â”œâ”€â”€ Grid system
â”‚           â”‚   â”œâ”€â”€ Spacing values
â”‚           â”‚   â”œâ”€â”€ Breakpoints
â”‚           â”‚   â””â”€â”€ Responsive rules
â”‚           â”‚
â”‚           â”œâ”€â”€ components.md                      â† Component inventory
â”‚           â”‚   â”œâ”€â”€ Component names & types
â”‚           â”‚   â”œâ”€â”€ States & variants
â”‚           â”‚   â”œâ”€â”€ Component sizes
â”‚           â”‚   â””â”€â”€ Links to component docs
â”‚           â”‚
â”‚           â”œâ”€â”€ interactions.md                    â† Interaction specs
â”‚           â”‚   â”œâ”€â”€ Hover states
â”‚           â”‚   â”œâ”€â”€ Focus states
â”‚           â”‚   â”œâ”€â”€ Active/pressed states
â”‚           â”‚   â”œâ”€â”€ Disabled states
â”‚           â”‚   â”œâ”€â”€ Loading states
â”‚           â”‚   â”œâ”€â”€ Error states
â”‚           â”‚   â”œâ”€â”€ Success states
â”‚           â”‚   â””â”€â”€ Animations
â”‚           â”‚
â”‚           â”œâ”€â”€ assets/                            â† IMAGES & SCREENSHOTS
â”‚           â”‚   â”œâ”€â”€ wireframe.png                  (low-fidelity layout)
â”‚           â”‚   â”œâ”€â”€ mockup.png                     (high-fidelity design)
â”‚           â”‚   â”œâ”€â”€ state-default.png              (default state)
â”‚           â”‚   â”œâ”€â”€ state-hover.png                (hover state)
â”‚           â”‚   â”œâ”€â”€ state-focused.png              (focus state)
â”‚           â”‚   â”œâ”€â”€ state-active.png               (active state)
â”‚           â”‚   â”œâ”€â”€ state-disabled.png             (disabled state)
â”‚           â”‚   â”œâ”€â”€ state-error.png                (error state)
â”‚           â”‚   â”œâ”€â”€ state-loading.png              (loading state)
â”‚           â”‚   â”œâ”€â”€ state-success.png              (success state)
â”‚           â”‚   â”œâ”€â”€ state-empty.png                (empty state)
â”‚           â”‚   â””â”€â”€ ... (any other assets)
â”‚           â”‚
â”‚           â”œâ”€â”€ prototype/                         â† HTML UI SHELL REFERENCE
â”‚           â”‚   â”œâ”€â”€ index.html                     (UI/UX guide, not production code)
â”‚           â”‚   â””â”€â”€ assets/                        (local prototype-only assets)
â”‚           â”‚
â”‚           â””â”€â”€ figma-link.txt                    â† FIGMA URL REFERENCE
â”‚               â”œâ”€â”€ Figma file key
â”‚               â”œâ”€â”€ Node ID
â”‚               â”œâ”€â”€ URL to live Figma design
â”‚               â”œâ”€â”€ Designer name
â”‚               â””â”€â”€ Last updated date
â”‚
â””â”€â”€ [page-name]/                                    â† Another page
    â””â”€â”€ [section]/
        â””â”€â”€ [sub-section]/
            â””â”€â”€ ... (same structure)
```

---

## ðŸ”„ Auto-Generated by design-mapper

When you run `design-mapper` workflow, it automatically creates:

**Per Sub-section Folder:**
- âœ… `design.md` (empty template, ready for designer to fill)
- âœ… `layout.md` (empty template)
- âœ… `components.md` (empty template)
- âœ… `interactions.md` (empty template)
- âœ… `assets/` (empty folder, ready for images)
- âœ… `prototype/` (optional folder for HTML UI shell references)
- âœ… `figma-link.txt` (empty placeholder)

**Per Section Folder:**
- âœ… `section-overview.md` (summary of subsections)

**Per Page Folder:**
- âœ… `page-overview.md` (summary of sections)

**Result:** Designer opens folder and sees clean structure ready to use!

---

## Master UI Template Folder

**Location:** `templates/design/master-ui-templates/`

**Purpose:**
- Store reusable master UI visual baselines
- Act as fallback reference when page/section/sub-section design detail is incomplete
- Keep implementation moving without inventing ad-hoc UI direction

**When To Use Master Templates:**
1. `design.md` exists but visual detail is still too generic
2. `assets/mockup.png` is missing in the target sub-section
3. `figma-link.txt` is empty or not ready for development
4. Product wants temporary implementation using an approved baseline UI pattern

**Fallback Order:**
1. Use detailed files in `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/`
2. Use linked Figma design in target sub-section
3. Use target `prototype/index.html` when an HTML UI shell exists
4. If detail is missing, use HTML prototypes or images from `templates/design/master-ui-templates/`
5. If no visual source exists, generate first-pass design files or an HTML prototype from product artifacts and the closest template category
6. Record the chosen fallback source in the target `design.md`

**Recommended Master Template Categories:**
- `authentication/`
- `dashboard/`
- `tables/`
- `forms/`
- `settings/`
- `checkout/`
- `empty-states/`

**Important Rule:**
- Master templates are a fallback baseline, not a replacement for detailed page-specific design specs.
- Once detailed design becomes available, the page-specific design folder becomes the source of truth again.

---

## HTML Prototype Folder - UI Shell Reference

**Feature-specific location:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/prototype/index.html`

**Shared template location:** `templates/design/master-ui-templates/[template-name]/prototype/index.html`

**Purpose:**
- Store generated or hand-authored HTML UI shells when no production UI exists yet
- Preserve UI/UX direction as an isolated reference artifact
- Help frontend implementation without mixing prototype code into the target application

**Rules:**
- HTML prototypes are reference artifacts, not production source code.
- Store prototype-only images, CSS, or JS under the same `prototype/` folder unless they are already shared design assets.
- Do not place prototype HTML inside frontend/backend source code unless an approved development scope explicitly promotes it to production implementation.
- When a prototype is used for implementation, record the source path in the target `design.md`, implementation plan, or handoff note.

**Recommended structure:**

```text
dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/prototype/
  index.html
  assets/
  README.md
```

---

## ðŸ“¸ assets/ Folder - Designer Image Storage

**Location:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/assets/`

**Purpose:** 
- Designer stores visual design references here
- Provides implementation reference for frontend developer
- Repository of design decisions and mockups

**What Goes Here:**

### Wireframes (Low-Fidelity)
```
assets/wireframe.png
- Basic layout and structure
- Element placement
- No detailed styling
- Reference for page layout
```

### Mockups (High-Fidelity)
```
assets/mockup.png
- Full visual design
- All colors, typography, spacing
- Final visual appearance
- What frontend should implement
```

### State Screenshots
```
assets/state-[state-name].png

Examples:
- state-default.png         â†’ Normal appearance
- state-hover.png           â†’ On mouse hover
- state-focused.png         â†’ Keyboard focus
- state-active.png          â†’ Clicked/pressed
- state-disabled.png        â†’ Disabled state
- state-error.png           â†’ Error/validation state
- state-loading.png         â†’ Loading indicator
- state-success.png         â†’ Success feedback
- state-empty.png           â†’ Empty state (no data)
- state-expanded.png        â†’ Expanded view
- state-collapsed.png       â†’ Collapsed view
```

### Naming Convention
- **Format:** `state-[state-name].png`
- **Examples:** `state-error.png`, `state-loading.png`
- **File type:** PNG (recommended) or SVG
- **Size:** ~1200px width (2x display)

### Usage by Frontend Developer
```
Frontend dev workflow:
1. Open dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/
2. Look at assets/ folder for visual references
3. See mockup.png for final design
4. See state-*.png for all state variations
5. Implement exactly as shown in screenshots
6. Open figma-link.txt for live Figma design
```

---

## ðŸ”— figma-link.txt - Figma URL Reference

**Location:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/figma-link.txt`

**Purpose:**
- Store reference to live Figma design
- Link design â†’ code
- Keep design & implementation in sync

**What Goes Here:**

### Standard Format
```
Figma Design File
================
Project: [Project Name]
File: [File Name]
Page: [Page Name]

URL: https://www.figma.com/design/[fileKey]/[fileName]?node-id=[nodeId]

FileKey: [fileKey]
NodeId: [nodeId]

Designer: [Designer Name]
Last Updated: YYYY-MM-DD
Status: Draft / In Progress / Ready for Dev / Approved

Notes:
- [Optional implementation notes]
- [Known constraints or gotchas]
```

### Example
```
Figma Design File
================
Project: Authentication System
File: Auth-Flows-v2
Page: Login Form

URL: https://www.figma.com/design/ABC123DEF/Auth-Flows-v2?node-id=10:45

FileKey: ABC123DEF
NodeId: 10:45

Designer: Sarah Chen
Last Updated: 2026-04-07
Status: Ready for Development

Notes:
- Mobile uses 100% width layout
- Error animation is 200ms fade-in
- Button component from Design System v1.2
```

### What Designer Does
1. Create design in Figma
2. Get file key from URL: `figma.com/design/[ABC123DEF]/...`
3. Get node ID from URL: `node-id=[10:45]`
4. Fill in figma-link.txt with actual values
5. Share file with team

### What Frontend Dev Does
1. Open figma-link.txt
2. Click URL or copy file key + node ID
3. Open in Figma to see live design
4. Reference design while implementing

### What Claude Does (with MCP)
```
Tool: get_design_context
Input: FileKey, NodeId (from figma-link.txt)
Output:
  - Screenshot
  - Design specs
  - Component metadata
  - Code suggestions
```

---

## ðŸ“‹ Where to Put Figma Link - Options

### Option 1: figma-link.txt (Recommended)
**Primary location:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/figma-link.txt`

**Pros:**
- âœ… Dedicated file for Figma reference
- âœ… Easy to find
- âœ… Can be read by scripts/automation
- âœ… Consistent across all design specs

**Cons:**
- Separate file from design.md

**Usage:**
```
Designer:
1. Creates Figma design
2. Fills figma-link.txt with URL, file key, node ID
3. Saves figma-link.txt

Frontend Dev:
1. Reads figma-link.txt
2. Opens Figma URL
3. References live design
```

---

### Option 2: In design.md (Secondary)
**Location:** In `design.md` file under "Design Context" or "References" section

**Pros:**
- âœ… Everything in one file
- âœ… No extra files

**Cons:**
- âŒ Less structured
- âŒ Harder for automation to read
- âŒ May get lost in long document

**Usage:**
```markdown
# design.md

## ðŸ“ Design Context

### Figma Design
- Project: Authentication System
- File: Auth-Flows-v2
- URL: https://www.figma.com/design/ABC123DEF/Auth-Flows-v2?node-id=10:45
- Designer: Sarah Chen
- Last Updated: 2026-04-07

[Rest of design.md...]
```

---

### Option 3: Both (Hybrid - Recommended)
**Primary:** figma-link.txt  
**Secondary:** Reference in design.md

**Why:**
```
figma-link.txt
â””â”€ Machine-readable format for automation
â””â”€ Easy for scripts to parse

design.md
â””â”€ Human-readable summary
â””â”€ Context in document
```

**Example:**
```
File: dev-doc/authentication/design/login/form/

â”œâ”€â”€ design.md
â”‚   â”œâ”€â”€ Text: "See figma-link.txt for live Figma design"
â”‚   â””â”€â”€ Or: "Figma: https://figma.com/..."
â”‚
â””â”€â”€ figma-link.txt
    â”œâ”€â”€ FileKey: ABC123DEF
    â”œâ”€â”€ NodeId: 10:45
    â””â”€â”€ URL: https://www.figma.com/design/ABC123DEF/...
```

---

## âœ… Complete Workflow

### Step 1: design-mapper creates structure
```
Output:
dev-doc/[feature-name]/design/
â””â”€â”€ authentication/
    â””â”€â”€ login/
        â””â”€â”€ form/
            â”œâ”€â”€ design.md (empty template)
            â”œâ”€â”€ layout.md (empty template)
            â”œâ”€â”€ components.md (empty template)
            â”œâ”€â”€ interactions.md (empty template)
            â”œâ”€â”€ assets/ (empty folder) â† Ready for designer images
            â””â”€â”€ figma-link.txt (placeholder) â† Ready for Figma URL
```

### Step 2: Designer adds images to assets/
```
Designer:
1. Opens: dev-doc/authentication/design/login/form/assets/
2. Exports Figma design as mockup.png â†’ saves to assets/
3. Exports state screenshots â†’ saves as state-*.png
4. Uploads all images to assets/ folder

Result:
assets/
â”œâ”€â”€ mockup.png
â”œâ”€â”€ state-default.png
â”œâ”€â”€ state-error.png
â”œâ”€â”€ state-loading.png
â””â”€â”€ state-disabled.png
```

### Step 3: Designer fills design specs & Figma link
```
Designer:
1. Fills design.md with colors, fonts, spacing
2. Fills layout.md with responsive rules
3. Fills components.md with component list
4. Fills interactions.md with state specs
5. Fills figma-link.txt with Figma URL

Result:
- design.md = complete specification
- assets/ = visual references
- figma-link.txt = link to live design
- Frontend ready to implement!
```

### Step 4: Frontend implements based on specs
```
Frontend Dev:
1. Reads design.md for specs
2. Views mockup.png in assets/ for reference
3. Views state-*.png for all states
4. Opens figma-link.txt â†’ Figma design
5. Implements UI exactly as specified
6. Done!
```

---

## ðŸŽ¯ Best Practices

### For Designers
- âœ… Place ALL images in `assets/` folder
- âœ… Use naming convention: `state-[name].png`
- âœ… Fill `figma-link.txt` with actual Figma URL
- âœ… Keep design.md specs in sync with Figma
- âœ… Update Last Updated date in figma-link.txt

### For Frontend Developers
- âœ… Reference `assets/` folder first (quick visual check)
- âœ… Open `figma-link.txt` for live design
- âœ… Read `design.md` for exact specs (colors, fonts, spacing)
- âœ… Check `interactions.md` for all states
- âœ… Check `layout.md` for responsive rules

### For Project Managers
- âœ… Check `assets/` folder is populated
- âœ… Verify `figma-link.txt` has URL
- âœ… Ensure all state screenshots present
- âœ… Confirm specs are complete before dev starts

---

## ðŸ”„ Update Process

### When Design Changes

1. **Designer updates Figma design**
2. **Export new screenshots â†’ assets/update images**
3. **Update figma-link.txt** with latest URL if file moved
4. **Update design.md** with any changed specs
5. **Update Last Updated date**
6. **Notify frontend developers** of changes

### Version Control
```
git add dev-doc/[feature-name]/design/
git commit -m "Update login form design: changed button color to #0066FF"
```

Images & specs tracked in version control = full history!

---

## ðŸ’¾ Storage Summary

| Item | Location | Format | Purpose |
|------|----------|--------|---------|
| **Specs** | `design.md` | Markdown | Designer fills: colors, fonts, spacing |
| **Images** | `assets/` | PNG/SVG | Designer uploads: mockups, states |
| **Figma URL** | `figma-link.txt` | Text file | Designer stores: link to live design |
| **Layout Rules** | `layout.md` | Markdown | Designer fills: grid, spacing, responsive |
| **Components** | `components.md` | Markdown | Designer lists: all UI components |
| **Interactions** | `interactions.md` | Markdown | Designer specifies: states, animations |

---

## ðŸš€ Quick Checklist

**After design-mapper runs:**
- [ ] All page/section/sub-section folders created
- [ ] `assets/` folder exists (empty, ready)
- [ ] `figma-link.txt` exists (placeholder, ready)
- [ ] All .md template files exist (empty, ready)
- [ ] Folder structure is clean and navigable

**After designer adds content:**
- [ ] Images in `assets/` folder (mockup, wireframe, states)
- [ ] `figma-link.txt` filled with Figma URL
- [ ] `design.md` filled with visual specs
- [ ] `layout.md` filled with spacing rules
- [ ] `components.md` filled with component list
- [ ] `interactions.md` filled with interaction specs
- [ ] All states documented with screenshots

**Ready for frontend development:**
- [ ] All specs complete & filled
- [ ] All images in place
- [ ] Figma link accessible
- [ ] Frontend can implement without questions

---

## ðŸ“š Related Documentation

- `guardrails/design/DESIGN_ASSET_SUBMISSION.md` - How to submit assets
- `guardrails/design/FIGMA_MCP_INTEGRATION.md` - Auto-generate from Figma
- `guardrails/design/DESIGNER_QUICK_START.md` - For designers
- `.claude/skills/design-mapper/SKILL.md` - Workflow that creates this structure
- `templates/design_spec_template.md` - Template for design.md

---

**System Design Folder Structure Complete! ðŸŽ‰**

Designer can now:
- âœ… Find clean, organized folders ready to use
- âœ… See `assets/` folder ready for images
- âœ… See `figma-link.txt` ready for Figma URL
- âœ… See template files ready to fill

Frontend dev can:
- âœ… Find complete design specs
- âœ… See all design images in `assets/`
- âœ… Access live Figma design via `figma-link.txt`
- âœ… Implement without ambiguity

