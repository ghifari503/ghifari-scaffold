# FLUTTER_DEVELOPMENT_POLICY

## Purpose
Define how this scaffold handles existing Flutter/Dart projects safely from intake through build, QA, and release preparation.

## Scope
This policy applies when the target project contains Flutter or Dart indicators such as:
- `pubspec.yaml`
- `lib/`
- `test/`
- `integration_test/`
- `android/`
- `ios/`
- `web/`
- `macos/`, `windows/`, or `linux/`

## Core Rule
Do not create, bootstrap, upgrade, or restructure a Flutter app before intake, impact scan, approved scope, and allowed write paths exist.

Flutter work remains blocked when:
- target repo is not attached
- Flutter stack has not been audited
- state management pattern is unknown
- navigation pattern is unknown
- platform targets are unknown
- tests and release route are unknown
- pre-coding gate is not open

## Required Intake Facts
Before Flutter implementation, record:
- Flutter SDK constraint from `pubspec.yaml`
- Dart SDK constraint
- package manager flow (`flutter pub get`, Melos, FVM, custom scripts, or other)
- app roots and package roots
- platform targets: Android, iOS, web, desktop
- state management pattern
- routing/navigation pattern
- networking/API client pattern
- persistence/storage pattern
- localization strategy
- theming/design system
- dependency injection pattern, if any
- flavors/environments
- test stack
- CI/build/release scripts
- signing and release constraints, without storing secrets

## Allowed Flutter Write Areas
Allowed write paths must be explicit and scope-limited.

Common Flutter write areas may include:
- `lib/`
- `test/`
- `integration_test/`
- `assets/`
- `pubspec.yaml` only with explicit dependency approval
- platform folders only when the approved scope requires it

Do not edit these without explicit approval:
- signing files
- certificates
- keystores
- provisioning profiles
- private environment files
- CI secrets
- generated files unless the project convention requires regeneration

## Implementation Rules
- Preserve the existing architecture and state management pattern.
- Preserve existing naming, folder, lint, and formatting conventions.
- Avoid adding dependencies unless impact scan and founder approval justify them.
- Prefer small feature/module slices over broad app rewrites.
- Keep UI behavior, loading, empty, error, offline, and retry states explicit.
- Document API contract changes before backend work.
- Update tests for the impacted feature/module.

## Flutter Commands Policy
Allowed commands depend on the pre-coding gate and approved mode:
- Read-only audit may inspect files and scripts but must not run dependency installation.
- Build/QA mode may run Flutter commands only after the target route and allowed command scope are approved.

Common verification commands:
- `flutter --version`
- `flutter pub get`
- `dart analyze`
- `flutter analyze`
- `flutter test`
- `flutter test integration_test`
- `flutter build apk`
- `flutter build appbundle`
- `flutter build ipa`
- `flutter build web`

Do not run platform release builds or signing-related commands without explicit founder approval.

## QA Requirements
For Flutter changes, QA should cover:
- unit tests
- widget tests
- integration tests when a user flow changes
- analyzer/lint status
- platform smoke checks for each impacted target
- layout checks for relevant screen sizes
- navigation/back behavior
- offline and retry behavior when network or sync is involved
- permission handling when platform APIs are involved

## Release Requirements
Flutter release prep must include:
- target platform list
- build variant/flavor
- version/build number impact
- signing status without secret disclosure
- store submission notes when applicable
- rollback path
- smoke checklist per platform
- known device or OS constraints

## Memory And Registry Rules
After Flutter intake, impact scan, build, QA, or release events:
- update `artifacts/memory/FEATURE_REGISTRY.toml`
- update `artifacts/memory/FEATURE_REGISTRY.md`
- update `artifacts/memory/MEMORY_LEDGER.toml` only for durable cross-session facts
- record Flutter-specific constraints in memory only when they are verified by artifacts or repo evidence
