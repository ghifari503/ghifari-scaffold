# Design Mapper Workflow

**Purpose:** Analyze requirements and user flows to automatically generate visual design folder structure and create design spec templates

**Input:**

- User flows from `flow-designer`
- Feature requirements from `requirement-synthesizer`
- Screen/page specifications

**Output:**

- Design folder structure in `artifacts/design/`
- Design spec files ready for visual designers
- Page overview documents
- Component inventory

**Workflow Position:** After `flow-designer`, before detailed visual design work

---

## Phase 1: Analyze Requirements

**Input:** Flow and requirement documents

**Tasks:**

1. Extract all user-facing screens/pages from flows
2. Identify page groups (e.g., Authentication, Dashboard, Settings)
3. List user interactions and state transitions
4. Document required components and elements

**Output:** Structured page/screen inventory

**Checklist:**

- [ ] All screens identified from flows
- [ ] Page hierarchies documented
- [ ] User interactions mapped to pages
- [ ] State transitions documented

---

## Phase 2: Generate Folder Structure

**Input:** Page inventory from Phase 1

**Tasks:**

1. Map pages to top-level folders: `[page-name]/`
2. Identify sections within each page: `[page-name]/[section]/`
3. Identify subsections for complex sections: `[page-name]/[section]/[sub-section]/`
4. Create folder hierarchy
5. **Create `assets/` subfolder** in each [sub-section]/ â† IMPORTANT
6. Generate placeholder design spec files
7. Generate placeholder `figma-link.txt`

**Output:** Folder structure with template files and ready-to-use assets folder

**Example Structure:**

```
design/
â”œâ”€â”€ authentication/
â”‚   â”œâ”€â”€ login/
â”‚   â”‚   â”œâ”€â”€ form/
â”‚   â”‚   â”‚   â”œâ”€â”€ design.md
â”‚   â”‚   â”‚   â”œâ”€â”€ layout.md
â”‚   â”‚   â”‚   â”œâ”€â”€ components.md
â”‚   â”‚   â”‚   â”œâ”€â”€ interactions.md
â”‚   â”‚   â”‚   â””â”€â”€ assets/
â”‚   â”‚   â”œâ”€â”€ errors/
â”‚   â”‚   â”‚   â”œâ”€â”€ design.md
â”‚   â”‚   â”‚   â”œâ”€â”€ error-types.md
â”‚   â”‚   â”‚   â””â”€â”€ assets/
â”‚   â”‚   â””â”€â”€ page-overview.md
â”‚   â”œâ”€â”€ signup/
â”‚   â”‚   â””â”€â”€ ...
â”‚   â”œâ”€â”€ password-reset/
â”‚   â”‚   â””â”€â”€ ...
â”‚   â””â”€â”€ authentication-overview.md
â”‚
â”œâ”€â”€ dashboard/
â”‚   â”œâ”€â”€ header/
â”‚   â”‚   â””â”€â”€ ...
â”‚   â”œâ”€â”€ sidebar/
â”‚   â”‚   â”œâ”€â”€ navigation/
â”‚   â”‚   â””â”€â”€ ...
â”‚   â”œâ”€â”€ main-content/
â”‚   â”‚   â””â”€â”€ ...
â”‚   â””â”€â”€ page-overview.md
â”‚
â””â”€â”€ settings/
    â””â”€â”€ ...
```

**Checklist:**

- [ ] All pages have top-level folders
- [ ] Logical sections identified
- [ ] Complex sections have subsections
- [ ] Naming is URL-friendly (kebab-case)
- [ ] Parent folders have overview docs

---

## Phase 3: Create Design Spec Templates & Asset Folders

**Input:** Folder structure from Phase 2

**Tasks:**

1. For each [sub-section] folder:
   - âœ“ Create `assets/` folder (empty, ready for designer images)
   - âœ“ Create `design.md` from template
   - âœ“ Create `layout.md` from template
   - âœ“ Create `components.md` from template
   - âœ“ Create `interactions.md` from template
   - âœ“ Create `figma-link.txt` placeholder

2. For each [section] folder:
   - Create `section-overview.md` documenting all subsections
   - Link to all child [sub-section] folders

3. For each [page-name] folder:
   - Create `page-overview.md` documenting all sections
   - Link to all child [section] folders
   - Describe page purpose and navigation

**Output:** Complete folder structure with:**
- âœ“ Template files ready for designer input
- âœ“ Empty `assets/` folders ready for designer images
- âœ“ Overview documents showing hierarchy

**Result:** Designer opens folder and sees clean, ready-to-use structure**

**Checklist:**

- [ ] All `assets/` folders created (empty, ready for images)
- [ ] All spec files created (design.md, layout.md, components.md, interactions.md)
- [ ] All `figma-link.txt` placeholder created
- [ ] All overview docs created (page-overview.md, section-overview.md)
- [ ] Folder structure is navigable (overview docs link to children)
- [ ] Template files properly populated with sections

---

## Phase 4: Map Components to Pages

**Input:** Design specs and component inventory

**Tasks:**

1. Review each design spec
2. Identify which UI components are needed
3. List component states and variants
4. Cross-reference with component library
5. Document component usage in `components.md`

**Output:** Component mapping for each page/section

**Documentation Format:**

```markdown
# Components

## Primary Components

- Button (primary, secondary, tertiary)
  - States: default, hover, active, disabled, loading
  - Sizes: small, medium, large
  - Link: components/button.md

- Input Field (text, email, password, number)
  - States: default, focused, error, disabled
  - Validation: real-time, on-blur, on-submit

## Supporting Components

- Icons
- Badges
- Tooltips
```

**Checklist:**

- [ ] All components identified
- [ ] Component states documented
- [ ] Variants listed
- [ ] Links to component docs added

---

## Phase 5: Document Interactions & States

**Input:** User flows and page specs

**Tasks:**

1. For each page/section, document:
   - Form interactions and validation
   - Loading states
   - Error states
   - Empty states
   - Success states
   - Confirmation dialogs

2. Create state transition diagrams
3. Document animation/transition requirements
4. Note keyboard navigation order

**Output:** Detailed interaction specs

**Checklist:**

- [ ] All state transitions documented
- [ ] Validation rules clear
- [ ] Error messages specified
- [ ] Success feedback specified
- [ ] Loading indicators defined
- [ ] Animations documented

---

## Phase 6: Create Navigation Map

**Input:** Page overview documents

**Tasks:**

1. Create navigation hierarchy
2. Document primary navigation (sidebar, menu)
3. Document secondary navigation (breadcrumbs, tabs)
4. Map page-to-page flows
5. Create site map or navigation overview

**Output:** Navigation spec document

**Document Includes:**

- Primary navigation structure
- Breadcrumb patterns
- Tab organization
- Page flow diagram
- Deep linking structure

**Checklist:**

- [ ] Main navigation documented
- [ ] All pages reachable
- [ ] Breadcrumb logic clear
- [ ] Navigation states defined
- [ ] Mobile navigation strategy documented

---

## Deliverables

### 1. Design Folder Structure

- Organized in `artifacts/design/`
- Following `[page]/[section]/[sub-section]` pattern
- **All folders include `assets/` subfolder** (empty, ready for designer images)
- **All folders include `figma-link.txt`** (placeholder for Figma URL)
- All folders contain required markdown files

### 2. Design Spec Documents

- `[page-name]/page-overview.md` - Page summary, sections listed, navigation
- `[page]/[section]/section-overview.md` - Section summary, subsections listed
- `[page]/[section]/[sub-section]/design.md` - Visual specification template
- `[page]/[section]/[sub-section]/layout.md` - Spacing and grid template
- `[page]/[section]/[sub-section]/components.md` - Component inventory template
- `[page]/[section]/[sub-section]/interactions.md` - States and interactions template

### 3. Asset Folders (NEW)

- **`assets/` subfolder** in each [sub-section]/
- Empty folder ready for designer images
- Designer adds: mockups (PNG/SVG), state screenshots, design references
- Pattern: `state-[name].png` (e.g., `state-error.png`, `state-loading.png`)

### 4. Figma Link References (NEW)

- **`figma-link.txt`** in each [sub-section]/ folder
- Placeholder for Figma file key and node ID
- Designer fills with actual Figma URL
- Can be referenced in design.md with link

### 5. Component Mapping

- All components identified
- States and variants documented
- Listed in components.md

### 6. Navigation Map

- Site structure documented in overview.md files
- Page-to-page flows documented
- Section hierarchy documented

### 7. Design Readiness Report

- Summary of design specs created
- Folder structure overview
- Component inventory
- Next steps for designer
- Expected assets to be added

---

## Assumptions

- User flows have been created by `flow-designer`
- Feature requirements are documented in PRD
- Component library will be available during design phase
- Designer will fill in visual details

---

## Success Criteria

- [ ] 100% of pages from flows have design folders
- [ ] All design specs are template-complete
- [ ] Component inventory is comprehensive
- [ ] Navigation map is clear and accurate
- [ ] Developer notes are implementation-ready

---

## Open Questions

- Will Figma be used for design tool?
- Are there existing components to reuse?
- Brand guidelines/design system in place?
- Accessibility standards (WCAG 2.1, AA/AAA)?
- Animation budget/preference?

---

## Risks

- Incomplete flow analysis leads to missing pages
- Component inventory gaps
- Design specs too detailed or too vague
- Navigation changes after specs are created

---

## Recommended Next Steps

1. Designer reviews design folder structure
2. Designer fills in visual specs (`design.md` files)
3. Create Figma designs based on specs
4. Design review with product owner
5. Frontend developers reference specs during implementation
6. Update specs with implementation learnings

---

## Related Workflows

- `flow-designer` (input for page identification)
- `requirement-synthesizer` (input for feature requirements)
- `solution-architect` (input for technical constraints)
- Frontend builder agents (consumers of design specs)

---

## Notes

- This is an _analytical_ workflow, not a visual design workflow
- Designer still needs to create actual visual designs in Figma/Sketch
- Design specs are _reference documents_ for developers
- Updated as requirements/flows change

