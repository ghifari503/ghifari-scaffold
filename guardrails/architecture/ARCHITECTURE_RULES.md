# ARCHITECTURE_RULES

## Preferred Principles
- keep modules explicit
- avoid unnecessary framework complexity
- prefer observable sync flows
- make failure states visible
- favor idempotent operations
- architecture decisions must map to a concrete development folder route

## Implementation Constraints
TBD

## Data Rules
- identify authoritative source
- define sync direction
- define conflict policy
- define retry rules
- define reconciliation rules

## Security Rules
- secrets never committed
- validate all external input
- use role boundaries
- log important administrative actions

## Operational Rules
- support rollback
- use traceable logs for critical flows
- define error ownership per module

## Development Routing Rules
- every approved architecture must define `architecture_style`
- every approved architecture must define `development_route`
- builder phases may only create folders from the approved route
- do not scaffold both monolith and microservice layouts in the same implementation path unless the founder explicitly approves a hybrid/custom structure
- preferred routing reference: `guardrails/development/DEVELOPMENT_STRUCTURE_ROUTING.md`

