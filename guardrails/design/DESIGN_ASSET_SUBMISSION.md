# Design Asset Submission Guide

How to submit design assets such as screenshots, mockups, HTML prototypes, and Figma links for design specifications.

Compatibility note:
- This guide works for Codex/GPT, Claude, and Gemini workflows.
- Any runtime-specific references should be interpreted as the active agent unless a step is explicitly runtime-specific.

---

## Submission Folder Structure

Every active feature-specific design spec folder has an `assets/` subfolder for visual references:

```text
dev-doc/[feature-name]/design/
\-- [page-name]/
    \-- [section-name]/
        \-- [sub-section-name]/
            |-- design.md
            |-- layout.md
            |-- components.md
            |-- interactions.md
            |-- assets/                    <- submit files here
            |   |-- wireframe.png
            |   |-- mockup.png
            |   |-- state-default.png
            |   |-- state-hover.png
            |   |-- state-error.png
            |   |-- state-loading.png
            |   \-- ...
            |-- prototype/                 <- optional HTML UI shell reference
            |   |-- index.html
            |   \-- assets/
            \-- figma-link.txt             <- put the Figma link here
```

---

## What To Submit

### Required Assets

For each design specification, submit:

#### 1. Wireframe
File: `wireframe.png` or `wireframe.svg`

Use it for:
- basic layout and structure
- element placement
- low-fidelity review

Recommended timing:
- early design phase

#### 2. Mockup
File: `mockup.png` or `mockup.svg`

Use it for:
- final visual direction
- colors and typography
- spacing and sizing
- implementation-ready reference

Recommended timing:
- when the screen is ready for implementation

#### 3. State Screenshots
Files: `state-[name].png`

Examples:
- `state-default.png`
- `state-hover.png`
- `state-focused.png`
- `state-active.png`
- `state-disabled.png`
- `state-error.png`
- `state-loading.png`
- `state-success.png`
- `state-empty.png`

Use them for:
- showing interaction and feedback states clearly

#### 4. Optional Component Assets
Files: `[component-name].png`

Examples:
- `button-primary.png`
- `input-field.png`
- `error-message.png`
- `loading-spinner.png`
- `modal-dialog.png`

Use them when:
- one component needs extra clarity outside the full screen mockup

#### 5. Optional HTML UI Prototype
File: `prototype/index.html`

Use it when:
- UI does not exist yet in the target project
- the founder asks for an HTML version, UI shell, clickable-ish guide, or UX reference
- a frontend agent needs a concrete visual/interaction guide before production implementation

Required location:
- `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/prototype/index.html`

Shared reusable baseline location:
- `templates/design/master-ui-templates/[template-name]/prototype/index.html`

Important:
- HTML prototypes are reference artifacts only.
- Do not place them in frontend/backend source code unless an approved development scope explicitly promotes them to production implementation.
- Store prototype-only local assets under `prototype/assets/`.

---

## Supported File Formats

### Recommended Formats

| Format | Extension | Best For |
|---|---|---|
| PNG | `.png` | screenshots and mockups |
| SVG | `.svg` | vectors, icons, diagrams |
| WebP | `.webp` | compressed modern images |
| JPG | `.jpg` | photo-based references |
| HTML | `.html` | isolated UI shell/prototype reference |

Recommendation:
- use PNG for screenshots and mockups unless there is a specific reason to choose another format

### Not Recommended

- PDF
- PSD
- XD
- raw Figma export bundles
- BMP
- TIFF

If the source is Figma, use `figma-link.txt` instead of uploading heavy design source files.

---

## Figma Link Submission

File:
- `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/figma-link.txt`

Suggested format:

```text
Figma Design File
================
Project: [Project Name]
File: [File Name]
Page or Node: [Page Name]

URL: https://www.figma.com/design/[fileKey]/[fileName]?node-id=[nodeId]

Designer: [Name]
Last Updated: YYYY-MM-DD
Status: Draft / In Progress / Ready for Dev / Approved

Notes:
- [Optional design notes]
- [Special instructions]
- [Known constraints or gotchas]
```

### How To Get The Figma Link

1. Open the design in Figma.
2. Select the frame or component you want to reference.
3. Copy the link to that selection.
4. Paste the URL into `figma-link.txt`.

### Example

```text
Figma Design File
================
Project: Authentication System
File: Auth Flows v2
Page or Node: Login

URL: https://www.figma.com/design/abc123XYZ/Auth-Flows-v2?node-id=10:45

Designer: Sarah Chen
Last Updated: 2026-04-07
Status: Approved for Development

Notes:
- Mobile layout uses full width
- Focus state uses custom blue outline #0066FF
- Error animation is 200ms fade-in
- Component library: Design System v1.2
```

---

## Figma MCP Integration

### What It Is

Figma MCP allows the active agent to fetch design context directly from Figma.

Typical capabilities:
- fetch screenshots
- inspect design metadata
- extract component context
- map Figma components to code
- search design system assets

### Recommended Use

1. Save the Figma URL in `figma-link.txt`
2. Include file key and node id if available
3. Let the active agent fetch the design context from the recorded reference

Example:

```text
URL: https://www.figma.com/design/abc123XYZ/Auth-Flows?node-id=10:45
FileKey: abc123XYZ
NodeId: 10:45
```

### Typical Output

- screenshot reference
- design tokens
- spacing and layout hints
- component metadata
- code-oriented implementation context

### Benefits

- keeps design references tied to the correct folder
- reduces manual re-explanation in later sessions
- helps Codex/GPT, Claude, and Gemini stay aligned on the same UI source

