# STARTUP_MODE_GUIDE

Choose one primary mode and adapt flows accordingly.

This file defines the available startup modes and their intended usage.
The current selected mode must be recorded separately in `artifacts/context/STARTUP_MODE.md`.

## greenfield_project
Use when:
- `development/` has zero target-project folders when the founder sends `start`, excluding only scaffold-owned `_project-template/`
- a new project must be defined and bootstrapped from zero

Focus:
- founder discovery
- minimum requirement baseline for one first feature
- architecture and bootstrap approval
- shared project-state initialization
- one selected implementation slice

Do not use `I1 Existing Project Intake` or `I2 Impact Scan` as substitutes for greenfield discovery. Enforce `guardrails/development/GREENFIELD_PROJECT_POLICY.md`.

## software_saas
Use when:
- cloud-first product
- mostly online users
- account-based usage

Focus:
- onboarding
- billing
- feature adoption
- analytics
- permissions

## software_iot_sync
Use when:
- local device/client interacts with cloud
- connectivity may be unstable
- sync, activation, device identity matter

Focus:
- activation
- offline queue
- retry
- duplicate handling
- local/cloud authority
- field release checklist

## internal_ops_system
Use when:
- system is used mostly by internal operators/admins

Focus:
- permissions
- data accuracy
- audit trail
- workflow efficiency

## ai_marketing_engine
Use when:
- product creates content/campaign assets with AI

Focus:
- prompt consistency
- dataset governance
- output quality
- review loop
