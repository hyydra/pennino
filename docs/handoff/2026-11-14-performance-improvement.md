# Improve Pennino performance

- Goal: identify and improve a measurable Pennino performance bottleneck
  without changing expected behavior.
- Owner: Copilot.
- State: started after v0.4.28 was published; no performance baseline or
  optimization has been selected yet.

## Log

- User asked to try improving performance after the v0.4.28 release.
- Release v0.4.28 is live with verified Android and Windows assets; details
  are in [publish-v0-4-28](./2026-11-14-publish-v0-4-28.md).

## Running now

- Inspect existing tests and implementation for performance-sensitive paths,
  then establish a measurable baseline before choosing an optimization.

## Next

- Implement one focused optimization, add a relevant regression or benchmark,
  and compare the result against the baseline.

## Don't repeat

- Do not infer the hot path from code shape alone; measure before changing it.
- Keep performance changes separate from the published v0.4.28 release.
