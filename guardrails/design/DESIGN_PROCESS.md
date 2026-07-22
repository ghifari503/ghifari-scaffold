# Design Process Documentation

## Overview

The design process integrates visual design into the standard development workflow. It ensures that:
- Every feature has documented design specifications
- Frontend developers have clear references for implementation
- Design and code stay synchronized
- Accessibility and responsive design are planned upfront

---

## Process Flow

### Phase 1: Requirements & Flows (Prerequisite)

**Status Check:**
- âœ… `requirement-synthesizer` completed (feature requirements documented)
- âœ… `flow-designer` completed (user/system flows created)
- âŒ NOT YET: Technical architecture or frontend implementation

**Inputs Available:**
- `dev-doc/[feature-name]/prd.md` - Product requirements
- `artifacts/flows/` - User flows, system flows
- Component inventory from flow analysis

---

### Phase 2: Design Mapping

**Task:** Run `design-mapper` workflow

**Input:**
- User flows from `flow-designer`
- Feature requirements from PRD
- Screen/page specifications

**Processing:**
1. Extract all pages/screens from flows
2. Identify page groups and hierarchy
3. Break pages into sections and subsections
4. Create folder structure: `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/`
5. Generate template files in each folder
6. Map components to pages

**Output Folder Structure:**
```
dev-doc/[feature-name]/design/
â”œâ”€â”€ [page-name]/
â”‚   â”œâ”€â”€ page-overview.md
â”‚   â””â”€â”€ [section-name]/
â”‚       â”œâ”€â”€ section-overview.md
â”‚       â””â”€â”€ [sub-section-name]/
â”‚           â”œâ”€â”€ design.md (visual spec template)
â”‚           â”œâ”€â”€ layout.md (spacing/grid template)
â”‚           â”œâ”€â”€ components.md (component inventory)
â”‚           â”œâ”€â”€ interactions.md (state spec template)
â”‚           â”œâ”€â”€ assets/ (folder for images)
â”‚           â””â”€â”€ figma-link.txt (placeholder)
```

**Success Criteria:**
- [ ] All pages from flows have folders
- [ ] All sections within pages identified
- [ ] All subsections for complex sections identified
- [ ] Template files created and ready for design input

---

### Phase 3: Visual Design

**Task:** Designer creates visual designs

**Input:**
- Design specs from `dev-doc/[feature-name]/design/`
- Approved flows and requirements
- Brand guidelines and design system

**Designer Activities:**
1. Review design folder structure
2. Review template files and fill in visual details
3. Create Figma designs (or other design tool)
4. Link Figma designs to design spec folders
5. Document colors, typography, spacing, components
6. Document all component states
7. Specify responsive behavior
8. Include accessibility requirements
9. Document interactions and animations

**Output:**
```

**Fallback Rule For Missing Detail:**
- If a page-specific design folder is incomplete, the team may temporarily use `templates/design/master-ui-templates/` as the visual baseline.
- The selected master template must be recorded in the target `design.md`.
- As soon as page-specific design assets are ready, they replace the fallback as the source of truth.

**No UI Source At All:**
- If `design.md`, target `assets/`, target `figma-link.txt`, and usable master template images are all unavailable, the system must create a first-pass UI spec from non-UI product artifacts.
- Required references for this recovery mode:
  - `dev-doc/[feature-name]/prd.md`
  - `artifacts/flows/`
  - `artifacts/context/PROJECT_CONTEXT.md`
  - `artifacts/context/BUSINESS_CONTEXT.md`
  - `artifacts/context/PRODUCT_SCOPE.md`
- The closest logical master template category should still be chosen as a structural pattern, even if it has no image yet.
- Output must be written into the target design folder so the next session/runtime can continue from an explicit artifact instead of rethinking the UI from zero.
design/[page]/[section]/[sub-section]/
â”œâ”€â”€ design.md (FILLED with visual details)
â”œâ”€â”€ layout.md (FILLED with spacing rules)
â”œâ”€â”€ components.md (FILLED with component inventory)
â”œâ”€â”€ interactions.md (FILLED with interaction specs)
â”œâ”€â”€ assets/
â”‚   â”œâ”€â”€ mockup.png
â”‚   â”œâ”€â”€ wireframe.png
â”‚   â”œâ”€â”€ state-default.png
â”‚   â”œâ”€â”€ state-error.png
â”‚   â””â”€â”€ ... (all states)
â”œâ”€â”€ figma-link.txt (FILLED with Figma URL)
â””â”€â”€ page-overview.md or section-overview.md
```

**Review & Approval:**
- [ ] Visual design approved by product owner
- [ ] All states documented
- [ ] Responsive behavior specified
- [ ] Accessibility requirements included
- [ ] Component library mapped
- [ ] Interaction specs clear
- [ ] Figma links added

---

### Phase 4: Architecture & Planning

**Task:** Technical decisions and sprint planning

**Parallel to Design Phase:**
- Run `solution-architect` (technical architecture)
- Run `sprint-orchestrator` (break into tasks)

**Cross-Check:**
- [ ] Architecture aligns with design specs
- [ ] Technology choices support responsive design
- [ ] Component library plan aligns with design component inventory

---

### Phase 5: Frontend Implementation

**Task:** Frontend developers implement UI based on design specs

**Reference Material:**
- `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/` (complete spec)
- Figma link for visual reference
- `templates/design/master-ui-templates/` only if target detail is incomplete
- Design system components

**Implementation Requirements:**
- [ ] Follow design specs exactly
- [ ] Implement all documented states
- [ ] Use design tokens/variables
- [ ] Responsive behavior matches specs
- [ ] Accessibility requirements met
- [ ] Keyboard navigation works
- [ ] All interactions implemented

**Deviations:**
If design specs can't be implemented due to technical constraints:
- Discuss with designer
- Document decision in `artifacts/architecture/DECISION_LOG.md`
- Update design spec if spec was incorrect
- Do NOT deviate without documentation

**Missing Design Detail Handling:**
If implementation is blocked because UI detail is missing:
1. Check the target sub-section folder for `design.md`, `assets/mockup.png`, and `figma-link.txt`
2. If still incomplete, choose the closest approved folder in `templates/design/master-ui-templates/`
3. Record the fallback source in the target `design.md`
4. Continue implementation using the fallback reference until detailed design is supplied

**Zero-Source Handling:**
If no visual source exists at all:
1. Read PRD, flows, project context, business context, and product scope
2. Infer the page goal, hierarchy, required states, and likely component set
3. Select the nearest master template category as a structural baseline
4. Generate first-pass `design.md`, `layout.md`, `components.md`, and `interactions.md`
5. Mark the target `design.md` with `Design Source Mode: Generated From Product Artifacts`
6. Use that generated artifact as the temporary source of truth until designer review

---

### Phase 6: Testing & Review

**Design Compliance Testing:**
- [ ] Visual comparison against design specs
- [ ] All states implemented
- [ ] Responsive breakpoints verified
- [ ] Accessibility requirements met
- [ ] Animations match specs
- [ ] Form validation matches specs

**Code Review:**
- [ ] Follows project code standards
- [ ] Matches design specs
- [ ] Accessibility requirements met
- [ ] Performance acceptable

---

### Phase 7: Release & Learnings

**Pre-Release:**
- [ ] Visual sign-off from product owner
- [ ] Design specs match implementation
- [ ] No tech debt in design-related code

**Post-Release:**
- Update design specs with approved changes
- Document any design decisions that affected implementation
- Update learnings log with design process insights

---

## Design Spec Template Checklist

Each design spec folder should have:

```
[sub-section]/
â”œâ”€â”€ design.md
â”‚   âœ… Visual objective
â”‚   âœ… Color palette (hex codes)
â”‚   âœ… Typography (font, size, weight, line-height)
â”‚   âœ… Layout & grid system
â”‚   âœ… Spacing rules
â”‚   âœ… Component lists
â”‚   âœ… All component states
â”‚   âœ… Interactive behaviors
â”‚   âœ… Loading states
â”‚   âœ… Error states
â”‚   âœ… Accessibility considerations
â”‚   âœ… Responsive rules (mobile, tablet, desktop)
â”‚   âœ… Developer implementation notes
â”‚   âœ… Design rationale
â”‚   âœ… Figma link
â”‚
â”œâ”€â”€ layout.md
â”‚   âœ… Grid system
â”‚   âœ… Column/row structure
â”‚   âœ… Breakpoints (mobile, tablet, desktop)
â”‚   âœ… Safe areas
â”‚   âœ… Padding/margin rules
â”‚   âœ… Max-width constraints
â”‚   âœ… Responsive layout changes
â”‚
â”œâ”€â”€ components.md
â”‚   âœ… Component name
â”‚   âœ… Component type (button, input, card, etc)
â”‚   âœ… States (default, hover, active, disabled, loading, error)
â”‚   âœ… Size variants
â”‚   âœ… Links to component library docs
â”‚   âœ… Usage guidelines
â”‚
â”œâ”€â”€ interactions.md
â”‚   âœ… Hover behaviors
â”‚   âœ… Click/active states
â”‚   âœ… Focus states (keyboard)
â”‚   âœ… Disabled states
â”‚   âœ… Loading states
â”‚   âœ… Error states
â”‚   âœ… Empty states
â”‚   âœ… Success states
â”‚   âœ… Form validation
â”‚   âœ… Animations/transitions
â”‚   âœ… Keyboard navigation
â”‚
â””â”€â”€ assets/
    âœ… Wireframe (PNG/SVG)
    âœ… Mockup (PNG)
    âœ… All state screenshots
    âœ… Icons/illustrations
```

---

## Design Update Flow

When requirements change:

1. **Requirement Changes**
   - Update `dev-doc/[feature-name]/prd.md`
   - Update `artifacts/flows/`

2. **Designer Updates Design**
   - Modify design specs in `dev-doc/[feature-name]/design/`
   - Update Figma designs
   - Document changes in design spec `design.md`

3. **Frontend Developer Updates Implementation**
   - Implement design changes
   - Verify all states match new specs
   - Update code review checklist

4. **Documentation Update**
   - Update `artifacts/architecture/DECISION_LOG.md` if architectural decision changed
   - Update `artifacts/improvement/LEARNINGS.md` if new approach discovered

---

## Design â†’ Frontend Handoff Checklist

**Before Developer Starts:**
- [ ] All design specs complete and reviewed
- [ ] Figma links working
- [ ] Component library available
- [ ] Design tokens defined
- [ ] Accessibility requirements clear
- [ ] Responsive breakpoints specified

**Design Spec Quality Check:**
- [ ] Visual specs include actual colors (hex)
- [ ] Typography is specific (font, size, weight)
- [ ] Spacing is documented (pixels)
- [ ] All component states shown visually or described
- [ ] Mobile/tablet/desktop rules are clear
- [ ] Animations described with timing
- [ ] Error messages specified
- [ ] Form validation rules specified
- [ ] Empty states documented
- [ ] Loading indicators specified

**Developer Readiness Check:**
- [ ] Developer understands design specs
- [ ] Developer can access Figma
- [ ] Developer has design system/component library access
- [ ] Developer knows how to report spec issues
- [ ] Developer knows deviation approval process

---

## Common Design Sections by Product Type

### SaaS Application
- Authentication (login, signup, password reset)
- Dashboard (overview, data tables, charts)
- Settings (profile, account, preferences)
- Onboarding (welcome, setup, tutorial)
- Error pages (404, 500, permission denied)

### E-Commerce
- Product listing (grid, filters, search)
- Product detail (images, description, reviews)
- Shopping cart (items, quantity, totals)
- Checkout (address, payment, review)
- Order confirmation (receipt, tracking, help)

### IoT/Hardware + Cloud
- Device status (on/off, battery, connection)
- Device configuration (settings, controls, scheduling)
- Historical data (charts, trends, reports)
- Alerts/notifications (event log, notifications)
- Mobile controls (quick actions, status)

### Mobile App
- On-boarding/tutorial
- Main navigation (tab bar or drawer)
- Core feature screens
- Detail screens
- Settings & user profile
- Error states & empty states

---

## Tools & Integration

### Design Tools
- **Figma** - Recommended for design + prototyping
- **Sketch** - Alternative for macOS-only team
- **Penpot** - Open-source alternative

### Code Tools
- **Design tokens** - Integrate with Tailwind/CSS variables
- **Storybook** - Component library documentation
- **Figma DevMode** - Check specifications in Figma
- **Code Connect** - Link Figma components to code

### Documentation Tools
- Markdown files in `dev-doc/[feature-name]/design/`
- Figma link system
- Version control (Git) for tracking changes

---

## Metrics & Success Criteria

### Designer Success
- [ ] 100% of flows have design specs
- [ ] All component states documented
- [ ] Specs are specific (colors, fonts, spacing in pixels)
- [ ] Figma designs match specs
- [ ] Accessibility requirements met

### Frontend Developer Success
- [ ] Implementation matches design specs pixel-perfect
- [ ] All documented states implemented
- [ ] Responsive behavior verified at specified breakpoints
- [ ] Accessibility requirements met
- [ ] No deviations from specs without documentation

### Product Owner Success
- [ ] Design matches product vision
- [ ] User flows reflected in UI
- [ ] Branding maintained
- [ ] Accessibility standards met
- [ ] Performance acceptable

---

## Troubleshooting

### Issue: Design specs are too vague
**Solution:** Designer adds visual examples, specific measurements, or Figma screenshots

### Issue: Design changes frequently
**Solution:** Lock design phase to requirements phase. Use decision log to track changes.

### Issue: Frontend can't match design exactly
**Solution:** Document technical constraint in decision log. Design and frontend collaborate on alternative.

### Issue: Design specs outdated
**Solution:** Update design specs when requirements change. Notify frontend developers of changes.

### Issue: Missing states in design
**Solution:** Designer and developer collaborate to define missing states. Update design spec.

---

## Related Documents

- `CLAUDE.md` - Design Rules section
- `workflows/ui_frontend_workflow.md` - Full UI development workflow
- `templates/design_spec_template.md` - Design spec template
- `.claude/skills/design-mapper/SKILL.md` - Design mapping workflow
- `dev-doc/[feature-name]/design/` - All design specifications

