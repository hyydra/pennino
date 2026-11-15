# Pennino builds

Every build that goes up is written down here, newest first. A line means the
artifacts were downloaded from the release and their digests recomputed from
those bytes; a build that is not listed here has not been checked that way.

Releases before v0.4.27 are recorded in their handoff notes rather than here;
the ledger starts with the first build after this habit was asked for.

## 0.4.32+36 - 2026-11-15T14:30:00Z

- Commit `46b6939`, annotated tag `v0.4.32` (tag object `0d6a655`), release
  run `43724306221` (success).
- Android `Pennino-Android.apk`, 53,498,045 B, sha256
  `5e450005ae919fd4cc582643c362995ce7e44e15ad4e5f691ba86f982a76dd79`.
- Windows `Pennino-Windows-Setup.exe`, 10,932,773 B, sha256
  `da5b08993fbd3873a6c6b63f97a920dfb6810c666698515dca5db0a03b738daa`.
- Carries PR #75: a press on text opens the inline editor from any visible
  line, because the live field's line boxes now decide the hit.

## 0.4.31+35 - 2026-11-15T08:18:04Z

- Commit `98f9fcf`, annotated tag `v0.4.31` (tag object `e9131ba`), release
  run `43693494107` (success).
- Android `Pennino-Android.apk`, 53,498,045 B, sha256
  `35d24a60981846b0ad1980c23c580ced1f714a450a5fc204b0f63dbeaca68906`.
- Windows `Pennino-Windows-Setup.exe`, 10,932,585 B, sha256
  `f7e4fb755db6968438272fe4d2e89df47ecf034c80ac042249a520f0788a4028`.
- Carries PR #74: the flat blue-accent theme, no separate Hand tool (nothing
  draws until a drawing tool is chosen), wide drawings kept reachable, and
  legacy-stroke migration that no longer drops strokes. Superseded the same
  day by 0.4.32, which fixes the text hit-test.

## 0.4.30+34 - 2026-11-15T00:26:03Z

- Commit `1a6bde6`, annotated tag `v0.4.30` (tag object `d65d639`), release
  run `43657709132` (success).
- Android `Pennino-Android.apk`, 53,481,661 B, sha256
  `ec11234c31ff480ab5d23a41b10c29357c8a4dc6720a5376e6af3f20543eb108`.
- Windows `Pennino-Windows-Setup.exe`, 10,923,353 B, sha256
  `72b5737945c9c8225c1a3dcec16313f8ecb7e10facf9983f7049022f62853063`.
- Carries PR #72 (paper fitted to the view width, top-edge stop, tool icons
  extracted, package renamed to `pennino`) and the bump in PR #73.

Verified for 0.4.30-0.4.32: both assets were downloaded with `gh release
download` and their sizes and sha256 recomputed; all match the release API's
digest. The APK's versionCode and signer certificate were not checked, since
no Android SDK tools were available on that machine.

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
