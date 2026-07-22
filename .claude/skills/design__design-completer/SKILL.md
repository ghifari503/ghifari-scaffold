# Design Completer Workflow

**Purpose:** Analyze incomplete or partial design images and auto-generate complete design specifications using extracted patterns as guidelines and UI/UX references.

**Input:**
- Design images (incomplete, partial, or single state)
- Existing design specs (if any)
- Design context/requirements

**Output:**
- Complete design specifications (colors, typography, spacing)
- Extracted design system/patterns
- Generated missing states (hover, error, loading, disabled, etc)
- Suggested component library
- Design consistency recommendations
- Complete UI/UX guidelines based on provided examples

**Workflow Position:** After `design-mapper` creates folder structure, before frontend implementation

---

## Use Cases

### Scenario 1: Single Design Image
**Input:** Designer provides only mockup.png (final design)  
**Process:** Extract all specs from image  
**Output:** Complete design.md with colors, fonts, spacing derived from image

### Scenario 2: Partial States
**Input:** Only state-default.png and state-error.png provided  
**Process:** Analyze patterns, generate missing states (hover, loading, disabled)  
**Output:** Complete state specifications + missing state images

### Scenario 3: Existing Design System
**Input:** 2-3 design screens (different pages)  
**Process:** Extract common patterns (colors, typography, spacing)  
**Output:** Design system rules + apply to other pages

### Scenario 4: Low-Fidelity Sketch
**Input:** Wireframe or rough sketch  
**Process:** Extract layout, suggest styling based on context  
**Output:** Complete design specs with styling suggestions

### Scenario 5: Design Update
**Input:** New version of 1-2 pages  
**Process:** Extract changes, identify what's different  
**Output:** Updated specs + suggestions for consistency across other pages

---

## Phase 1: Analyze Provided Design

**Input:** Design images or specs from `assets/` folder

**Tasks:**

1. **Identify Provided Assets**
   - What images are in assets/ folder?
   - What specs are filled in design.md?
   - What's missing?

2. **Extract Design Elements**
   - Colors: Primary, secondary, accent, backgrounds, text
   - Typography: Font families, sizes, weights, line heights
   - Spacing: Padding, margins, gaps, container widths
   - Components: Button, input, card, modal, etc
   - Shadows, borders, border radius
   - Transitions/animations

3. **Analyze Visual Hierarchy**
   - What's emphasized? (size, color, placement)
   - What's secondary? (muted colors, smaller size)
   - What's disabled/inactive?
   - Focus states (where visible)

4. **Identify UI/UX Patterns**
   - Component patterns (button style, input treatment)
   - Layout patterns (spacing consistency, grid)
   - Interaction patterns (hover effects, animations)
   - Color usage patterns (when used, consistency)
   - Typography patterns (heading vs body, hierarchy)

**Output:** Design Pattern Document

**Checklist:**
- [ ] All visible elements documented
- [ ] Color palette extracted (hex codes)
- [ ] Typography system identified
- [ ] Component patterns recognized
- [ ] Spacing rules identified
- [ ] Visual hierarchy understood
- [ ] Interaction patterns noted

---

## Phase 2: Extract Design System

**Input:** Extracted design elements from Phase 1

**Tasks:**

1. **Color System**
   - Primary color (main actions)
   - Secondary color (alternate actions)
   - Accent colors
   - Neutral colors (backgrounds, borders, text)
   - Semantic colors (error, success, warning)
   - Color variations (hover, active, disabled states)

2. **Typography System**
   - Heading font & variations
   - Body font & variations
   - Caption/helper font
   - Font sizes (scale: sm, md, lg, xl)
   - Font weights used
   - Line heights
   - Letter spacing (if visible)

3. **Spacing System**
   - Base unit (e.g., 8px, 4px)
   - Spacing scale (8, 16, 24, 32, 48, etc)
   - Padding rules (inputs, buttons, containers)
   - Margin rules (between sections)
   - Gap rules (between items)

4. **Component System**
   - Button (primary, secondary, sizes)
   - Input field (text, email, password)
   - Form elements (checkbox, radio, toggle)
   - Cards, modals, dropdowns
   - Icons, badges, alerts
   - Each with states

5. **Visual Patterns**
   - Border radius usage (rounded, sharp, etc)
   - Shadow usage (depth, contrast)
   - Opacity/transparency patterns
   - Hover effects
   - Focus indicators
   - Loading states
   - Error states
   - Success states

**Output:** Design System Documentation

**Format:**
```markdown
# Extracted Design System

## Color Palette
- Primary: #0066FF (used for main actions)
- Error: #FF4444 (used for errors, validation)
- Success: #00AA00 (used for confirmations)
- ...

## Typography
- Heading: [Font], [Size]px, [Weight]
- Body: [Font], [Size]px, [Weight]
- ...

## Spacing
- Base unit: 8px
- Scale: 8, 16, 24, 32, 48px
- ...

## Components
- Button (primary, secondary, small, medium, large)
- Input (default, focused, error, disabled)
- ...
```

**Checklist:**
- [ ] All colors documented with hex codes
- [ ] All typography styles documented
- [ ] Spacing scale identified
- [ ] All components listed
- [ ] Patterns documented
- [ ] Variations identified

---

## Phase 3: Identify Missing States

**Input:** Provided design assets + extracted system

**Tasks:**

1. **State Inventory**
   - Default state: Provided? Missing?
   - Hover state: Provided? Missing?
   - Focus state: Provided? Missing?
   - Active state: Provided? Missing?
   - Disabled state: Provided? Missing?
   - Loading state: Provided? Missing?
   - Error state: Provided? Missing?
   - Success state: Provided? Missing?
   - Empty state: Provided? Missing?

2. **Analyze Provided States**
   - What changed between states?
   - Color changes: Yes/No, what color?
   - Typography changes: Yes/No
   - Size changes: Yes/No
   - Opacity changes: Yes/No
   - Indicator added: Icon, text, animation?

3. **Infer Missing States**
   - Based on patterns, what would hover look like?
   - Based on design system, what's error color?
   - Based on provided states, what's the pattern?
   - Suggest: darker shade for hover?
   - Suggest: red border for error?
   - Suggest: opacity reduction for disabled?

4. **Generate Missing State Specifications**
   - For each missing state, document:
     - What changes from default?
     - Color? Typography? Size? Opacity?
     - Animation timing (if animated)?

**Output:** Missing States Specification

**Format:**
```markdown
# Missing States

## Hover State (missing)
Based on design system:
- Background color: 10% lighter than primary (#1A75FF)
- Cursor: pointer
- Transition: 150ms ease-in-out
- [Screenshot or visual suggestion]

## Disabled State (missing)
Based on design system:
- Opacity: 50%
- Cursor: not-allowed
- Color: grayscale
- [Screenshot or visual suggestion]

...
```

**Checklist:**
- [ ] All missing states identified
- [ ] Inference logic explained
- [ ] Suggested state specs provided
- [ ] Visual descriptions clear
- [ ] Patterns documented

---

## Phase 4: Generate Responsive Variations

**Input:** Extracted design system + missing states

**Tasks:**

1. **Identify Breakpoints**
   - What's the design at? (mobile, tablet, desktop?)
   - Are responsive rules provided?
   - Infer breakpoints (375px, 768px, 1024px standard)

2. **Analyze Responsive Patterns**
   - Does layout change? (column count, width)
   - Do fonts resize? (heading smaller on mobile)
   - Does spacing change? (tighter on mobile)
   - Do components stack? (vertical on mobile)

3. **Generate Responsive Rules**
   - If design is mobile, what's tablet/desktop?
   - If design is desktop, what's mobile/tablet?
   - Based on patterns, suggest rules
   - Document breakpoints and changes

4. **Create Responsive Specifications**
   - Mobile (< 768px): What changes?
   - Tablet (768px - 1024px): What changes?
   - Desktop (> 1024px): What stays same?

**Output:** Responsive Design Specification

**Format:**
```markdown
# Responsive Variations

## Mobile (< 768px)
- Container width: 100%
- Padding: 16px
- Font sizes: [heading] [body]
- Button height: 48px
- Layout: 1 column (stacked)
- [Visual suggestions]

## Tablet (768px - 1024px)
- Container width: 90%
- Padding: 24px
- Font sizes: [unchanged from desktop]
- Button height: 44px
- Layout: 2 columns
- [Visual suggestions]

## Desktop (> 1024px)
- Container width: 1200px
- Padding: 32px
- Font sizes: [unchanged]
- Button height: 44px
- Layout: 3 columns
- [Visual suggestions]
```

**Checklist:**
- [ ] Breakpoints identified
- [ ] Layout changes documented
- [ ] Typography changes specified
- [ ] Spacing changes documented
- [ ] Component behavior at each breakpoint clear

---

## Phase 5: Generate Accessibility Specs

**Input:** Design system + components + states

**Tasks:**

1. **Color Contrast Analysis**
   - Primary text on background: Calculate contrast ratio
   - Secondary text: Calculate contrast ratio
   - Links: Calculate contrast ratio
   - Suggest: WCAG 2.1 AA compliance (4.5:1 for normal text)

2. **Focus States**
   - Are focus indicators visible in provided design?
   - Suggest: Clear focus outline if missing
   - Color: Sufficient contrast?
   - Width: Visible (2-4px)?

3. **Keyboard Navigation**
   - Tab order: Logical order?
   - Focus trap: Avoided?
   - Keyboard shortcuts: Documented?

4. **Component Accessibility**
   - Form labels: Associated?
   - Error messages: ARIA-describedby?
   - Buttons: Proper type (button, submit)?
   - Icons: Alt text or aria-label?

**Output:** Accessibility Specification

**Format:**
```markdown
# Accessibility Requirements

## Color Contrast
- Primary text (#333 on #FFF): 12:1 âœ“ (exceeds 4.5:1)
- Secondary text (#666 on #FFF): 6:1 âœ“ (exceeds 4.5:1)
- Links (#0066FF on #FFF): 4.5:1 âœ“ (meets 4.5:1)

## Focus States
- Outline: 2px solid #0066FF
- Offset: 2px
- Visible: Yes âœ“

## Keyboard Navigation
- Tab order: Logical (top-left â†’ bottom-right)
- Focus trap: None
- Shortcuts: Document any

## Components
- Forms: All inputs have labels
- Buttons: Type specified (button, submit)
- Icons: All have aria-label or alt text
```

**Checklist:**
- [ ] Color contrasts calculated
- [ ] All contrasts meet WCAG AA
- [ ] Focus indicators clear
- [ ] Keyboard navigation documented
- [ ] Component accessibility reviewed
- [ ] ARIA attributes suggested

---

## Phase 6: Generate Complete Specifications

**Input:** All previous phases output

**Tasks:**

1. **Consolidate Design System**
   - Merge extracted system
   - Add missing state specs
   - Add responsive rules
   - Add accessibility requirements
   - Create comprehensive design.md

2. **Create Layout Specifications**
   - Document spacing system
   - Document responsive layouts
   - Document grid/container rules
   - Create complete layout.md

3. **Create Component Inventory**
   - List all components
   - Document states for each
   - Document variants (size, color)
   - Create complete components.md

4. **Create Interaction Specifications**
   - Document all state transitions
   - Document animations/transitions
   - Document hover effects
   - Document focus indicators
   - Create complete interactions.md

5. **Create Implementation Notes**
   - Add developer suggestions
   - Note any assumptions made
   - Identify areas needing designer confirmation
   - Suggest next steps

**Output:** Complete Design Specification Files

**Files Generated:**
- `design.md` - Complete with colors, fonts, spacing, components
- `layout.md` - Responsive rules, grids, containers
- `components.md` - All components, states, variants
- `interactions.md` - All interactions, animations, transitions
- `DESIGN_COMPLETION_REPORT.md` - Summary of what was generated

**Checklist:**
- [ ] design.md complete
- [ ] layout.md complete
- [ ] components.md complete
- [ ] interactions.md complete
- [ ] All sections filled
- [ ] No "TBD" or empty sections
- [ ] Implementation ready

---

## Phase 7: Generate Design Consistency Recommendations

**Input:** All generated specs + original design assets

**Tasks:**

1. **Identify Design Patterns**
   - What patterns emerged?
   - Color usage consistency?
   - Typography consistency?
   - Spacing consistency?
   - Component styling consistency?

2. **Create Pattern Library**
   - Document discovered patterns
   - Show examples
   - Suggest where to apply elsewhere

3. **Suggest Consistency Improvements**
   - Where design can be more consistent?
   - Where patterns can be applied to other sections?
   - Suggest: Apply button style to all action buttons
   - Suggest: Apply spacing scale to all components

4. **Create Design Guidelines**
   - Document what works
   - Document what to avoid
   - Create living design system
   - Suggest: "Always use primary color for main CTA"
   - Suggest: "Always use 16px spacing between sections"

**Output:** Design Consistency Guidelines & Recommendations

**Format:**
```markdown
# Design Consistency Analysis

## Patterns Discovered
- Button style: Rounded, primary blue, white text
- Input style: Border only, focus border color change
- Spacing: 16px base unit
- Typography: 2-level hierarchy (heading, body)

## Recommendations for Consistency

### Colors
- Primary blue (#0066FF) used consistently for CTAs âœ“
- Secondary color not yet established â†’ Suggest #6C757D
- Spacing color system consistent âœ“

### Typography
- Body text always Inter 16px âœ“
- Heading size varies â†’ Suggest standardized scale
- Font weights: 400 regular, 600 bold â†’ Define more weights

### Components
- Button component consistent across pages âœ“
- Input components consistent âœ“
- Modals â†’ Suggest consistent backdrop color

## Design System Suggestions
1. Establish secondary color (gray #6C757D)
2. Define heading size scale (h1, h2, h3, h4, h5, h6)
3. Create icon library (size & color rules)
4. Establish animation timing (standard transitions)
5. Document error/success/warning styles

## To Apply Elsewhere
- [ ] Login form: Apply button style to signup button
- [ ] Dashboard: Apply card styling to data cards
- [ ] Settings: Apply form layout to preferences form
```

**Checklist:**
- [ ] Design patterns identified
- [ ] Consistency analysis complete
- [ ] Pattern library created
- [ ] Recommendations documented
- [ ] Application areas identified
- [ ] Design system guidelines clear

---

## Deliverables

### 1. Complete Design Specifications
- `design.md` - Visual specs (colors, typography, spacing, components)
- `layout.md` - Responsive & grid rules
- `components.md` - Component inventory with states
- `interactions.md` - Interaction & animation specs

### 2. Design System Documentation
- Extracted color system (all colors with hex codes)
- Extracted typography system (all styles)
- Extracted spacing system (all units)
- Pattern library (discovered patterns)

### 3. Analysis Reports
- `DESIGN_COMPLETION_REPORT.md` - Summary of generation
- Missing states specification
- Responsive variation specification
- Accessibility compliance report
- Design consistency recommendations

### 4. Generated Assets (Optional)
- Suggested missing state mockups (visual descriptions)
- Responsive layout variations (visual suggestions)
- Updated assets/ folder with completeness notes

### 5. Implementation Ready
- All specs filled (no "TBD")
- All states documented
- All responsive rules documented
- All accessibility requirements documented
- Developer can implement without questions

---

## Success Criteria

- [ ] 100% of design specs filled (no empty sections)
- [ ] All colors documented with hex codes
- [ ] All typography documented (font, size, weight)
- [ ] All spacing rules documented
- [ ] All component states specified
- [ ] All responsive rules documented
- [ ] All accessibility requirements documented
- [ ] Missing states identified & specified
- [ ] Design system patterns documented
- [ ] Recommendations for other pages provided
- [ ] Implementation-ready specs generated

---

## Assumptions

- At least one design image or partial spec is provided
- Image quality is sufficient to extract colors/styles
- Design is for the same product/system (consistent branding)
- Designer provides context if needed
- Frontend dev can implement based on extracted specs

---

## Risks & Mitigation

**Risk:** Extracted colors don't match designer intent  
**Mitigation:** Document assumptions, flag for designer review

**Risk:** Inferred states look different from intended  
**Mitigation:** Provide visual descriptions, ask for designer feedback

**Risk:** Responsive rules assumed incorrectly  
**Mitigation:** Suggest conservative approach, ask for confirmation

**Risk:** Missing important context  
**Mitigation:** Ask clarifying questions, provide assumptions list

---

## Related Workflows

- `design-mapper` (creates folder structure)
- `design-asset-submission` (designer uploads images)
- `flow-designer` (context for pages)
- `requirement-synthesizer` (requirements context)
- `ui_frontend_workflow` (implementation using generated specs)

---

## When to Use This Workflow

âœ… **Use when:**
- Designer provides incomplete designs (1-2 images only)
- Designer provides single state (only default, no hover/error)
- Need to extend design to other pages
- Need to standardize design system from examples
- Design needs to be completed quickly
- Designer not available for detailed specs

âŒ **Don't use when:**
- Designer can provide complete specs directly
- Design is fundamentally incomplete (missing pages)
- Project needs extensive design work (use professional designer)
- Design quality too low to extract from

---

## Notes

- This workflow **complements** designer work, doesn't replace it
- Best results when designer provides feedback
- Generated specs should be reviewed by designer
- Use as starting point, not final truth
- Always flag assumptions for designer review
- Document confidence level for each generated spec

---

## Example Workflow

**Scenario:** Designer provides only login form mockup.png

```
Input: artifacts/design/auth/login/form/assets/mockup.png

Phase 1: Analyze
- Extract colors: #0066FF primary, #FF4444 error
- Extract fonts: Inter 16px body, 20px heading
- Extract spacing: 16px padding, 8px gap
- Identify patterns: Rounded buttons, blue primary, red errors

Phase 2: Extract System
- Color palette: Primary #0066FF, Error #FF4444, Gray #999
- Typography: Inter (regular, bold)
- Spacing: 8px base unit
- Components: Button, Input, ErrorMessage

Phase 3: Identify Missing States
- Provided: Default state only
- Missing: Hover, focus, error, disabled, loading states
- Inferred: Hover = darker blue, Error = red border, etc

Phase 4: Generate Responsive
- Design shown: Desktop (1200px wide)
- Generate: Mobile rules (100% width, 48px buttons)
- Generate: Tablet rules (90% width, centered)

Phase 5: Accessibility
- Text contrast: 12:1 âœ“
- Focus visible: Add 2px outline
- ARIA: Suggest labels for inputs

Phase 6: Complete Specs
- Generate: design.md (all specs filled)
- Generate: layout.md (responsive rules)
- Generate: components.md (button, input inventory)
- Generate: interactions.md (all states documented)

Phase 7: Recommendations
- Apply login button style to signup
- Apply input styling to password reset
- Create reusable button component
- Establish error message pattern

Output:
âœ“ Complete design specs (design.md filled)
âœ“ All states documented
âœ“ Responsive rules defined
âœ“ Accessibility compliant
âœ“ Design system identified
âœ“ Recommendations for other pages
âœ“ Ready for frontend implementation!
```

---

**System Ready to Complete Incomplete Designs! ðŸŽ‰**

Designer provides incomplete image â†’ System generates complete specifications.

