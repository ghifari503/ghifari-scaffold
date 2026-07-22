# data-testid Guidelines

Use stable selectors for automation.

## Recommended Pattern

- `feature-element-purpose`

Examples:
- `login-email`
- `login-password`
- `login-submit`
- `signup-name`
- `checkout-place-order`

## Rules

1. Keep names stable even if layout changes
2. Prefer one test id per interactable target
3. Use semantic roles/labels first when they are reliable
4. Add `data-testid` for:
   - dynamic inputs
   - repeated lists
   - async buttons
   - stateful controls
