# T002 Implementation Plan

## Changes

Modify only `cg.Lab2/matrix.swift`.

Replace every occurrence of:

`M_PI`

with:

`Double.pi`

Preserve the surrounding expressions, signs, matrix values, branches, and existing implementation structure.

Do not introduce helpers or perform unrelated refactoring.

## Validation

1. Confirm no `M_PI` references remain:

   `rg -n '\bM_PI\b' cg.Lab2`

2. Perform a clean simulator build with Xcode 26.6:

   `xcodebuild -project cg.Lab2.xcodeproj -scheme cg.Lab2 -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/3dlab-t002-derived-data CODE_SIGNING_ALLOWED=NO clean build`

3. Verify:
   - build succeeds
   - no `M_PI` deprecation warnings remain
   - diff contains only the intended constant substitutions

4. Launch the application in the simulator and verify the X, Y, and Z rotation controls continue to rotate in the expected directions.

## Constraints

- Do not address the unrelated App Intents metadata warning.
- Do not modify Xcode project settings.
- Do not perform unrelated modernization or refactoring.
