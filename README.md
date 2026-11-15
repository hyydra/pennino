# Pennino

Handwriting-first, local-first notes for Android and Windows.

[![Latest release](https://img.shields.io/github/v/release/hyydra/pennino)](https://github.com/hyydra/pennino/releases/latest)
[![Build Pennino](https://github.com/hyydra/pennino/actions/workflows/android-apk.yml/badge.svg)](https://github.com/hyydra/pennino/actions/workflows/android-apk.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Open the app and start writing: the launcher canvas is ready immediately, with no note to create first. Every note combines handwriting, one typed text document and checklists on a single page. Notes are plain JSON files on your device, and Android and Windows can optionally keep them in sync through a Google Drive folder.

## Download

| Platform | File | Notes |
| --- | --- | --- |
| Windows | [Pennino-Windows-Setup.exe](https://github.com/hyydra/pennino/releases/latest/download/Pennino-Windows-Setup.exe) | Per-user installer with Start menu entry and uninstall support. Windows SmartScreen may warn because the installer is not code-signed yet. |
| Android | [Pennino-Android.apk](https://github.com/hyydra/pennino/releases/latest/download/Pennino-Android.apk) | Universal APK for phones and tablets. |

All versions and release notes are on the [releases page](https://github.com/hyydra/pennino/releases). Linux builds are experimental and checked in CI only; no Linux download is published.

## What it does

**Write and draw**
- Pencil, pen, highlighter, a pixel-blur brush, a segment eraser, and undo/redo.
- Drawings are fixed canvas pixels: they cannot be selected or moved, and the eraser removes only the section you brush.
- Stylus pressure and tilt are recorded.

**Type**
- One typed document per note, laid out in a column at the top of the page. It grows downward and adds pages as you write.
- Bold, colour, size and indentation apply to the selection or to the document default. Checklists, bullets and numbered lists are paragraphs inside the text: Enter in a list starts the next item, and Enter on an empty item ends the list. Checklist ticks are drawn in the text's own colour and size, never blue.
- Press a letter to start editing in place. The toolbar is always a single compact row of flat round buttons: the text row while you type (with the font size and a dropdown caret), the ink row while you draw, and the tool in hand highlighted.

**Move around the page**
- Text always wraps at a phone's page width (400 logical pixels), so a note reads the same on every device. On a bigger screen a thin vertical line marks that width, and the space to its right is free for drawing. The home-screen widget shows exactly that phone-width page, top-aligned and never stretched.
- The page is as wide as your screen. There is nothing to scroll sideways, and the top edge is a firm stop. A drawing made on a wider screen keeps its width, and you pan sideways to reach it.
- Text is the tool you start in. Press a letter to edit in place, press blank paper and drag to move the page, and tap blank paper to put the caret at the end. Nothing draws until you choose a drawing tool: use **Drawing tools** on the text row to switch to a single row with Pencil, Pen, Highlighter, Eraser and Blur, which draw with a finger, stylus or mouse. Choose the active tool again to go back to text. Two fingers pan and zoom in any tool, and so does the mouse wheel. Pinch to zoom from 1× to 5×.
- Scrolling to the bottom adds one page. Zooming and scrolling up never do. The page count is saved with the note, and the current page shows in a fixed chip at the top-left of the view.

**Organise**
- A library of local notes, opened with the house button at the top left, plus the launcher canvas that opens first.
- Per-note background (white, cream, blue, green, red or dark) and paper pattern (plain, lined, grid or dotted).

**Keep it safe**
- Background autosave after every change. The toolbar changes only if saving fails.
- Versioned JSON files with atomic replacement, a previous-version backup and recovery after an interrupted write.
- Notes live in the app's documents folder under `Pennino/notes`; notes from the older `notes` folder are copied over once.

**Sync (optional)**
- Android: choose a writable Google Drive location with the system folder picker. Windows: choose the Google Drive for Desktop root.
- Pennino uses the same visible `Pennino/notes` folder on every device and syncs both ways at startup and after each save. When the same note exists on both sides, the later update wins. No Google Cloud API key is needed.

**Android home-screen widget**
- Open a note, choose **Update home widget**, then add the Pennino widget from the launcher. It shows the top of the last note you pinned at the phone's page width, resizes from a compact card to a full page, and opens the launcher canvas when tapped. It is not a per-widget note picker yet.

**Updates**
- The app checks for a newer release on every start and shows an update row above the toolbar only when one exists. Downloads are verified against the release's SHA-256 digest before they are handed to the installer.

## Build from source

Requirements:

- [Flutter](https://docs.flutter.dev/get-started/install) stable (CI pins 3.47.5).
- Android builds: Android Studio and the Android SDK.
- Windows builds: Visual Studio with the *Desktop development with C++* workload.
- Linux builds: Clang, CMake, Ninja, pkg-config and the GTK 3 development libraries.

```bash
flutter pub get
flutter run -d windows      # or: -d linux, -d <android-device-id>
flutter build apk --release
flutter build windows --release
```

The Android and Windows projects are checked in; do not recreate them. The Linux project is generated in CI and locally with `flutter create --platforms=linux .`.

## Develop

```bash
flutter analyze
flutter test                                    # unit and widget suites in test/
flutter test widget_test/editor_gesture_test.dart
```

CI runs the same checks on Android, Linux and Windows for every pull request and push to `main`.

| Path | Contents |
| --- | --- |
| `lib/main.dart` | App shell, library, and the editor with its toolbars and gestures |
| `lib/pennino_theme.dart` | The dark, high-contrast theme and its palette |
| `lib/raster_drawing.dart` | Tiled raster storage for drawings |
| `lib/note_data.dart`, `note_store.dart`, `note_storage.dart` | Note model, JSON persistence and storage folders |
| `lib/drive_sync_service.dart` | Google Drive folder sync |
| `lib/update_service.dart` | In-app update check and verified download |
| `android/`, `windows/`, `installer/` | Platform projects, the widget, and the Inno Setup script |
| `docs/` | Build ledger and handoff notes |

## Releases

Pushing a version tag such as `v0.4.30` runs the release workflow, which builds both assets and publishes them as a GitHub Release:

- `Pennino-Android.apk`
- `Pennino-Windows-Setup.exe`

A release needs the version bumped in `pubspec.yaml` (`version: x.y.z+build`) and a Fastlane changelog named after the build number in `fastlane/metadata/android/en-US/changelogs/`. Android signing needs four repository secrets: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`. Keep the original keystore backed up permanently, because Android updates must be signed with the same key.

Each published build is recorded in [docs/BUILDS.md](docs/BUILDS.md) after its assets are downloaded and their digests recomputed. The project history is in [docs/HANDOFF.md](docs/HANDOFF.md).

## Open-source software

Pennino is MIT-licensed and builds on these direct dependencies, each under its own licence:

- [Flutter](https://github.com/flutter/flutter): application framework (BSD-3-Clause)
- [crypto](https://pub.dev/packages/crypto): SHA-256 verification of updates (BSD-3-Clause)
- [draw_your_image](https://github.com/chooyan-eng/draw_your_image): stylus pressure and tilt model, unsmoothed stroke paths (Apache-2.0)
- [file_selector](https://github.com/flutter/packages/tree/main/packages/file_selector): native file and folder picking (BSD-3-Clause)
- [path_provider](https://github.com/flutter/packages/tree/main/packages/path_provider/path_provider): platform data paths (BSD-3-Clause)
- [uuid](https://github.com/Daegalus/dart-uuid): note identifiers (MIT)

The app's **Open-source software** menu lists these and opens Flutter's full generated licence catalogue, including transitive dependencies.

Android application ID: `com.hyydra.pennino`.
