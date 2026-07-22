# Designer Quick Start Guide

For designers new to this design system, here's what you need to know.

---

## ðŸŽ¯ Your Role

You receive a folder structure with design spec **templates**. Your job is to:

1. **Review** the folder structure and understand the page hierarchy
2. **Fill in** the design specifications with actual visual details
3. **Create** Figma/Sketch designs (or other tool)
4. **Get approval** from product owner
5. **Link** designs to documentation
6. **Hand off** to frontend developers

---

## ðŸ“ What You'll Receive

```
dev-doc/[feature-name]/design/
â”œâ”€â”€ [page-name]/
â”‚   â”œâ”€â”€ page-overview.md
â”‚   â””â”€â”€ [section]/
â”‚       â”œâ”€â”€ section-overview.md
â”‚       â””â”€â”€ [sub-section]/
â”‚           â”œâ”€â”€ design.md (template - YOUR JOB TO FILL)
â”‚           â”œâ”€â”€ layout.md (template)
â”‚           â”œâ”€â”€ components.md (template)
â”‚           â”œâ”€â”€ interactions.md (template)
â”‚           â”œâ”€â”€ assets/ (empty folder)
â”‚           â””â”€â”€ figma-link.txt (placeholder)
```

### What Each File Means

- **page-overview.md** - Describes all pages in this group and how they relate
- **section-overview.md** - Describes sections within a page
- **design.md** - YOUR MAIN FILE: Visual specs (colors, fonts, spacing)
- **layout.md** - YOUR FILE: Spacing rules and responsive layout
- **components.md** - YOUR FILE: List of UI components and states
- **interactions.md** - YOUR FILE: Interaction states and animations
- **assets/** - YOUR FOLDER: Upload screenshots, mockups, wireframes
- **figma-link.txt** - YOUR FILE: Link to Figma design

---

## âœï¸ How to Fill Design Specs

### For Each Sub-Section, Complete:

#### 1. `design.md` (Main specification)

**Section: ðŸŽ¨ Design System**
```
Colors: Specify hex codes for:
- Primary (main action color)
- Secondary (alternate actions)
- Accent (highlights, focus)
- Backgrounds (page, surface, hover)
- Text colors (dark, light, disabled)
- Border colors
- Error, success, warning colors

Typography: For each text style:
- Font family (e.g., "Inter", "Roboto")
- Font size (e.g., "16px")
- Font weight (e.g., "400", "600", "700")
- Line height (e.g., "1.5", "24px")
```

**Section: ðŸ“ Layout & Spacing**
```
Specific measurements:
- Form max width: [px]
- Input height: [px]
- Button height: [px]
- Padding: [value]
- Margin: [value]
- Gap between elements: [value]
- Border radius: [value]
- Box shadow: [definition]
```

**Section: ðŸ§© Components**
```
List every component on the page:
- Button (primary, secondary, tertiary)
  - States: default, hover, active, disabled, loading
  - Sizes: small, medium, large
  
- Input field (text, email, password)
  - States: default, focused, filled, error, disabled
  
- Card, Modal, Dropdown, etc.
```

**Section: âš™ï¸ Interactions & States**
```
For every interactive element, specify:
- Default state appearance
- Hover state (color, scale, shadow changes)
- Active/pressed state
- Focused state (keyboard focus)
- Disabled state
- Loading state
- Error state
- Success state
```

**Section: ðŸ“± Responsive Behavior**
```
Mobile (< 768px):
- Layout changes
- Hidden elements
- Font size adjustments
- Touch target sizes

Tablet & Desktop:
- Layout adjustments
- Column widths
- Max widths
```

**Section: â™¿ Accessibility**
```
- Color contrast ratios (minimum 4.5:1)
- Focus indicators (outline, color)
- Keyboard navigation order
- ARIA label suggestions
```

**Section: ðŸ’» Developer Notes**
```
Implementation hints:
- CSS framework to use (Tailwind, CSS modules, etc.)
- Design token mapping
- Browser support
- Known gotchas
```

#### 2. `layout.md` (Spacing rules)

Document the grid system and spacing:
```
- Grid columns: 12-column? 8-column? Custom?
- Column width: [px]
- Gutter width: [px]
- Row height: [px]
- Breakpoints: mobile (375px?), tablet (768px?), desktop (1024px?)

For each breakpoint:
- Container max-width
- Column changes
- Element sizes
- Font sizes
```

#### 3. `components.md` (Component inventory)

List every component used:
```
| Component | Type | States | Sizes | Notes |
|-----------|------|--------|-------|-------|
| Button | Primary action | default, hover, active, disabled, loading | sm, md, lg | Links to button component docs |
| Input | Text entry | default, focused, error, disabled | - | Supports placeholder text |
| Card | Container | - | - | 8px border radius |
```

#### 4. `interactions.md` (Interaction specs)

Describe how things interact:
```
Form Validation:
- Real-time or on-blur?
- Error message placement: inline, toast, modal?
- Error message styling: color, icon, animation?

Loading States:
- Show spinner? Skeleton? Progress bar?
- Button text changes? Becomes disabled?
- Duration: estimated time?

Error States:
- Message text: what should it say?
- Visual styling: shake animation? Red border?
- Action: retry button? Help link?

Animations:
- Fade in/out: 200ms ease-out
- Hover: 150ms ease-in-out
- Loading spinner: 800ms linear rotation
```

---

## ðŸŽ¨ Tips for Writing Good Specs

### Be Specific
- âŒ Bad: "Use a light color"
- âœ… Good: "Use #F5F5F5 (light gray)"

- âŒ Bad: "Padding around button"
- âœ… Good: "Padding: 12px horizontal, 8px vertical"

- âŒ Bad: "Large button"
- âœ… Good: "Height: 48px, Font size: 16px, Font weight: 600"

### Show Visual States
For every interactive element, describe or show:
- Default (how it looks normally)
- Hover (when user hovers)
- Active (when user clicks)
- Focused (when keyboard focus)
- Disabled (when can't interact)
- Loading (while processing)
- Error (if something goes wrong)
- Success (when action succeeds)

### Think Mobile First
Design for mobile (375px), then tablet (768px), then desktop (1024px).

### Include Accessibility
- Specify color contrasts
- Describe focus indicators
- List keyboard navigation order
- Include ARIA label suggestions

### Document Everything
If something isn't obvious, document it. Frontend developers can't ask you questions.

---

## ðŸ–¼ï¸ Example: Login Form Design.md

Here's what a filled design.md looks like:

```markdown
# Login Form - Design Specification

## ðŸŽ¨ Design System

### Color Palette
- Primary: #0066FF (Figma blue)
- Error: #FF4444 (red)
- Text: #333333 (dark gray)
- Border: #CCCCCC (light gray)
- Background: #FFFFFF (white)

### Typography
- Labels: Inter 400 14px, line-height 1.4
- Input text: Inter 400 16px, line-height 1.5
- Error: Inter 400 12px, line-height 1.4, color #FF4444

## ðŸ“ Layout & Spacing
- Form width: 400px max
- Padding: 24px
- Input height: 40px desktop, 44px mobile
- Gap between inputs: 16px
- Button height: 44px desktop, 48px mobile

## âš™ï¸ Interactions & States

### Input Focus
- Border color: changes from #CCCCCC to #0066FF
- Box shadow: 0 0 0 3px rgba(0, 102, 255, 0.1)
- Transition: 150ms ease-in-out

### Button Hover
- Background: changes from #0066FF to #0052CC (darker)
- Cursor: pointer
- Transition: 150ms

### Error State
- Border: 2px solid #FF4444
- Error message: "Invalid email format"
- Color: #FF4444
- Margin top: 4px

### Loading State
- Show: spinner icon in button
- Text: "Signing in..."
- Button: disabled (opacity 0.5, cursor not-allowed)
- Spinner: 24px diameter, rotating 800ms

## ðŸ“± Responsive
- Mobile (< 768px): 100% width, 16px padding
- Tablet+: max 400px width, centered, 24px padding
```

---

## ðŸ“¸ Creating Visual Assets

### For `assets/` folder, include:

1. **Wireframe** (low-fidelity sketch)
   - Shows layout and structure
   - Basic element placement
   - Can be simple boxes and lines

2. **Mockup** (high-fidelity design)
   - Full visual design
   - Colors, typography, spacing
   - All UI details

3. **State Screenshots** (show different states)
   - state-default.png - Normal appearance
   - state-hover.png - Hover state
   - state-focused.png - Keyboard focus
   - state-error.png - Error state
   - state-loading.png - Loading state
   - state-disabled.png - Disabled state

### Screenshots Format
- PNG or SVG recommended
- Good resolution (at least 2x display size)
- Clear, readable
- Labeled if complex

---

## ðŸ”— Linking Figma Designs

After creating your Figma design:

1. **Copy Figma link** from your design file
2. **Open** `figma-link.txt` in the design spec folder
3. **Paste** your Figma link

Example:
```
Figma Design File
================
Project: MyApp Design System
File: Authentication
Page: Login

URL: https://www.figma.com/design/abc123/Authentication?node-id=10:45

Designer: Jane Smith
Last Updated: 2026-04-07
```

Frontend developers will click this link to see your live design!

---

## âœ… Completeness Checklist

Before handing off to frontend developers:

**Visual Details**
- [ ] Colors defined (hex codes)
- [ ] Typography defined (font, size, weight)
- [ ] Spacing values documented
- [ ] All component states visually defined

**Specifications**
- [ ] design.md filled completely
- [ ] layout.md filled with spacing rules
- [ ] components.md lists all components
- [ ] interactions.md documents all states

**Assets**
- [ ] Figma design created
- [ ] Screenshots captured for all states
- [ ] Assets folder populated
- [ ] figma-link.txt updated

**Review**
- [ ] Product owner approved design
- [ ] No ambiguity in specs
- [ ] Frontend dev can implement without questions
- [ ] Accessibility requirements clear

---

## ðŸ“ž Common Questions

### Q: Do I need to create Figma designs?
**A:** Recommended but not required. The design.md specs are the main deliverable. Figma is for visual reference.

### Q: Can I use different colors than specified?
**A:** Only if product owner approves. Changes should be documented in DECISION_LOG.md.

### Q: What if I don't know a specific value?
**A:** Use your best judgment and note it. Frontend dev can refine it. Document it as "TBD" and follow up.

### Q: How many states do I need to design?
**A:** Minimum: default, hover, active, disabled, error, loading. More is better for comprehensive specs.

### Q: Can I change the folder structure?
**A:** No. Folder structure comes from design-mapper analysis. Ask if it needs adjustment.

### Q: How often should I update specs?
**A:** Keep them current with your designs. When you change something in Figma, update the spec.

### Q: Who approves my design?
**A:** Product owner/founder. Once approved, specs go to frontend developers.

---

## ðŸš€ Your Design Workflow

```
1. Receive design folder structure
   â†“
2. Review page-overview.md
   â†“
3. For each sub-section:
   - Fill design.md (colors, typography, spacing)
   - Fill layout.md (responsive rules)
   - Fill components.md (component inventory)
   - Fill interactions.md (all states)
   - Add assets/ (screenshots)
   - Add figma-link.txt (link to Figma)
   â†“
4. Create Figma designs
   â†“
5. Update figma-link.txt with your design URL
   â†“
6. Get approval from product owner
   â†“
7. Hand off to frontend developers
   â†“
8. Respond to questions/clarifications
```

---

## ðŸ“š Related Documents

- `guardrails/design/DESIGN_PROCESS.md` - Full design process (read this for context)
- `templates/design_spec_template.md` - Complete template (reference while filling specs)
- `guardrails/design/DESIGN_ASSET_SUBMISSION.md` - How to submit design assets (screenshots, Figma links)
- `guardrails/design/FIGMA_MCP_INTEGRATION.md` - Auto-generate specs from Figma (recommended!)
- `dev-doc/[feature-name]/design/` - All design specs (example structure)
- `workflows/ui_frontend_workflow.md` - How frontend uses your specs
- `guardrails/design/VISUAL_DESIGN_INTEGRATION.md` - System overview

---

## âœ¨ Remember

- Specs are the **source of truth** for frontend developers
- More specific = less confusion = faster development
- Document everything visual (colors, fonts, spacing)
- Show all interactive states
- Accessibility is not optional
- Frontend developers will thank you for clear, detailed specs! ðŸ™Œ

**Happy designing!**

