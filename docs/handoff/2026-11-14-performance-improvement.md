# Improve Pennino performance

- Goal: identify and improve a measurable Pennino performance bottleneck
  without changing expected behavior.
- Owner: Copilot.
- State: shipped in v0.4.29 from `aae50ed`; the performance PR and all release
  gates passed.

## Log

- User asked to improve performance after v0.4.28. The release record PR #68
  subsequently merged as `acba5da` after Android, Linux, and Windows checks
  passed.
- Measured the raster paint baseline with 1,000 encoded tile keys and a fixed
  viewport on page 500: the painter's key scan visited all 1,000 keys (the
  `tileKeys` getter also materialized the full list before painting).
- Added a per-page tile-key index and clip-bounded lookup. The editor painter
  now uses that lookup for both missing-tile requests and resident-tile draws;
  page queries and preview painting also avoid scanning unrelated resident
  tiles.
- The same instrumented case now visits zero global keys, yields one visible
  key, and reads zero resident-map entries. This is a deterministic operation
  count, not a wall-clock benchmark.
- Verification passed:
  - `flutter test test\\raster_drawing_test.dart` (26 tests)
  - `flutter analyze lib\\raster_drawing.dart lib\\main.dart test\\raster_drawing_test.dart`
  - `git diff --check`
- PR #69 (`d8f829e`), version-bump PR #70 (`aae50ed`), and the post-merge CI
  runs all passed. The v0.4.29 Android and Windows assets were verified after
  publication.

## Running now

- Nothing.

## Next

- A wall-clock benchmark on representative devices would be needed to claim
  improved frame time.

## Don't repeat

- The previous raster painter eagerly enumerated all tile keys and all resident
  images for each paint, even when the viewport reached one page.
- Do not claim a wall-clock speedup from the operation-count test; it proves
  less per-paint traversal, not a particular frame-time improvement.
