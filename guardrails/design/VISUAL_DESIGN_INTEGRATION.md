# Visual Design Integration - Summary

**Date Created:** 2026-04-07  
**Status:** Design system documentation complete and ready for use

Compatibility note:
- This system is intended for shared use with Codex/GPT, Claude, and Gemini.
- Paths under `.claude/` may have mirrored equivalents under `.codex/`.

---

## âœ… What Has Been Created

A complete visual design process integrated into the startup-flow framework. This system ensures that:

1. âœ… Every feature has documented design specifications
2. âœ… Design folder structure is auto-generated from requirements
3. âœ… Frontend developers have clear, implementation-ready references
4. âœ… Design and code stay synchronized
5. âœ… Accessibility and responsive design are planned upfront

---

## ðŸ“ Auto-Generated Folder Structure

Every time `design-mapper` runs, it automatically creates:

```
dev-doc/[feature-name]/design/
â””â”€â”€ [page-name]/
    â””â”€â”€ [section]/
        â””â”€â”€ [sub-section]/
            â”œâ”€â”€ design.md              (template for specs)
            â”œâ”€â”€ layout.md              (template for spacing)
            â”œâ”€â”€ components.md          (template for component list)
            â”œâ”€â”€ interactions.md        (template for states)
            â”œâ”€â”€ assets/                â† EMPTY, ready for designer images
            â”‚   â”œâ”€â”€ mockup.png         (designer uploads here)
            â”‚   â”œâ”€â”€ wireframe.png      (designer uploads here)
            â”‚   â””â”€â”€ state-*.png        (designer uploads here)
            â””â”€â”€ figma-link.txt         â† PLACEHOLDER, ready for Figma URL
```

**Key Folders:**
- `assets/` - Designer stores design images (screenshots, mockups, state variations)
- `figma-link.txt` - Designer stores Figma design URL reference
- `master-ui-templates/` - Project-wide fallback reference images for shared UI baselines

See `guardrails/design/DESIGN_FOLDER_STRUCTURE.md` for complete guide on where to put what.

---

## ðŸ“ New Files & Folders Created

### Documentation
```
âœ… dev-doc/[feature-name]/design/README.md
   â†’ Complete guide to design artifacts folder

âœ… guardrails/design/DESIGN_PROCESS.md
   â†’ Step-by-step design process documentation
   â†’ Quality gates and checklists
   â†’ Troubleshooting guide

âœ… guardrails/design/VISUAL_DESIGN_INTEGRATION.md
   â†’ This file - summary of design system
```

### Templates
```
âœ… templates/design_spec_template.md
   â†’ Comprehensive template for every design spec file
   â†’ Includes visual, layout, components, interactions
   â†’ Ready to fill in by designers
```

### Workflows
```
âœ… workflows/ui_frontend_workflow.md
   â†’ Complete UI/Frontend development workflow
   â†’ Design â†’ Frontend â†’ QA â†’ Release
   â†’ Integration points and handoff checklists
```

### AI Skills
```
âœ… .claude/skills/design-mapper/SKILL.md
   â†’ Automated design folder structure generation
   â†’ Maps flows & requirements to design structure
   â†’ Creates template files automatically
```

### Example Design Structure
```
âœ… dev-doc/authentication/design/
   â”œâ”€â”€ page-overview.md
   â”‚   â†’ Authentication pages group overview
   â”‚   â†’ All subsections listed with descriptions
   â”‚
   â””â”€â”€ login/
       â”œâ”€â”€ form/
       â”‚   â””â”€â”€ design.md
       â”‚       â†’ Complete example design spec
       â”‚       â†’ Ready for designer to fill in values
       â”‚
       â””â”€â”€ error-states/
           â””â”€â”€ (structure ready for content)
```

### Updated Files
```
âœ… CLAUDE.md
   â†’ Added Design Rules section
   â†’ Added design requirements to Build Rules

âœ… workflows/solo_founder_end_to_end_workflow.md
   â†’ Inserted design-mapper phase in workflow
   â†’ Updated sequence: requirements â†’ flows â†’ design â†’ architecture â†’ build
```

---

## ðŸ”„ How The Design System Works

### 1. Requirements & Flows Phase (Already in CLAUDE.md)

**Input:** 
- User stories and features
- Requirements from `requirement-synthesizer`
- User flows from `flow-designer`

**Output:**
- `dev-doc/[feature-name]/prd.md` - Product requirements
- `artifacts/flows/` - User and system flows

---

### 2. Design Mapping Phase (NEW)

**Run:** `design-mapper` workflow

**What It Does:**
1. Analyzes user flows to extract all pages/screens
2. Groups pages into logical sections
3. Breaks sections into subsections (for complex pages)
4. Creates folder structure: `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/`
5. Generates template files in each folder
6. Creates overview documents for each level

**Output:** Design folder structure ready for visual design

**Example Output:**
```
dev-doc/[feature-name]/design/
â”œâ”€â”€ authentication/
â”‚   â”œâ”€â”€ authentication-overview.md
â”‚   â”œâ”€â”€ login/
â”‚   â”‚   â”œâ”€â”€ page-overview.md
â”‚   â”‚   â”œâ”€â”€ form/
â”‚   â”‚   â”‚   â”œâ”€â”€ design.md (template)
â”‚   â”‚   â”‚   â”œâ”€â”€ layout.md (template)
â”‚   â”‚   â”‚   â”œâ”€â”€ components.md (template)
â”‚   â”‚   â”‚   â”œâ”€â”€ interactions.md (template)
â”‚   â”‚   â”‚   â”œâ”€â”€ assets/ (folder)
â”‚   â”‚   â”‚   â””â”€â”€ figma-link.txt
â”‚   â”‚   â””â”€â”€ error-states/
â”‚   â”‚       â””â”€â”€ ...
â”‚   â””â”€â”€ signup/
â”‚       â””â”€â”€ ...
â”‚
â”œâ”€â”€ dashboard/
â”‚   â””â”€â”€ ...
â”‚
â””â”€â”€ settings/
    â””â”€â”€ ...
```

---

### 3. Visual Design Phase (NEW)

**Designer Action:**

1. **Review** design folder structure
2. **Fill In** design specs:
   - `design.md` - Visual details, colors, typography
   - `layout.md` - Spacing, grid, responsive rules
   - `components.md` - Component inventory and states
   - `interactions.md` - Interaction and animation specs
3. **Create** Figma designs
4. **Link** Figma designs to design specs
5. **Get Approval** from product owner

**Output:** Complete design specs + Figma designs

**Fallback Support:**
- If a target page/sub-section does not yet have sufficient visual detail, use the closest approved reference from `templates/design/master-ui-templates/`.
- This keeps implementation and QA moving without inventing a new UI direction.
- The chosen template must be noted back into the target `design.md`.
- If no visual source exists at all, generate a first-pass UI spec from PRD, flows, project context, business context, and the nearest master template category, then store the generated result back into the target design folder.

---

### 4. Architecture Phase

**Run:** `solution-architect` workflow

**What It Does:**
- Technical architecture decisions
- Component library planning
- Tech stack selection
- API design
- Database schema

**Cross-Check:**
- Verify design specs align with architecture
- Plan component library based on design specs

---

### 5. Implementation Phase

**Frontend Developer Action:**

1. **Review** design specs in `dev-doc/[feature-name]/design/`
2. **Open** Figma link for visual reference
3. **Implement** UI components
4. **Follow** design specs exactly:
   - Colors (from specs)
   - Typography (from specs)
   - Spacing (from specs)
   - All component states
   - Responsive behavior
   - Accessibility requirements
5. **Reference** component library (if exists)

**Source of Truth:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/design.md`

**Fallback Source When Detail Is Missing:** `templates/design/master-ui-templates/[template-name]/assets/mockup.png`

**Last-Resort Source When No UI Exists:** product artifacts + flow artifacts + master template category selection

---

## ðŸ“‹ Folder Structure Template

For every page/section/subsection, this structure is created:

```
[sub-section]/
â”œâ”€â”€ design.md
â”‚   Visual specification
â”‚   - Colors, typography, spacing (actual values)
â”‚   - Component definitions
â”‚   - All states & interactions
â”‚   - Accessibility requirements
â”‚   - Responsive rules
â”‚   - Developer implementation notes
â”‚
â”œâ”€â”€ layout.md
â”‚   Spacing & grid rules
â”‚   - Grid system definition
â”‚   - Padding, margin, gap values
â”‚   - Breakpoints & responsive changes
â”‚   - Safe areas
â”‚
â”œâ”€â”€ components.md
â”‚   Component inventory
â”‚   - List of all components used
â”‚   - States and variants
â”‚   - Links to component library docs
â”‚
â”œâ”€â”€ interactions.md
â”‚   Interaction specifications
â”‚   - Hover, focus, active, disabled states
â”‚   - Loading & error states
â”‚   - Form validation
â”‚   - Animations & transitions
â”‚   - Keyboard navigation
â”‚
â”œâ”€â”€ assets/
â”‚   Visual references
â”‚   â”œâ”€â”€ wireframe.png
â”‚   â”œâ”€â”€ mockup.png
â”‚   â”œâ”€â”€ state-default.png
â”‚   â”œâ”€â”€ state-error.png
â”‚   â””â”€â”€ ... (all states)
â”‚
â””â”€â”€ figma-link.txt
    Link to Figma design file
```

---

## ðŸŽ¯ Design Spec Completeness Checklist

When designer finishes filling a `design.md`, it should have:

### Visual Details
- [ ] Colors defined (hex codes)
- [ ] Typography defined (font, size, weight, line-height)
- [ ] Spacing values (padding, margin, gap)
- [ ] Border radius and shadows
- [ ] Component dimensions

### Component Inventory
- [ ] All components listed
- [ ] States documented (default, hover, active, disabled, loading, error)
- [ ] Variants listed (sizes, colors, styles)
- [ ] Links to component library

### Interactions
- [ ] Hover states specified
- [ ] Focus states specified
- [ ] Active/pressed states specified
- [ ] Disabled states specified
- [ ] Loading states specified
- [ ] Error states specified
- [ ] Success states specified
- [ ] Animations described

### Responsiveness
- [ ] Mobile rules (< 768px)
- [ ] Tablet rules (768px - 1024px)
- [ ] Desktop rules (> 1024px)
- [ ] Breakpoints specified
- [ ] Layout changes documented

### Accessibility
- [ ] WCAG 2.1 AA compliance
- [ ] Color contrast ratios specified
- [ ] Keyboard navigation documented
- [ ] ARIA labels specified
- [ ] Focus indicators defined
- [ ] Screen reader considerations noted

### Developer Notes
- [ ] Implementation approach suggested
- [ ] CSS framework specified
- [ ] Design token mapping
- [ ] Browser support documented
- [ ] Known gotchas noted

---

## ðŸ”„ Integration with Existing Workflows

### With flow-designer
- **Input for design-mapper:** User flows identify all pages
- **Output for flow-designer:** Design specs validate flow completeness

### With requirement-synthesizer
- **Input for design-mapper:** Features and user stories
- **Output for synthesizer:** Design confirms all requirements have UI

### With solution-architect
- **Cross-check:** Design specs align with technical architecture
- **Input:** Design component inventory informs component library planning

### With sprint-orchestrator
- **Input:** Design specs help break work into granular tasks
- **Output:** Design tasks become frontend implementation stories

### With frontend-builder
- **Input:** Design specs are implementation reference
- **Output:** Implemented components validate design

### With qa-runner
- **Input:** Design specs define test cases
- **Output:** QA verifies implementation matches design

---

## ðŸ“Š Design System Benefits

### For Product Owner
- âœ… Visual sign-off before expensive frontend development
- âœ… Design consistency across product
- âœ… Clear requirements for developers
- âœ… Accessibility planned upfront

### For Designer
- âœ… Structured process for design work
- âœ… Clear handoff to developers
- âœ… Specs become living documentation
- âœ… Easy to update specs as requirements change

### For Frontend Developer
- âœ… Clear, specific design reference
- âœ… No ambiguity about colors, spacing, typography
- âœ… All states documented upfront
- âœ… Accessibility requirements clear
- âœ… Responsive behavior specified
- âœ… No back-and-forth with designer for clarifications

### For QA
- âœ… Clear design specs to test against
- âœ… All states documented in specs
- âœ… Accessibility requirements explicit
- âœ… Visual regression testing easier
- âœ… Responsive testing documented

### For Business
- âœ… Design validated before build (cost savings)
- âœ… Consistent, professional product
- âœ… Accessibility compliance
- âœ… Faster development (clear specs = less rework)

---

## ðŸš€ How To Use This System

### For a New Project

1. **Run `founder-interviewer`** - Clarify problem and scope
2. **Run `requirement-synthesizer`** - Create BRD/PRD
3. **Run `flow-designer`** - Create user/system flows
4. **Run `design-mapper`** - Generate design folder structure
5. **Designer Work:**
   - Review design folder structure
   - Fill in `design.md` files with visual specs
   - Create Figma designs
   - Get approval
6. **Run `solution-architect`** - Technical architecture
7. **Frontend Dev:** Implement based on design specs
8. **QA:** Test against design specs
9. **Release:** Deploy and monitor

### For Updating an Existing Design

1. **Requirement changes** â†’ Update PRD and flows
2. **Designer updates** â†’ Modify design specs in `dev-doc/[feature-name]/design/`
3. **Notify frontend devs** â†’ They update implementation
4. **QA verifies** â†’ Re-test updated features
5. **Update decision log** â†’ Document what changed and why

### For New Features in Existing Product

1. **Requirement defined** â†’ Create PRD for feature
2. **Flows designed** â†’ Create feature flow
3. **design-mapper extracts** â†’ New pages/sections identified
4. **Designer fills specs** â†’ Add design specs for new pages
5. **Frontend dev implements** â†’ Implement new UI
6. **Ship with confidence** â†’ Design is already validated

---

## ðŸ“ Example: Login Feature

Let's walk through how the design system works:

### Step 1: Requirements (requirement-synthesizer)
```
PRD created: dev-doc/authentication/prd.md
- Feature: User login
- Users: Existing account holders
- Success criteria: Can sign in with email/password
```

### Step 2: Flows (flow-designer)
```
Flow created: artifacts/flows/authentication_flow.md
- Pages identified: Login, Error states, Success
- Interactions: Form submission, validation, error display
- States: Default, Loading, Success, Error
```

### Step 3: Design Mapping (design-mapper)
```
Generated: dev-doc/authentication/design/login/
â”œâ”€â”€ form/
â”‚   â”œâ”€â”€ design.md (template)
â”‚   â”œâ”€â”€ layout.md
â”‚   â”œâ”€â”€ components.md
â”‚   â”œâ”€â”€ interactions.md
â”‚   â””â”€â”€ assets/
â”œâ”€â”€ error-states/
â”‚   â””â”€â”€ ...
â””â”€â”€ page-overview.md
```

### Step 4: Visual Design (Designer)
```
Designer fills:
- design.md: Colors (#0066FF primary), fonts (Inter 16px body)
- layout.md: Spacing (16px padding, 12px gap between inputs)
- components.md: Button (primary, secondary), Input, Link
- interactions.md: Hover (lighter blue), Loading (spinner)
- assets/: Screenshots of all states
- figma-link.txt: https://figma.com/... (link to design)
```

### Step 5: Frontend Implementation
```
Frontend dev:
- Reads dev-doc/authentication/design/login/form/design.md
- Opens Figma link for visual reference
- Creates React component with:
  - #0066FF for primary color
  - Inter 16px for body text
  - 16px padding, 12px gaps
  - All states: default, hover, loading, error
  - Mobile responsive at 768px breakpoint
  - ARIA labels and focus states
```

### Step 6: QA Testing
```
QA verifies:
- Colors match design.md (#0066FF)
- Spacing matches layout.md (16px padding)
- All states from interactions.md implemented
- Responsive behavior matches layout.md
- Accessibility requirements from design.md met
- Desktop, tablet, mobile all working
```

---

## ðŸ› ï¸ Tools & Technology

### Recommended Design Tools
- **Figma** (recommended) - Easy designer-to-code handoff
- **Sketch** - Alternative for macOS teams
- **Penpot** - Open-source alternative

### Recommended Frontend Tech
- **CSS Framework:** Tailwind CSS (aligns well with design tokens)
- **Component Library:** Storybook (document components)
- **Design Tokens:** CSS variables or Tailwind config
- **Form Validation:** react-hook-form or Formik
- **Icons:** Feather or Material Design Icons

### Figma Integration
- Use Figma DevMode to inspect designs
- Set up Figma + Code Connect for component linking
- Use design tokens in Figma that map to code

---

## ðŸ“Š Metrics & Success Indicators

### Design Phase Success
- [ ] 100% of flows have design specs created
- [ ] All component states documented
- [ ] All specs include specific values (colors, fonts, spacing)
- [ ] Figma designs created and linked
- [ ] Design approved by product owner
- [ ] Zero ambiguity in specs (developers can implement without asking)

### Implementation Phase Success
- [ ] Frontend matches design specs visually
- [ ] All documented states implemented
- [ ] Responsive behavior verified at breakpoints
- [ ] Accessibility requirements met
- [ ] No deviations from specs without documentation
- [ ] Zero back-and-forth with designer

### Release Phase Success
- [ ] Visual QA passes (matches design)
- [ ] No accessibility issues
- [ ] Responsive on all breakpoints
- [ ] Performance acceptable
- [ ] Design specs updated if any approved changes made

---

## ðŸš¨ Common Issues & Solutions

### Issue: Design specs are too vague
**Solution:** Designer adds specific values, screenshots, or Figma links

### Issue: Designers don't fill in all template sections
**Solution:** Use the checklist in DESIGN_PROCESS.md to track completeness

### Issue: Frontend can't match design exactly
**Solution:** Document as architectural decision in DECISION_LOG.md

### Issue: Design changes after frontend starts
**Solution:** Use design-mapper to regenerate structure. Follow design update flow.

### Issue: Design specs don't match actual Figma
**Solution:** Keep specs and Figma in sync. Update both when changes made.

---

## ðŸŽ“ Next Steps

To start using this design system:

1. **Read** `guardrails/design/DESIGN_PROCESS.md` - Full process guide
2. **Read** `workflows/ui_frontend_workflow.md` - UI development workflow
3. **Review** `templates/design_spec_template.md` - Template to use
4. **Check** `dev-doc/authentication/design/` - Example structure
5. **Run** `design-mapper` on your flows when you have them
6. **Designer starts** filling specs using template
7. **Frontend dev implements** using specs as reference

---

## ðŸ“š Related Documentation

- `CLAUDE.md` - Design Rules section
- `guardrails/design/DESIGN_FOLDER_STRUCTURE.md` - Complete folder structure guide (where to put assets & Figma links)
- `guardrails/design/DESIGN_PROCESS.md` - Detailed design process
- `guardrails/design/DESIGN_ASSET_SUBMISSION.md` - How to submit design assets (screenshots, images, Figma links)
- `guardrails/design/FIGMA_MCP_INTEGRATION.md` - How to use Figma MCP for auto-generation
- `guardrails/design/DESIGN_COMPLETER_GUIDE.md` - Complete incomplete designs from images âœ¨ NEW
- `workflows/ui_frontend_workflow.md` - UI/Frontend workflow
- `workflows/solo_founder_end_to_end_workflow.md` - Full workflow (includes design phase)
- `templates/design_spec_template.md` - Design specification template
- `.claude/skills/design-mapper/SKILL.md` - Design mapper workflow (creates folder structure with assets/)
- `.claude/skills/design-completer/SKILL.md` - Design completer workflow (complete incomplete designs) âœ¨ NEW
- `dev-doc/[feature-name]/design/` - All design specifications

---

## âœ¨ Summary

You now have a complete, integrated visual design system that:

âœ… Automatically generates design folder structure from requirements  
âœ… Provides templates for every design specification  
âœ… Creates clear handoff from designer to frontend dev  
âœ… Ensures design consistency and accessibility  
âœ… Integrates with existing workflows  
âœ… Provides quality gates and checklists  
âœ… Makes design decisions permanent (in decision log)  
âœ… Keeps design and code synchronized  

**Ready to use on your next project!**

