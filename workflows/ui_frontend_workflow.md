# UI/Frontend Development Workflow

For products with user-facing interfaces (web, mobile, desktop).

---

## Full Workflow: From Requirement to Deployed UI

```
1. REQUIREMENTS & FLOWS (existing)
   â†“ (prerequisite: requirement-synthesizer + flow-designer completed)
   
2. DESIGN ANALYSIS
   â†’ Run: design-mapper
   â†’ Output: Design folder structure + specs in dev-doc/[feature-name]/design/
   â†“
   
3. VISUAL DESIGN
   â†’ Designer reviews design specs
   â†’ Designer creates/uploads design images/Figma
   â†’ Designer uploads to assets/ folder (screenshots, mockups)
   â†’ Designer adds Figma link to figma-link.txt
   â†“

4. [OPTIONAL] DESIGN COMPLETION (if design incomplete)
   â†’ IF: Only 1-2 images provided (missing states, specs)
   â†’ Run: design-completer
   â†’ Process: Extract patterns, generate missing specs
   â†’ Output: Complete design.md, layout.md, components.md, interactions.md
   â†“
   
5. ARCHITECTURE
   â†’ Run: solution-architect
   â†’ Define: tech stack, component library, state management, APIs
   â†“
   
6. SPRINT PLANNING
   â†’ Run: sprint-orchestrator
   â†’ Break into frontend-ready tasks
   â†“
   
7. FRONTEND IMPLEMENTATION
   â†’ Run: frontend-builder (subagent)
   â†’ Reference: dev-doc/[feature-name]/design/
   â†’ Reference: assets/ folder (design images)
   â†’ Reference: figma-link.txt (live Figma design)
   â†’ Follow: design specs exactly
   â†“
   
8. COMPONENT TESTING
   â†’ Unit tests for components
   â†’ Visual regression tests (against design images)
   â†’ Accessibility tests (check design specs requirements)
   â†’ Functional automation default: Playwright
   â†“
   
9. INTEGRATION TESTING
   â†’ QA against design specs
   â†’ User flow testing
   â†’ Cross-browser testing
   â†’ Browser automation via Playwright E2E
   â†“
   
10. REVIEW & REFINEMENT
    â†’ Run: code-reviewer
    â†’ Visual review against design specs + images
    â†’ Performance review
    â†“
    
11. RELEASE PREPARATION
    â†’ Run: release-prep
    â†’ Smoke testing
    â†’ Performance baseline
    â†“
    
12. DEPLOYMENT
    â†’ Deploy to staging/production
    â†’ Monitor for issues
    â†“
    
13. LEARNINGS
    â†’ Run: improvement-planner
    â†’ Document what worked/failed
    â†’ Update design specs if needed
    â†’ Consider: Apply design patterns to other pages
```

---

## Key Integration Points

### Design â†’ Frontend
- **Source of Truth:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/`
- **What Developers Use:**
  - `design.md` - Visual specs, colors, typography
  - `layout.md` - Spacing, grid, responsive rules
  - `components.md` - Component inventory and states
  - `interactions.md` - User interactions, validations, error handling
  - `assets/` - Wireframes, mockups, screenshots
  - `figma-link.txt` - Link to live Figma design

### Design Specs Must Include
- [ ] Visual hierarchy and layout
- [ ] Color palette and typography
- [ ] Component states (default, hover, active, disabled, loading, error)
- [ ] Responsive behavior (mobile, tablet, desktop)
- [ ] Accessibility requirements
- [ ] Interaction patterns and animations
- [ ] Form validation and error messages
- [ ] Loading and empty states
- [ ] Developer implementation notes

### Frontend Must Follow
- [ ] Implement exactly as specified in design specs
- [ ] Use design tokens, not hardcoded values
- [ ] Implement all documented states
- [ ] Meet accessibility requirements (WCAG 2.1 AA)
- [ ] Match responsive behavior
- [ ] Document any deviations as architectural decisions

---

## Design Folder Structure Reference

```
dev-doc/[feature-name]/design/
â”œâ”€â”€ authentication/
â”‚   â”œâ”€â”€ login/
â”‚   â”‚   â”œâ”€â”€ form/
â”‚   â”‚   â”‚   â”œâ”€â”€ design.md
â”‚   â”‚   â”‚   â”œâ”€â”€ layout.md
â”‚   â”‚   â”‚   â”œâ”€â”€ components.md
â”‚   â”‚   â”‚   â”œâ”€â”€ interactions.md
â”‚   â”‚   â”‚   â””â”€â”€ assets/
â”‚   â”‚   â”œâ”€â”€ error-states/
â”‚   â”‚   â””â”€â”€ page-overview.md
â”‚   â””â”€â”€ signup/
â”‚       â””â”€â”€ ...
â”‚
â”œâ”€â”€ dashboard/
â”‚   â”œâ”€â”€ header/
â”‚   â”œâ”€â”€ sidebar/
â”‚   â”œâ”€â”€ main-content/
â”‚   â””â”€â”€ page-overview.md
â”‚
â””â”€â”€ settings/
    â””â”€â”€ ...
```

**Key Benefit:** Frontend developers have a complete, structured, implementation-ready reference for every page and section.

---

## Quality Gate: Design Spec Review

Before frontend implementation starts:

- [ ] All pages/sections have design specs
- [ ] Specs include visual design details
- [ ] Component inventory is complete
- [ ] Interaction states are documented
- [ ] Responsive behavior is clear
- [ ] Accessibility requirements are met
- [ ] Design has been approved by product owner

---

## Quality Gate: Design Compliance Review

Before deployment:

- [ ] Frontend matches design specs visually
- [ ] All documented states implemented
- [ ] Responsive behavior verified on mobile/tablet/desktop
- [ ] Accessibility requirements met (keyboard nav, ARIA, contrast)
- [ ] Animations/transitions match design specs
- [ ] Forms work as specified (validation, error messages)
- [ ] Design specs updated with any approved changes

---

## Handoff From Designer to Frontend Developer

### Designer Provides
```
dev-doc/[feature-name]/design/
â”œâ”€â”€ [page-name]/
â”‚   â””â”€â”€ [section]/
â”‚       â”œâ”€â”€ design.md (filled with visual details)
â”‚       â”œâ”€â”€ layout.md (filled with spacing rules)
â”‚       â”œâ”€â”€ components.md (filled with component variants)
â”‚       â”œâ”€â”€ interactions.md (filled with state specs)
â”‚       â””â”€â”€ assets/
â”‚           â”œâ”€â”€ mockup.png
â”‚           â”œâ”€â”€ state-default.png
â”‚           â”œâ”€â”€ state-error.png
â”‚           â””â”€â”€ ... (all states documented)
â””â”€â”€ figma-link.txt (link to Figma design)
```

### Frontend Developer Takes
- Clones/downloads design folder
- Reviews all specs
- Implements components exactly as specified
- References Figma for visual details
- Updates specs with approved changes

---

## Common Page Types & Sections

### Authentication Pages
- `login/` - Form, error states, forgot password link
- `signup/` - Form, validation, terms, success
- `password-reset/` - Email entry, link sent, password reset form, success
- `email-verification/` - Code entry, resend button, verification states

### Dashboard Pages
- `header/` - Logo, search, notifications, user menu
- `sidebar/` - Navigation, collapse/expand, active states
- `main-content/` - Cards, tables, charts, empty states
- `footer/` - Links, copyright, settings links

### Settings Pages
- `profile/` - Avatar, name, bio, save button
- `account/` - Email, password, two-factor, privacy
- `preferences/` - Theme, language, notifications
- `billing/` - Payment methods, invoice history, upgrade

### Error Pages
- `404-not-found/` - Illustration, message, home link
- `500-error/` - Error message, retry button, support link
- `permission-denied/` - Message, back link, contact support

### Form Components
- Text inputs, passwords, emails
- Selects, multi-select, autocomplete
- Checkboxes, radio buttons, toggles
- Textareas, rich text editors
- Date pickers, time pickers
- File uploads

---

## Tips for Designers

1. **Be Specific:** Include colors (hex), font sizes (px), spacing (px)
2. **Document States:** Show default, hover, active, disabled, error, loading
3. **Mobile First:** Design mobile at 375px width first
4. **Responsive Rules:** Specify breakpoints and layout changes
5. **Accessibility:** Include ARIA labels, keyboard navigation order, focus states
6. **Interactions:** Describe animations, transitions, validation feedback
7. **Developer Notes:** Include implementation hints, gotchas, browser support

---

## Tips for Frontend Developers

1. **Follow the Specs:** Match design exactly, don't "improve"
2. **Use Tokens:** Reference design system tokens, not hex colors
3. **Test Responsiveness:** Use design breakpoints as defined
4. **Keyboard Nav:** Implement proper tab order, focus states
5. **Accessibility:** Implement ARIA labels, semantic HTML
6. **Verify States:** Test all documented states before merging
7. **Ask Questions:** If spec is ambiguous, ask before implementing

---

## Linking Design to Figma

In each design spec folder, create `figma-link.txt`:

```
Figma Design File
================
Project: [Project Name]
File: [File Name]
Node/Page: [Page Name]

URL: https://www.figma.com/design/[fileKey]/[fileName]?node-id=[nodeId]

Designer: [Name]
Last Updated: YYYY-MM-DD
```

Frontend developers can click this link to see live design in Figma.

---

## Design System Integration

### Before Frontend Starts
- [ ] Design system/component library is defined
- [ ] Design tokens are available (colors, typography, spacing)
- [ ] Component documentation exists
- [ ] Figma library is set up with design system components

### During Frontend Development
- [ ] Use design system components
- [ ] Use design tokens for values
- [ ] Don't create new components if they exist in design system
- [ ] Document component props and usage

### Post-Development
- [ ] Publish new components to design system
- [ ] Update component documentation
- [ ] Sync Figma library with component code
- [ ] Use Code Connect for design-code links

---

## Related Workflows

- `solo_founder_end_to_end_workflow.md` - Full workflow
- `flow-designer` - Input: user flows
- `design-mapper` - Generates design folder structure
- `solution-architect` - Technical decisions
- `sprint-orchestrator` - Task breakdown
- `frontend-builder` - Implements UI
- `code-reviewer` - Code quality
- `qa-runner` - Testing

