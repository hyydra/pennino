# Pennino builds

Every build that goes up is written down here, newest first. A line means the
artifacts were downloaded from the release and their digests recomputed from
those bytes; a build that is not listed here has not been checked that way.

Releases before v0.4.27 are recorded in their handoff notes rather than here;
the ledger starts with the first build after this habit was asked for.

## 0.4.29+33 - 2026-11-14T22:05:50Z

- Commit `aae50ed`, annotated tag `v0.4.29` (tag object `2274f6d`), release
  run `43645828153` (windows, android, publish all success).
- Android `Pennino-Android.apk`, 53,481,669 B, sha256
  `a70730515fa4d5183c5d55f20eb349d8e1785295eba66ef71339d27eda649125`.
- Windows `Pennino-Windows-Setup.exe`, 10,924,097 B, sha256
  `9fd960afe35a644fb943f2dea51a84f55f52f02ec9df8c8d7af29fb14dbe8cb3`.
- `apkanalyzer`: versionCode 33, versionName 0.4.29. Signer certificate
  SHA-256 `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged from v0.4.28.
- Ships PR #69's raster viewport optimization. The regression case reduced
  painter-wide key visits from 1,000 to one visible key; this is an operation
  count, not a wall-clock benchmark. Record:
  [publish-v0-4-29](./handoff/2026-11-14-publish-v0-4-29.md).

## 0.4.28+32 - 2026-11-14T21:17:09Z

- Commit `5d752ac`, annotated tag `v0.4.28` (tag object `7a31926`), release
  run `43641461164` (windows, android, publish all success).
- Android `Pennino-Android.apk`, 53,481,665 B, sha256
  `61b488f98c12677c060e9fcce6553c27f683dfc01a013c24b5d373467974ec1f`.
- Windows `Pennino-Windows-Setup.exe`, 10,922,440 B, sha256
  `00abab851b4643ae3399dacb2174d84932a38670dd2257b0ce55b454675993cd`.
- `apkanalyzer`: versionCode 32, versionName 0.4.28. Signer certificate
  SHA-256 `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged from v0.4.27.
- The Android binary contains `newer edits were kept` once; v0.4.27 contains
  it zero times. Carries the save-before-quit branch change and PR #66's sync
  race fixes. Record: [publish-v0-4-28](./handoff/2026-11-14-publish-v0-4-28.md).

## 0.4.27+31 - 2026-11-14T12:34:18Z

- Commit `05cc57b`, annotated tag `v0.4.27` (tag object `d28b503`), release
  run `43595032579` (windows, android, publish all success).
- Android `Pennino-Android.apk`, 53,465,285 B, sha256
  `ee9f8d0ef382ca500a393d9a656e24322d36976c7e371cf4a3b24bf2114588bb`.
- Windows `Pennino-Windows-Setup.exe`, 10,911,059 B, sha256
  `36098ebad031ac8f020fd9ba1f12010d86786c2c0f04e33887b754043f7176dc`.
- `aapt`: versionCode 31, versionName 0.4.27. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged from v0.4.26.
- Carries PR #62 (hand pan, pinned page number) and PR #63 (the bump).
  Record: [publish-v0-4-27](./handoff/2026-11-14-publish-v0-4-27.md).
