# Microservice Development Structure

Use this blueprint when the approved architecture style is `microservice`.

## Target Structure

```text
development/
├── services/
│   ├── api-gateway/
│   ├── auth-service/
│   ├── billing-service/
│   └── [service-name]/
├── apps/
│   └── web/
├── packages/
│   ├── ui/
│   ├── contracts/
│   ├── shared/
│   └── config/
└── infra/
```

## Builder Routing

- frontend-builder -> `development/apps/web/`
- backend-builder -> `development/services/[service-name]/`

## When To Use

- separate deployables needed
- domain isolation is important
- operational complexity is justified
