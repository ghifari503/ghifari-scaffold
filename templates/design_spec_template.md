# Design Specification Template

**Page:** [page-name]
**Section:** [section-name]
**Sub-section:** [sub-section-name]
**Date:** YYYYMMDD
**Designer/Analyst:** [name]
**Figma Link:** [link-to-design]
**Fallback Template Reference:** [master template path or N/A]
**Design Source Mode:** Detailed Spec / Figma / Image Completion / Master Template Fallback / Generated From Product Artifacts

---

## Design Source Trace

- **Primary Source:** [page-specific design.md / figma-link.txt / assets/mockup.png / generated]
- **Secondary Source:** [master template path or N/A]
- **Supporting Product Artifacts:**
  - PRD: [path]
  - Flow: [path]
  - BRD / Scope: [path]
  - Business Context: [path]
- **Generation Notes:**
  - [Why this design source mode was used]
  - [What assumptions were required]

---

## 🎯 Visual Objective

What is this component/section trying to achieve visually?
- User goal
- Visual hierarchy
- Emotional tone

---

## 🎨 Design System

### Color Palette
- **Primary:** [color] `#HEX`
- **Secondary:** [color] `#HEX`
- **Accent:** [color] `#HEX`
- **Background:** [color] `#HEX`
- **Text:** [color] `#HEX`
- **Borders:** [color] `#HEX`
- **Success/Error/Warning:** [colors]

### Typography
- **Heading Font:** [name], weight, size
- **Body Font:** [name], weight, size
- **Caption Font:** [name], weight, size
- **Line Height:** [value]
- **Letter Spacing:** [value]

---

## 📐 Layout & Spacing

### Grid System
- **Grid Type:** 12-column / 8-column / custom
- **Column Width:** [px]
- **Gutter:** [px]
- **Breakpoints:** mobile, tablet, desktop

### Spacing Rules
- **Padding:** [values for different elements]
- **Margin:** [values]
- **Gap:** [between elements]
- **Safe Areas:** [for mobile devices]

### Dimensions
- **Container Width:** [px / percentage]
- **Max Width:** [px]
- **Component Height:** [px / relative]
- **Aspect Ratios:** [e.g., 16:9, 1:1]

---

## 🧩 Components

### Primary Components
- [Component Name]
  - Type: button / input / card / modal / etc
  - States: default, hover, active, disabled, loading, error
  - Size variants: small, medium, large

### Secondary Components
- [List other components used]

### Component Library Reference
- Link to component documentation
- Link to Figma component

---

## ⚙️ Interactions & States

### User Interactions
1. **Hover States**
   - Color change: [description]
   - Scale: [percentage]
   - Shadow: [description]
   - Cursor: [pointer / default / etc]

2. **Click/Active States**
   - Visual feedback: [description]
   - Animation: [duration, easing]
   - Feedback type: ripple / highlight / scale

3. **Focus States (Keyboard Navigation)**
   - Outline: [color, width]
   - Keyboard navigation order: [description]

4. **Disabled States**
   - Opacity: [percentage]
   - Color: [grayscale or specific color]
   - Cursor: [not-allowed]
   - Pointer events: [none]

### Loading States
- Loading indicator: [spinner / skeleton / progress]
- Duration: [estimated timing]
- Message: [optional loading text]

### Error States
- Error message display: [toast / inline / modal]
- Color: [error red]
- Icon: [error icon]
- Animation: [shake / pulse]

### Empty States
- Icon/illustration: [description]
- Message: [text]
- CTA: [action button]

---

## 📱 Responsive Behavior

### Mobile (< 768px)
- Layout changes: [list changes]
- Hidden elements: [what hides]
- Touch targets: [minimum 44x44px]
- Font size adjustments: [if any]

### Tablet (768px - 1024px)
- Layout adjustments: [description]

### Desktop (> 1024px)
- Full layout: [description]

---

## ♿ Accessibility

### WCAG 2.1 Compliance
- **Color Contrast:** [min 4.5:1 for text]
- **Text Alternatives:** [alt text for images]
- **Keyboard Navigation:** [Tab order, focus indicators]
- **ARIA Labels:** [aria-label, aria-describedby]
- **Form Labels:** [associated with inputs]
- **Focus Visible:** [outline on focus]

### Screen Reader Considerations
- Semantic HTML: [use proper tags]
- Hidden content: [use aria-hidden if needed]
- Icon-only buttons: [have aria-label]

---

## 📸 Visual References

### Wireframe
```
[Link to wireframe or ASCII diagram]
```

### Mockup/Prototype
```
[Link to high-fidelity mockup]
```

### State Variations
- State 1 (default): [screenshot or description]
- State 2 (hover): [screenshot or description]
- State 3 (active): [screenshot or description]
- State 4 (disabled): [screenshot or description]
- State 5 (error): [screenshot or description]
- State 6 (loading): [screenshot or description]

---

## 💻 Developer Implementation Notes

### CSS/Styling Approach
- CSS Framework: Tailwind / styled-components / CSS Modules / plain CSS
- Design tokens to use: [token names]
- Custom styles needed: [if any]

### Component Props
```typescript
interface ComponentProps {
  // Props expected by frontend
}
```

### Responsive Implementation
- Mobile-first approach: [yes/no]
- Breakpoint utility classes: [e.g., md:, lg:]
- Flex vs Grid: [recommendation]

### Animation/Transitions
- Framework: Framer Motion / CSS / etc
- Duration: [ms]
- Easing: [ease-in, ease-out, cubic-bezier]

### Browser Support
- Minimum browser versions: [Chrome, Firefox, Safari]
- Polyfills needed: [if any]

---

## 🎯 Design Rationale

Why these design choices?
- User research findings
- Usability considerations
- Brand alignment
- Performance implications

---

## ✅ Checklist for Implementation

- [ ] All states visually specified
- [ ] Responsive behavior documented
- [ ] Accessibility requirements met
- [ ] Component variants documented
- [ ] Developer notes clear
- [ ] Assets provided
- [ ] Design source trace documented
- [ ] Figma design up-to-date
- [ ] Approved by designer

---

## 📝 Design Approval

- **Designer:** [name] - Date: [YYYYMMDD]
- **Product Owner:** [name] - Date: [YYYYMMDD]
- **Status:** Draft / In Review / Approved / In Development

---

## 🔗 Related Documentation

- Related flows: [link to flow docs]
- User stories: [link to PRD]
- Component library: [link to components doc]
- Figma team library: [link]

---

## 🚀 Next Steps

- [ ] Get design approval
- [ ] Start frontend implementation
- [ ] Create component in design system
- [ ] Add unit/visual tests
