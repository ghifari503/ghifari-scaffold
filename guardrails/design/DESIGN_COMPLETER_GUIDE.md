# Design Completer Guide

How to use the `design-completer` workflow to generate complete design specifications from incomplete or partial design images.

---

## ðŸŽ¯ Purpose

The `design-completer` workflow:
- âœ… Analyzes incomplete design images
- âœ… Extracts colors, typography, spacing, components
- âœ… Generates missing design states (hover, error, loading, disabled, etc)
- âœ… Creates complete responsive design specifications
- âœ… Produces accessibility requirements
- âœ… Generates design system guidelines
- âœ… Makes incomplete designs implementation-ready

**In short:** Upload partial design images â†’ Get complete design specs automatically!

---

## ðŸ“Š When to Use

### âœ… Use design-completer when:

1. **Incomplete Images**
   - Designer provides only mockup.png (no states)
   - Designer provides only default state (no hover/error)
   - Only 1-2 pages of design provided (need rest)

2. **Partial Specifications**
   - Some colors filled, others missing
   - Some typography specified, not all
   - Some components defined, not all states

3. **Need Quick Design System**
   - Need to extend design to multiple pages
   - Need to standardize design across product
   - Need design tokens extracted automatically

4. **Designer Not Available**
   - Designer busy or unavailable
   - Need to start development before design complete
   - Need design generated from examples

5. **Design Updates**
   - Designer updated 1-2 pages
   - Need to apply changes to other pages
   - Need consistency check across pages

### âŒ Don't use design-completer when:

1. Complete design specs already provided
2. Design is fundamentally incomplete (missing major pages)
3. Need extensive custom design work
4. Project requires professional designer (complex product)
5. Design quality too low to extract specifications

---

## ðŸš€ How to Use

### Step 1: Prepare Design Assets

**Upload design images to:** `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/assets/`

**What to upload:**
```
assets/
â”œâ”€â”€ mockup.png (main design, at least 1 image needed)
â”œâ”€â”€ wireframe.png (optional, if you have it)
â”œâ”€â”€ state-default.png (optional)
â””â”€â”€ state-error.png (optional)
```

**Minimum:** 1 design image (e.g., mockup.png showing the final design)

**Best:** 2-3 images showing different states or pages

### Step 2: Create figma-link.txt (Optional)

If you have Figma design, add link to: `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/figma-link.txt`

```
Figma Design File
================
URL: https://www.figma.com/design/ABC123/...?node-id=10:45

FileKey: ABC123
NodeId: 10:45

Designer: Sarah Chen
Last Updated: 2026-04-07
```

(Optional - design-completer works without Figma link too)

### Step 3: Run design-completer

**Command:**
```
Run: design-completer workflow

Input:
  Page: [page-name]
  Section: [section-name]
  SubSection: [sub-section-name]
  
Or just tell Claude:

"Run design-completer on my login form design.
Images: dev-doc/authentication/design/login/form/assets/mockup.png"
```

### Step 4: Review Generated Specs

Claude will generate:
```
âœ“ design.md (COMPLETE with all specs)
âœ“ layout.md (COMPLETE with responsive rules)
âœ“ components.md (COMPLETE with all components)
âœ“ interactions.md (COMPLETE with all states)
âœ“ DESIGN_COMPLETION_REPORT.md (summary)
```

### Step 5: Ask Designer for Confirmation (if available)

Share generated specs with designer:
- [ ] Are the extracted colors correct?
- [ ] Are the fonts/typography correct?
- [ ] Do the generated states look right?
- [ ] Is responsive design as intended?
- [ ] Any changes needed?

### Step 6: Update & Use

- Adjust specs if designer provided feedback
- Use complete specs for frontend implementation
- Reference images in assets/ folder
- Done! ðŸŽ‰

---

## ðŸ“‹ What Gets Generated

### Output Files

#### 1. design.md (COMPLETE SPECIFICATION)
```markdown
# Design Specification

## Visual Objective
[Extracted from image]

## Design System
### Color Palette
- Primary: #0066FF (extracted from image)
- Secondary: #6C757D (inferred from patterns)
- Error: #FF4444 (extracted)
- Success: #00AA00 (inferred)
- Text: #333333 (extracted)
- Borders: #CCCCCC (extracted)

### Typography
- Heading: Inter Bold 24px (extracted)
- Body: Inter Regular 16px (extracted)
- Caption: Inter Regular 12px (inferred)

## Components
- Button (primary, secondary, sizes)
- Input field (states documented)
- Card, Modal, etc

## Interactions & States
- Hover: Darker primary (#1A75FF, inferred)
- Focus: 2px outline #0066FF, suggested
- Error: Red border, extracted from state image
- Disabled: 50% opacity, inferred
- Loading: Spinner suggested

## Responsive Behavior
- Mobile: Full width, 16px padding (inferred)
- Tablet: 90% width, 24px padding (suggested)
- Desktop: 1200px max, 32px padding (extracted)

## Accessibility
- Text contrast: 12:1 âœ“ (calculated)
- Focus indicators: Visible âœ“ (suggested)
- ARIA labels: Recommended

## Developer Notes
- Assumptions made clearly noted
- Areas needing confirmation flagged
- Implementation tips provided
```

#### 2. layout.md (SPACING & RESPONSIVE RULES)
```markdown
# Layout Specification

## Grid System
- Base unit: 8px
- Grid columns: 12-column at desktop
- Gutter: 16px

## Spacing Scale
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px

## Responsive Breakpoints
- Mobile < 768px
- Tablet 768px - 1024px
- Desktop > 1024px

## Layout Changes by Breakpoint
[All changes documented]
```

#### 3. components.md (COMPONENT INVENTORY)
```markdown
# Components

## Button
- Type: Primary action button
- States: default, hover, active, disabled, loading
- Sizes: small (h-10), medium (h-12), large (h-14)
- Usage: Main CTAs

## Input
- Type: Text input field
- States: default, focused, error, disabled
- Variants: text, email, password
- Usage: Form inputs

## [Other components...]
```

#### 4. interactions.md (ALL STATES & ANIMATIONS)
```markdown
# Interactions & States

## Hover State
- Color change: Primary â†’ #1A75FF
- Transition: 150ms ease-in-out
- Shadow: 0 4px 12px rgba(0,0,0,0.1)

## Error State
- Border color: #FF4444
- Error message: "Invalid input"
- Animation: 200ms shake effect

## Loading State
- Show spinner
- Button disabled
- Duration: Until response

## [Other states...]
```

#### 5. DESIGN_COMPLETION_REPORT.md (SUMMARY)
```markdown
# Design Completion Report

## Input Analysis
- Images provided: 1 (mockup.png)
- Specs completed: 20%
- Coverage: Login form only

## Extraction Results
- Colors extracted: 6 unique colors
- Typography identified: 2 font styles
- Spacing unit identified: 8px
- Components found: 3 (button, input, link)

## What Was Generated
- Generated missing states: 5
  - Hover (inferred from design patterns)
  - Error (suggested based on color system)
  - Loading (suggested standard)
  - Disabled (inferred from opacity patterns)
  - Focus (WCAG requirement)

- Generated responsive rules: Yes
  - Mobile layouts suggested
  - Tablet layouts suggested
  - Desktop layouts extracted

- Generated accessibility specs: Yes
  - Color contrasts calculated
  - Focus indicators suggested
  - ARIA recommendations provided

## Design System Extracted
- Color system: 6 colors established
- Typography system: 2-level hierarchy
- Spacing system: 8px base unit
- Component system: 3 base components
- Pattern library: Consistent styling identified

## Confidence Levels
- Colors: HIGH (directly extracted from image)
- Typography: MEDIUM (partially visible, some inferred)
- Spacing: MEDIUM (estimated from image)
- States: MEDIUM (inferred from patterns)
- Responsive: LOW (no mobile design provided, standard breakpoints assumed)

## Flagged for Designer Review
- [ ] Secondary color choice (#6C757D) - not shown in image
- [ ] Font weights beyond regular/bold - confirm if needed
- [ ] Mobile layout assumptions - verify responsiveness approach
- [ ] Animation timings - confirm preferred transitions
- [ ] Error message styling - confirm color & animation

## Next Steps
1. Designer reviews flagged items
2. Update specs if corrections needed
3. Frontend can implement with confidence
4. Suggest applying patterns to other pages

## Recommendations
1. Establish secondary color system
2. Define complete heading hierarchy (h1-h6)
3. Create icon library with sizing rules
4. Standardize animation library
5. Document accessibility approach

## Files Generated
âœ“ design.md (complete)
âœ“ layout.md (complete)
âœ“ components.md (complete)
âœ“ interactions.md (complete)
âœ“ DESIGN_COMPLETION_REPORT.md (this file)

Status: READY FOR IMPLEMENTATION
```

---

## ðŸ” What Gets Extracted

### From Design Images

**Colors:**
- Primary color (main actions)
- Secondary colors (alternate actions)
- Text colors (dark, light, disabled)
- Border colors
- Background colors
- Error/success/warning colors

**Typography:**
- Heading font & size
- Body font & size
- Caption/helper font
- Font weights used
- Line heights (when visible)

**Spacing:**
- Padding around components
- Margins between elements
- Gaps between items in groups
- Container widths
- Touch targets (button heights)

**Components:**
- Button (primary, secondary, sizes)
- Input fields (text, email, password)
- Form elements (checkbox, radio, toggle)
- Cards, modals, dropdowns
- Icons, badges, alerts
- Each with visible states

**Visual Patterns:**
- Border radius (rounded vs sharp)
- Shadow usage (depth, contrast)
- Opacity/transparency patterns
- Hover effects (if visible)
- Focus indicators (if visible)

### What Gets Inferred

**Missing States:**
- Hover: Usually darker primary color
- Focus: Usually outline in primary color
- Disabled: Usually reduced opacity
- Error: Usually error color from system
- Loading: Usually spinner indicator
- Success: Usually success color from system

**Responsive Rules:**
- If desktop design: Suggests mobile layout (full width, stacked)
- If mobile design: Suggests desktop layout (wider, columns)
- Standard breakpoints: 375px mobile, 768px tablet, 1024px desktop
- Touch targets: Minimum 44-48px on mobile

**Accessibility:**
- Color contrast ratios calculated
- Focus indicators suggested (if missing)
- ARIA labels suggested
- Semantic HTML recommended

**Design System:**
- Color palette created
- Typography scale established
- Spacing scale defined
- Component patterns identified
- Common patterns documented

---

## ðŸ“ˆ Confidence Levels

### HIGH CONFIDENCE
- âœ… Colors directly visible in image
- âœ… Text content visible
- âœ… Component structure
- âœ… Spacing between visible elements

### MEDIUM CONFIDENCE
- âš ï¸ Typography (if text is small/unclear)
- âš ï¸ Exact spacing (estimates from image)
- âš ï¸ Component styling (inferred from context)
- âš ï¸ States (logical inference from design patterns)

### LOW CONFIDENCE
- âš ï¸ Missing states (not shown in image)
- âš ï¸ Responsive behavior (one breakpoint shown)
- âš ï¸ Animation timing (not visible in static image)
- âš ï¸ Accessibility details (not always visible)

**Recommended:** Designer reviews and confirms flagged items

---

## ðŸŽ¯ Example Workflow

### Scenario: Designer provides only login form mockup

**Input:** 1 image (mockup.png of login form)

**Designer uploads to:**
```
dev-doc/authentication/design/login/form/assets/mockup.png
```

**Run design-completer:**
```
"Analyze login form design and generate complete specs.
Image: dev-doc/authentication/design/login/form/assets/mockup.png"
```

**Process:**
```
Phase 1: Analyze Image
- Extract: Button color #0066FF, Input field style, text color #333
- Identify: Component types (button, input, link)
- Document: Layout pattern (vertical stack, centered form)

Phase 2: Extract System
- Color: Primary #0066FF, Text #333
- Typography: Body Inter 16px
- Spacing: 16px gaps

Phase 3: Missing States
- Provided: Default state only
- Missing: Hover, focus, error, disabled, loading
- Generate: Specs for all missing states

Phase 4: Responsive
- Design shown: Desktop (1200px container)
- Generate: Mobile rules (100% width)
- Generate: Tablet rules (90% width)

Phase 5: Accessibility
- Contrast: 12:1 âœ“
- Focus: Suggest outline
- ARIA: Suggest labels

Phase 6: Complete Specs
- design.md: All sections filled
- layout.md: Spacing & responsive documented
- components.md: Button & input documented
- interactions.md: All states documented

Output: COMPLETE SPECS! âœ…
```

**Time:** ~5-10 minutes for Claude to analyze and generate  
**Quality:** Ready for frontend implementation  
**Confidence:** Designer should review flagged assumptions

**Result:**
```
âœ“ design.md (filled)
âœ“ layout.md (filled)
âœ“ components.md (filled)
âœ“ interactions.md (filled)
âœ“ DESIGN_COMPLETION_REPORT.md (summary with flags)

Frontend dev can implement immediately!
Designer can review & confirm/adjust as needed.
```

---

## ðŸ’¡ Tips

### For Best Results

1. **Provide Good Quality Images**
   - Clear, readable design
   - Good color reproduction
   - At least 1200px width

2. **Provide Multiple States (if available)**
   - Default state: Essential
   - Error state: Helpful
   - Hover state: Helpful
   - Wireframe: Optional but helpful

3. **Add Context Comments**
   - "This is mobile design, extrapolate to desktop"
   - "Only showing default state, generate all states"
   - "Reuse this color system for all pages"

4. **Review Flagged Items**
   - Designer reviews DESIGN_COMPLETION_REPORT.md
   - Confirms or corrects assumptions
   - Updates specs if needed

5. **Apply Patterns Elsewhere**
   - Use extracted colors on other pages
   - Apply component styles to similar components
   - Use spacing patterns consistently

### To Improve Results

1. **Use Figma Link** (if available)
   - Claude can fetch exact colors/measurements
   - Results more accurate
   - States clearer from Figma variants

2. **Provide Wireframe + Mockup**
   - Wireframe shows structure
   - Mockup shows final styling
   - Together = better extraction

3. **Document Assumptions**
   - "Primary color for CTAs"
   - "Mobile should be full-width"
   - "Use standard breakpoints"

4. **Get Designer Feedback**
   - Share generated specs
   - Confirm color choices
   - Verify state behaviors
   - Check responsive approach

---

## âš ï¸ Important Notes

### What It Does
- âœ… Analyzes visual design images
- âœ… Extracts colors, fonts, spacing
- âœ… Generates missing specifications
- âœ… Creates implementation-ready specs

### What It Doesn't Do
- âŒ Replace professional designer
- âŒ Create visual designs (only analyzes provided)
- âŒ Guarantee design perfection
- âŒ Handle complex design systems alone
- âŒ Provide brand strategy

### Designer Review Recommended
- Results are automatically generated
- Should be reviewed by designer
- Assumptions should be confirmed
- Adjustments may be needed
- Use as starting point, not final truth

### When to Use vs When to Get Designer
| Situation | Use design-completer | Get Designer |
|-----------|---------------------|-------------|
| 1-2 images provided | âœ… Yes | âš ï¸ Verify after |
| Complete design provided | âŒ No | âœ… Use directly |
| Quick turnaround needed | âœ… Yes | â³ Takes time |
| Complex product | âŒ Maybe | âœ… Yes |
| Simple form/modal | âœ… Yes | Optional |
| Design system needed | âœ… Yes | âœ… Better |
| Brand new product | âŒ No | âœ… Needed |

---

## ðŸ“š Related Documentation

- `.claude/skills/design-completer/SKILL.md` - Detailed workflow
- `guardrails/design/DESIGN_ASSET_SUBMISSION.md` - How to submit design images
- `guardrails/design/DESIGNER_QUICK_START.md` - For designers
- `guardrails/design/DESIGN_FOLDER_STRUCTURE.md` - Where to put images
- `workflows/ui_frontend_workflow.md` - Full UI workflow (includes design-completer)

---

## ðŸš€ Quick Start

**In 3 steps:**

1. **Upload** design image to `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/assets/`
2. **Run** design-completer workflow
3. **Review** generated specs (design.md, layout.md, components.md, interactions.md)

**Result:** Complete, implementation-ready design specifications!

---

**Ready to complete incomplete designs! ðŸŽ‰**

Upload images â†’ Get specs â†’ Implement with confidence!

