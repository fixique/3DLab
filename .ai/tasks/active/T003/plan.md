# T003 Implementation Plan

## Goal

Replace the storyboard-based main screen with an adaptive programmatic UIKit layout while preserving the existing 3D rendering and all button-driven interactions.

## Changes

### App launch

Update `AppDelegate.swift` to create the application window programmatically.

- Create a `UIWindow`.
- Set `ViewController()` as the root view controller.
- Call `makeKeyAndVisible()`.
- Keep the existing pre-scene application lifecycle.
- Do not introduce `SceneDelegate`.

### Main view

Update `ViewController.swift`.

Replace the storyboard outlet with an owned programmatic `UIImageView`.

Construct the interface programmatically using Auto Layout and UIKit layout primitives.

Suggested structure:

- root vertical `UIStackView`, pinned to the safe area
  - flexible drawing region containing the `UIImageView`
  - controls region

Controls should be grouped using stack views:

- translation row: 6 buttons
- operation area: 4 equal-width vertical groups
  - reflection: 4 buttons
  - scale: 6 buttons
  - rotation: 6 buttons
  - projection: 6 buttons

Use:

- safe-area constraints
- adaptive widths
- compact spacing
- button heights appropriate for touch interaction
- title sizing that keeps the existing Russian button labels readable

Do not use absolute screen coordinates for layout.

### Button wiring

Recreate all existing buttons programmatically.

Preserve the existing action behavior and selector mappings.

Translation:
- `transferUp`
- `transferDown`
- `transferRight`
- `transferLeft`
- `transferForward`
- `transferBack`

Rotation:
- `oxRotationBack`
- `oxRotationForward`
- `oyRotationBack`
- `oyRotationForward`
- `ozRotationForward`
- `ozRotationBack`

Projection:
- `yzProjection`
- `xzProjection`
- `xyProjection`
- `pYZ`
- `pXZ`
- `pXY`

Scale:
- `xScale`
- `xScaleMin`
- `yScale`
- `yScaleMin`
- `xyScale`
- `xyScaleMin`

Reflection:
- `reflectXOZ`
- `reflectYOZ`
- `reflectXOY`
- `reflectBySide`

Connect buttons with `addTarget(_:action:for:)`.

Existing action bodies should remain unchanged unless required for programmatic wiring.

### Adaptive rendering

Remove assumptions about the fixed `1024x691` drawing surface.

The bitmap context must use the laid-out `imageView.bounds.size`.

The drawing origin must be derived from the viewport center instead of fixed coordinates.

Initial centering should be based on the initial projected model.

Do not recenter the model after every transformation, because that would hide translation behavior.

Initial homogeneous-coordinate conversion must still happen exactly once.

Layout changes and device rotation may redraw the current model, but must not reset or reconvert it.

### Remove Main.storyboard dependency

Update `Info.plist`:

- remove `UIMainStoryboardFile`

Update `cg.Lab2.xcodeproj/project.pbxproj`:

- remove all references to `Main.storyboard`
- remove its resource build entry
- remove its variant group / group membership

Delete:

- `cg.Lab2/Base.lproj/Main.storyboard`

Keep `LaunchScreen.storyboard` unchanged.

## Files expected to change

- `cg.Lab2/AppDelegate.swift`
- `cg.Lab2/ViewController.swift`
- `cg.Lab2/Info.plist`
- `cg.Lab2.xcodeproj/project.pbxproj`
- delete `cg.Lab2/Base.lproj/Main.storyboard`

Expected unchanged:

- `cg.Lab2/matrix.swift`
- `cg.Lab2/Base.lproj/LaunchScreen.storyboard`
- assets

## Validation

### Build

Build with Xcode 26.6.

Verify:

- build succeeds
- `Main.storyboard` is no longer compiled
- built application has no `UIMainStoryboardFile`
- built application contains no `Main.storyboardc`
- `LaunchScreen.storyboardc` remains present

### Runtime

Install and launch on iPad simulators.

Test portrait and landscape layouts.

Verify:

- application launches successfully
- no blank root window
- all 28 buttons are visible
- controls stay inside the safe area
- no buttons are clipped
- long Russian titles remain usable
- the initial 3D M is visually centered in the drawing region
- the drawing surface adapts to the available size
- rotation does not reset the current transformed model

Exercise the existing interaction categories:

- translation
- rotation
- scale
- projection
- reflection

Existing transformation behavior must remain unchanged.

## Scope constraints

Do not:

- migrate to SwiftUI
- introduce SceneDelegate
- modify `matrix.swift`
- refactor transformation or projection algorithms
- perform unrelated architecture cleanup
- permanently recenter the model after user transformations
