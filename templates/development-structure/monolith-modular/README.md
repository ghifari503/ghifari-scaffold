# Monolith Modular Development Structure

Use this blueprint when the approved architecture style is `monolith_modular`.

## Target Structure

```text
development/
├── apps/
│   ├── web/
│   └── api/
├── modules/
│   ├── auth/
│   ├── billing/
│   ├── reporting/
│   └── [feature]/
├── packages/
│   ├── ui/
│   ├── types/
│   ├── config/
│   └── utils/
└── infra/
```

## Builder Routing

- frontend-builder -> `development/apps/web/`
- backend-builder -> `development/apps/api/` and `development/modules/[feature]/`

## When To Use

- MVP
- small team
- one deployable backend
- strong module boundaries without service splitting
