# Figma MCP Integration Guide

How to use Figma MCP (Model Context Protocol) to automatically fetch design context, screenshots, and component metadata directly from Figma into your design specs.

Compatibility note:
- This guide applies to the active supported runtime (Codex/GPT, Claude, or Gemini) when the environment has Figma MCP tools available.
- Mentions of "Claude" below should be read as "the active agent (Claude or Codex)" unless the text is explicitly about Claude-specific setup.

---

## ðŸŽ¯ What is Figma MCP?

**MCP = Model Context Protocol**

It's a protocol that allows Claude to directly read from Figma files without manual exporting. Benefits:

âœ… Auto-generate screenshots from Figma designs  
âœ… Extract design specs (colors, typography, spacing)  
âœ… Get component metadata (variants, properties)  
âœ… Keep design & docs in sync automatically  
âœ… No manual export/import workflow  
âœ… Real-time design updates  

---

## ðŸ”§ Prerequisites

### Required
1. **Figma Account** - With access to design files
2. **Figma File** - Published or accessible design
3. **Claude** - With Figma MCP enabled

### Optional
- Design System library in Figma
- Component variants in Figma
- Design tokens/variables in Figma

---

## ðŸ“ Getting Figma File Key & Node ID

### Step 1: Get File Key

**From Figma URL:**
```
https://www.figma.com/design/ABC123DEF456/My-Design-File?node-id=10:45
                              ^^^^^^^^^^^^^^
                              This is File Key
```

**How to get:**
1. Open Figma design file
2. Look at URL bar
3. Copy text between `/design/` and `/`
4. That's your file key

### Step 2: Get Node ID

**From Figma URL:**
```
https://www.figma.com/design/ABC123DEF456/My-Design-File?node-id=10:45
                                                                    ^^^^^
                                                                    This is Node ID
```

**Or:**
1. Select frame/component in Figma
2. Right-click â†’ "Copy link to selection"
3. Extract `node-id=` value from URL
4. Format: Convert `-` to `:` if needed (e.g., `10-45` â†’ `10:45`)

### Step 3: Store in figma-link.txt

```
Figma Design File
================
Project: MyApp Authentication
File: Auth-Flows-v2
Page: Login Form

URL: https://www.figma.com/design/ABC123DEF456/Auth-Flows-v2?node-id=10:45

FileKey: ABC123DEF456
NodeId: 10:45

Designer: Sarah Chen
Last Updated: 2026-04-07
Status: Ready for Sync
```

---

## ðŸ”— MCP Tools Available

### 1. get_design_context
**Purpose:** Fetch complete design specification and screenshot

**Input:**
```
fileKey: "ABC123DEF456"
nodeId: "10:45"
clientLanguages: "typescript" (or your language)
clientFrameworks: "react" (or your framework)
```

**Output:**
```
âœ“ Screenshot (PNG image)
âœ“ Design specs (colors, spacing, typography)
âœ“ Component metadata
âœ“ Code suggestions (Tailwind/styled-components)
âœ“ Asset download URLs
âœ“ Design annotations
```

**Use Case:** Get complete design context for a component

---

### 2. get_screenshot
**Purpose:** Get screenshot of a specific Figma node

**Input:**
```
fileKey: "ABC123DEF456"
nodeId: "10:45"
```

**Output:**
```
âœ“ Screenshot PNG
âœ“ Dimensions (width, height)
âœ“ Transparency info
```

**Use Case:** Auto-generate asset screenshots for all states

---

### 3. get_metadata
**Purpose:** Get structural metadata (layers, components, positions)

**Input:**
```
fileKey: "ABC123DEF456"
nodeId: "10:45"
```

**Output:**
```
âœ“ Node names and hierarchy
âœ“ Node types (frame, component, text, etc)
âœ“ Positions and dimensions
âœ“ Visibility states
```

**Use Case:** Document page structure and component layout

---

### 4. get_variable_defs
**Purpose:** Extract design tokens/variables from Figma

**Input:**
```
fileKey: "ABC123DEF456"
nodeId: "10:45"
```

**Output:**
```
âœ“ Color variables (e.g., primary: #0066FF)
âœ“ Typography variables
âœ“ Spacing variables
âœ“ Shadow variables
```

**Use Case:** Auto-populate design.md color palette, typography

---

### 5. get_code_connect_map
**Purpose:** Get Code Connect mappings (design â†” code links)

**Input:**
```
fileKey: "ABC123DEF456"
nodeId: "10:45"
```

**Output:**
```
âœ“ Component name in code
âœ“ Source file path
âœ“ Figma component ID
```

**Use Case:** Link Figma components to codebase components

---

### 6. search_design_system
**Purpose:** Search design system components and variables

**Input:**
```
query: "button" (or "primary color", etc)
fileKey: "ABC123DEF456"
```

**Output:**
```
âœ“ Matching components
âœ“ Variable definitions
âœ“ Styles/variants
âœ“ Library information
```

**Use Case:** Find design system components to reuse

---

## ðŸ’¡ Practical Workflows

### Workflow 1: Auto-Generate Design Specs from Figma

**Goal:** Claude fetches design from Figma and fills design.md automatically

**Steps:**
1. Designer creates Figma design with all details
2. Store Figma URL + file key in `figma-link.txt`
3. Run Claude with Figma MCP:
   ```
   Tool: get_design_context
   Input: fileKey, nodeId
   Output: Screenshot + design specs
   ```
4. Claude auto-fills `design.md`:
   ```markdown
   # design.md
   
   ## ðŸŽ¨ Design System
   - Primary: #0066FF (from Figma)
   - Typography: Inter 16px (from Figma)
   - Spacing: 16px (from Figma)
   
   ## Screenshot
   [Screenshot auto-downloaded from Figma]
   ```
5. Result: Specs filled automatically! âœ…

---

### Workflow 2: Auto-Generate Screenshots for All States

**Goal:** Claude fetches all component states from Figma variants

**Steps:**
1. Designer creates Figma component with variants:
   - Button / Default
   - Button / Hover
   - Button / Active
   - Button / Disabled
   - Button / Loading
2. Store Figma component key in `figma-link.txt`
3. Run Claude loop:
   ```
   For each variant:
     Tool: get_screenshot
     Input: fileKey, nodeId of variant
     Output: Screenshot PNG
     Save to: assets/state-[variant-name].png
   ```
4. Result: All state screenshots auto-generated! âœ…

**No manual exporting needed!**

---

### Workflow 3: Map Design System Components to Code

**Goal:** Link Figma components to codebase components automatically

**Steps:**
1. Designer builds Figma design system library
2. Developer sets up Code Connect in Figma
3. Run Claude:
   ```
   Tool: get_code_connect_map
   Input: fileKey, design system node
   Output: Component â†’ Code mappings
   ```
4. Claude creates Code Connect metadata:
   ```javascript
   // components/Button.tsx
   // figma: https://figma.com/.../nodeId=123:456
   ```
5. Result: Design â†” Code linked automatically! âœ…

---

### Workflow 4: Extract Design Tokens Automatically

**Goal:** Get all design tokens from Figma variables

**Steps:**
1. Designer creates Figma variables:
   - Color/Primary: #0066FF
   - Color/Success: #00AA00
   - Spacing/Base: 8px
   - Typography/Body: Inter Regular 16px
2. Run Claude:
   ```
   Tool: get_variable_defs
   Input: fileKey
   Output: All variables with values
   ```
3. Claude auto-populates design.md:
   ```markdown
   ## Color Palette
   - Primary: #0066FF (color/primary)
   - Success: #00AA00 (color/success)
   
   ## Typography
   - Body: Inter Regular 16px (typography/body)
   ```
4. Result: Design tokens synced! âœ…

---

## ðŸš€ Implementation: Step by Step

### Step 1: Setup Figma Design File

In your Figma file:

```
Figma Project
â”œâ”€â”€ Authentication
â”‚   â””â”€â”€ Login Form
â”‚       â”œâ”€â”€ Frame: "Login Form Default"
â”‚       â”œâ”€â”€ Component: "Button / Primary"
â”‚       â”‚   â”œâ”€â”€ Variant: "Default"
â”‚       â”‚   â”œâ”€â”€ Variant: "Hover"
â”‚       â”‚   â”œâ”€â”€ Variant: "Disabled"
â”‚       â”‚   â””â”€â”€ Variant: "Loading"
â”‚       â””â”€â”€ Variable: Color/Primary = #0066FF
â”‚
â””â”€â”€ [Your other pages...]
```

**Requirements:**
- âœ“ All components created
- âœ“ All variants defined
- âœ“ Design variables/tokens set up
- âœ“ File is shared/accessible

---

### Step 2: Get Figma File Key & Node IDs

```
Project: Authentication
File: https://www.figma.com/design/ABC123/Auth-System?node-id=10:45

FileKey: ABC123
NodeIds:
  - Login Form: 10:45
  - Button Default: 10:50
  - Button Hover: 10:51
  - Button Disabled: 10:52
  - Button Loading: 10:53
```

---

### Step 3: Store in figma-link.txt

**File:** `dev-doc/authentication/design/login/form/figma-link.txt`

```
Figma Design File
================
Project: Authentication System
File: Auth-System
Page: Login

URL: https://www.figma.com/design/ABC123/Auth-System?node-id=10:45

FileKey: ABC123
NodeIds:
  - Form Container: 10:45
  - Button Primary: 10:50
  - Button Variant Hover: 10:51
  - Button Variant Disabled: 10:52
  - Button Variant Loading: 10:53
  - Input Field: 10:60
  - Error Message: 10:61

Designer: Sarah Chen
Last Updated: 2026-04-07
Status: Ready for MCP Sync

Notes:
- Component library: Design System v1.2
- All variants created
- Design tokens available
- Code Connect mappings ready
```

---

### Step 4: Run Claude with Figma MCP

**Request:**
```
"Fetch my Figma design and auto-generate design specs

FileKey: ABC123
NodeId: 10:45 (login form)

Use MCP to:
1. Get design context (colors, spacing, typography)
2. Get screenshots of all button variants
3. Extract design variables/tokens
4. Fill design.md with fetched specs
5. Save screenshots to assets/

Then show me the results."
```

**What Claude Does:**
```
1. Tool: get_design_context
   â†’ Fetches: Screenshot, design specs, metadata
   â†’ Output: Screenshot.png, colors, fonts, spacing

2. Tool: get_screenshot
   For each button variant:
   â†’ Button/Default â†’ state-default.png
   â†’ Button/Hover â†’ state-hover.png
   â†’ Button/Disabled â†’ state-disabled.png
   â†’ Button/Loading â†’ state-loading.png

3. Tool: get_variable_defs
   â†’ Fetches: All design variables
   â†’ Output: Colors, typography, spacing values

4. Fills: design.md
   - Colors section (from variables)
   - Typography section (from variables)
   - Layout section (from design context)
   - Components section (from metadata)

5. Saves: assets/state-*.png files
```

**Result:**
```
âœ“ design.md filled automatically
âœ“ All screenshots in assets/
âœ“ Design variables documented
âœ“ Zero manual work!
```

---

## ðŸ“‹ Complete Example: Login Form

### Figma Setup

```
Figma File: Authentication System
Page: Login Form

Design:
â”œâ”€â”€ Frame: "Login - Default State"
â”‚   â”œâ”€â”€ Component: Input Field
â”‚   â”œâ”€â”€ Component: Submit Button (primary)
â”‚   â”œâ”€â”€ Text: "Forgot password?" (link)
â”‚   â””â”€â”€ Checkbox: "Remember me"
â”‚
â”œâ”€â”€ Frame: "Login - Error State"
â”‚   â”œâ”€â”€ Input Field (with red border)
â”‚   â”œâ”€â”€ Error Message (red text)
â”‚   â””â”€â”€ Submit Button
â”‚
â”œâ”€â”€ Frame: "Login - Loading State"
â”‚   â”œâ”€â”€ Submit Button (disabled)
â”‚   â””â”€â”€ Loading Spinner
â”‚
â””â”€â”€ Design Tokens:
    â”œâ”€â”€ Color/Primary: #0066FF
    â”œâ”€â”€ Color/Error: #FF4444
    â”œâ”€â”€ Typography/Body: Inter Regular 16px
    â””â”€â”€ Spacing/Base: 8px
```

### Figma Link Storage

**File:** `figma-link.txt`
```
FileKey: ABC123DEF456
NodeIds:
  - Login Default: 10:45
  - Login Error: 10:46
  - Login Loading: 10:47
  - Input Field: 10:50
  - Button Primary: 10:60
```

### Claude MCP Request

```
Fetch login form design from Figma and fill specs:

FileKey: ABC123DEF456
NodeId: 10:45 (Login form frame)

Tasks:
1. get_design_context â†’ Screenshot + specs
2. get_screenshot for NodeId 10:46 â†’ error state
3. get_screenshot for NodeId 10:47 â†’ loading state
4. get_variable_defs â†’ All design tokens
5. Populate design.md sections:
   - Colors (from variables)
   - Typography (from variables)
   - Components (from metadata)
   - States (from screenshots)
6. Save all screenshots to assets/
```

### Auto-Generated design.md

```markdown
# Login Form - Design Specification

## ðŸŽ¨ Design System

### Color Palette
- Primary: #0066FF (from Figma variable: color/primary)
- Error: #FF4444 (from Figma variable: color/error)
- ...

### Typography
- Body: Inter Regular 16px (from Figma variable: typography/body)
- ...

## ðŸ§© Components

### Input Field
- Type: Text Input
- States: default, focused, error, disabled
- [Image from Figma]

### Submit Button
- Type: Primary Button
- States: default, hover, disabled, loading
- [Images from Figma variants]

## ðŸ“¸ Screenshots

### Default State
![Login Default](assets/state-default.png)
*Auto-generated from Figma node 10:45*

### Error State
![Login Error](assets/state-error.png)
*Auto-generated from Figma node 10:46*

### Loading State
![Login Loading](assets/state-loading.png)
*Auto-generated from Figma node 10:47*
```

### Result: All Auto-Generated! âœ…

- âœ“ Colors populated from Figma variables
- âœ“ Typography populated from Figma variables
- âœ“ Screenshots auto-saved to assets/
- âœ“ Component metadata extracted
- âœ“ States documented
- âœ“ Zero manual work!

---

## ðŸŽ¯ Benefits

### For Designer
- Design changes auto-sync to docs
- No manual export/import workflow
- Version history in Figma = version history in docs
- Real-time collaboration

### For Developer
- Latest design always available
- Screenshots stay in sync with Figma
- Can directly reference Figma design
- Component metadata available

### For Product Owner
- Visual design always up-to-date
- Design specs auto-generated
- Less time on documentation
- More time on building

### For QA
- Screenshots for testing
- Design tokens for validation
- Can reference live Figma design
- State documentation complete

---

## âš™ï¸ Advanced: Code Connect Integration

### What is Code Connect?

Link Figma components directly to code components.

**In Figma:**
```
Component: Button / Primary
```

**In Code:**
```jsx
// components/Button.tsx
/* figma: https://figma.com/.../nodeId=10:60 */
export function Button({ ... }) { ... }
```

**With MCP:**
```
Tool: get_code_connect_map
Input: Figma component
Output: Linked code component
```

**Result:** Figma component links directly to code!

```figma
Button / Primary (Figma) â†” Button.tsx (Code)
```

---

## ðŸ” Permissions & Security

### Who Can Access?
- Figma file must be shared with team
- Design read-only access for developers
- Edit access for designers only

### What Claude Sees?
- Design specs (colors, spacing, typography)
- Component structure
- Screenshots
- Design variables/tokens
- No sensitive data unless in design

### Privacy
- Figma link is public (you choose)
- Screenshots are stored in git
- Design tokens are in markdown (version controlled)

---

## ðŸš€ Getting Started

### Checklist

- [ ] Figma design created
- [ ] File is shared/accessible
- [ ] File key & node IDs extracted
- [ ] Stored in figma-link.txt
- [ ] Design tokens/variables created in Figma
- [ ] Component variants created (if doing states)
- [ ] Figma MCP enabled in Claude
- [ ] Ready for sync!

### Try It Now

1. Open your Figma design
2. Copy file key from URL
3. Create `figma-link.txt` with file key
4. Tell Claude:
   ```
   "Fetch my Figma design using MCP
   FileKey: [your-key]
   NodeId: [node-id]"
   ```
5. Claude auto-generates your design specs! âœ…

---

## ðŸ“š Related Documentation

- `guardrails/design/DESIGN_ASSET_SUBMISSION.md` - Asset submission guide
- `guardrails/design/DESIGNER_QUICK_START.md` - Designer workflow
- `guardrails/design/DESIGN_PROCESS.md` - Full design process
- `templates/design_spec_template.md` - Design spec template

---

## ðŸ†˜ Troubleshooting

### Issue: "File not accessible"
**Solution:** Check Figma file sharing settings. File must be public or shared with Claude.

### Issue: "Node ID not found"
**Solution:** Copy exact node ID from Figma URL. Format: `10:45` (not `10-45`)

### Issue: "Screenshot blank"
**Solution:** Make sure node/frame contains visible content. Empty frames won't show.

### Issue: "Variables not found"
**Solution:** Create variables in Figma first. Must be in Variables panel.

---

**Ready to sync your Figma designs! ðŸŽ‰**

