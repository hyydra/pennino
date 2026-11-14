# Improve Pennino performance

- Goal: identify and improve a measurable Pennino performance bottleneck
  without changing expected behavior.
- Owner: Copilot.
- State: implemented and committed as `eb63b71` on
  `perf/raster-paint-visible-tiles`; now proceeding through the v0.4.29
  release gates.

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

## Running now

- Review the final change set on `perf/raster-paint-visible-tiles`.

## Next

- If broader validation is desired, run the full Flutter suite; the targeted
  raster suite and analysis already pass.
- Decide whether to publish a performance PR separately from v0.4.28.

## Don't repeat

- The previous raster painter eagerly enumerated all tile keys and all resident
  images for each paint, even when the viewport reached one page.
- Do not claim a wall-clock speedup from the operation-count test; it proves
  less per-paint traversal, not a particular frame-time improvement.
