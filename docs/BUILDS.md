# Pennino builds

Every build that goes up is written down here, newest first. A line means the
artifacts were downloaded from the release and their digests recomputed from
those bytes; a build that is not listed here has not been checked that way.

Releases before v0.4.27 are recorded in their handoff notes rather than here;
the ledger starts with the first build after this habit was asked for.

## 0.4.46+50 - 2026-11-21T20:06:56Z

- Commit `edeb51a`, annotated tag `v0.4.46` (tag object `f5a2833`), release
  run `44944059262` (success).
- Android `Pennino-Android.apk`, 33,890,371 B, sha256
  `5d580cf267289dd8cb3c67b777a3cc40054b3c9dd85789de32429e0563b42b5e`.
- Windows `Pennino-Windows-Setup.exe`, 10,921,971 B, sha256
  `9ada987e8bddc8c9efacebaff2c75c00c579119c849b70666b7c6af97851c31f`.
- Carries PR #100: Check for updates is back in the note menu.
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  50, versionName 0.4.46. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.45+49 - 2026-11-21T19:27:12Z

- Commit `9469e6b`, annotated tag `v0.4.45` (tag object `f391e21`), release
  run `44940642581` (success).
- Android `Pennino-Android.apk`, 33,890,371 B, sha256
  `1e509f1b0a616cefb933db2c6ad3a6ec255a76317a7209c01ec7fd05497b610a`.
- Windows `Pennino-Windows-Setup.exe`, 10,922,040 B, sha256
  `30e3faa12e1c8ed5805cbc8a0e28f8447689c6d617deecc6869ffba3fcef3e9d`.
- Carries PR #96 (Drive sync reads duplicate `notes (N)` folders, ignores
  unrelated JSON, writes `sync.log`) and PR #97 (blur: no tile-boundary seam,
  no hard ink wedges, 14-step ramp).
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  49, versionName 0.4.45. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.44+48 - 2026-11-17T20:58:59Z

- Commit `16f7d1b`, annotated tag `v0.4.44` (tag object `10d9de1`), release
  run `44174201575` (success).
- Android `Pennino-Android.apk`, 33,873,987 B, sha256
  `65b148b8d4eca697cfb9f2629caa8cbf257007ae0e44853548a466d8ad261c75`.
- Windows `Pennino-Windows-Setup.exe`, 10,913,641 B, sha256
  `629d8bd95df5f94b2644c5a57f45523268b896ae650adb9d0e2bd91a9d57a1d5`.
- Carries PR #93: show each note's file size in the library.
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  48, versionName 0.4.44. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.43+47 - 2026-11-17T20:19:31Z

- Commit `4d879f3`, annotated tag `v0.4.43` (tag object `faaedb7`), release
  run `44167238370` (success).
- Android `Pennino-Android.apk`, 33,873,987 B, sha256
  `4aae88b2136cfe4d32c74e37f70dceb948f40b5c8211caa9e95634cc5dbec4e5`.
- Windows `Pennino-Windows-Setup.exe`, 10,914,678 B, sha256
  `80b034c8c59ebbd042dccc9e7a63faa9f14e45398f67c12f891fb7405a643a3a`.
- Carries PR #91: a save keeps the replaced payload as the backup by renaming
  it instead of copying it. Median save of a 3 MB note went from 86 ms to
  64 ms on a development machine; not measured on a phone.
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  47, versionName 0.4.43. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.42+46 - 2026-11-17T19:27:01Z

- Commit `61956b0`, annotated tag `v0.4.42` (tag object `01a3782`), release
  run `44157662086` (success).
- Android `Pennino-Android.apk`, 33,873,987 B, sha256
  `016c899ab15d75044169570d2a0a4f6ee269bf98a9ae74b63fa8d165972c5ba5`.
- Windows `Pennino-Windows-Setup.exe`, 10,912,646 B, sha256
  `822f9b24e42a17cb31d08657449a6b7764a911e3ab28290a77c74ad55dab4554`.
- Carries PR #89: the "Update home widget" menu item is gone and the card is
  also fed once when a note opens; that call runs only on Android and was not
  exercised on a device.
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  46, versionName 0.4.42. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.41+45 - 2026-11-17T19:01:32Z

- Commit `56fa215`, annotated tag `v0.4.41` (tag object `7348ffc`), release
  run `44153309436` (success).
- Android `Pennino-Android.apk`, 33,874,071 B, sha256
  `db1077caee0243d83236139e10f818eb603cea0a73d99f243463e1909544b960`.
- Windows `Pennino-Windows-Setup.exe`, 10,913,197 B, sha256
  `20c707b3328a598130f62a62bf619ef131fa1aa646dea1ebca07dedc40075030`.
- Carries PR #87: the note menu loses the text toggle, the separate checklist
  panel and the manual update check; tasks a note still carries are written
  into the text as checklist lines.
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  45, versionName 0.4.41. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.40+44 - 2026-11-17T08:51:50Z

- Commit `c4557b0`, annotated tag `v0.4.40` (tag object `bb54710`), release
  run `44049784518` (success).
- Android `Pennino-Android.apk`, 34,087,223 B, sha256
  `e79a07fedd9915d2dd7e8ccccce8b47b09c238230a10ae91e4ac172a85ff61a3`.
- Windows `Pennino-Windows-Setup.exe`, 10,936,680 B, sha256
  `8f535c40b6ad23656cfd4f5df964943245a0cf2f749bc6c3b9a75f471d6baa2d`.
- Carries PR #85: smaller toolbar icons, separate Checklist, Numbered list and
  Bulleted list buttons, and the caret blinking in a new empty note.
- `unzip -l`: only `arm64-v8a` and `armeabi-v7a` libraries. `aapt2`: versionCode
  44, versionName 0.4.40. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.39+43 - 2026-11-17T06:35:06Z

- Commit `844c6da`, annotated tag `v0.4.39` (tag object `30c4893`), release
  run `44031659429` (success).
- Android `Pennino-Android.apk`, 34,087,227 B, sha256
  `92335cdf92c4d6377327a93bb2fb0b1696f263f397c1a1c955ad2ac3da6c661d`.
- Windows `Pennino-Windows-Setup.exe`, 10,937,119 B, sha256
  `7a1c6a207ad6e39e4d64d6653060b3f8124fe0f9c4b30df06e012bd83091c409`.
- Carries PR #83: the x86_64 libraries are left out of the release package, so
  the APK is 19.5 MB smaller than 0.4.38 (`unzip -l` lists only `arm64-v8a` and
  `armeabi-v7a`). It does not install on x86 emulators or x86 Chromebooks. A
  local release build of the same commit was the same size, 34,087,227 B.
- `aapt2`: versionCode 43, versionName 0.4.39. Signer certificate SHA-256
  `f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`,
  unchanged.

## 0.4.38+42 - 2026-11-16T20:20:37Z

- Commit `4edb5fa`, annotated tag `v0.4.38` (tag object `7fb12fb`), release
  run `43947872020` (success).
- Android `Pennino-Android.apk`, 53,579,853 B, sha256
  `63b1d4eee2ccbf73d9fcd917fa3db83a9451ebecaf769111044ea2fd5f74343a`.
- Windows `Pennino-Windows-Setup.exe`, 10,937,555 B, sha256
  `c291f0bb398059417edbf3d6a6dd0d72ab1810305df58528d19d25ba183af64c`.
- Carries PR #82: four notes loaded at a time in the library (about 13% faster
  for 24 large notes on a development machine, not measured on a phone).
- The APK was meant to drop the x86_64 libraries and did not: it is the same
  size as 0.4.37 and `lib/x86_64` is still inside, because an ABI filter on the
  release build type does not hold. Fixed in 0.4.39.

## 0.4.37+41 - 2026-11-16T17:15:46Z

- Commit `1f00bab`, annotated tag `v0.4.37` (tag object `5dd98df`), release
  run `43915602601` (success).
- Android `Pennino-Android.apk`, 53,579,853 B, sha256
  `96d5010573c3154df912c913bc44c494acb9d6112ae6411985ef6394ecd693fb`.
- Windows `Pennino-Windows-Setup.exe`, 10,936,576 B, sha256
  `03714f1d3167a13c96cfe2cf533cbc44acfbdcb2fa2a490059525e3af1f30e26`.
- Carries PR #81: the home-screen widget fills the card's width with the page
  and shows as much of the top as fits, redrawn on resize.

## 0.4.36+40 - 2026-11-16T16:52:01Z

- Commit `9f6695a`, annotated tag `v0.4.36` (tag object `5d14fcf`), release
  run `43911153221` (success).
- Android `Pennino-Android.apk`, 53,579,849 B, sha256
  `f026a237e758ade159422403295ed9bd5377f71e52a8231c5dba43ee339adc8f`.
- Windows `Pennino-Windows-Setup.exe`, 10,936,694 B, sha256
  `e12155dd5cb71b2b9c17f9acef927b29ec4d488be7a7d30766fe21e4b16e96b2`.
- Carries PR #80: flat round toolbar buttons and a font size with a dropdown
  caret.

## 0.4.35+39 - 2026-11-15T17:14:46Z

- Commit `ffad3b8`, annotated tag `v0.4.35` (tag object `33325a8`), release
  run `43739489444` (success).
- Android `Pennino-Android.apk`, 53,563,437 B, sha256
  `6b5097a4b8b459aca6bfd571189eb55bc9b0270edac7732bfffd880adc472ad4`.
- Windows `Pennino-Windows-Setup.exe`, 10,935,830 B, sha256
  `7f34633cf78c76374a4cc822c50e1ecbf98629c0732cc2586fd3cb2448a0be22`.
- Carries PR #79: text wraps at a 400 px phone page width on every device, a
  margin line marks it on bigger screens, and the widget picture is no longer
  stretched.

## 0.4.34+38 - 2026-11-15T15:45:18Z

- Commit `2601640`, annotated tag `v0.4.34` (tag object `9a2f811`), release
  run `43731248766` (success).
- Android `Pennino-Android.apk`, 53,563,433 B, sha256
  `f0c579efd222d3803c3b22f3d48b9bbf7ac0e5be4b325ce22b55213b3850f009`.
- Windows `Pennino-Windows-Setup.exe`, 10,934,140 B, sha256
  `a6bdd5829677b33b378c2c3c6753b0eabce345fc4a49b9f67bf0aa13ce5eb81c`.
- Carries PR #78: house icon for the notes button, neutral checkbox ticks, and
  Enter continuing a checklist, bullet or numbered list.

## 0.4.33+37 - 2026-11-15T15:11:23Z

- Commit `cd819aa`, annotated tag `v0.4.33` (tag object `b9f0a75`), release
  run `43728040512` (success).
- Android `Pennino-Android.apk`, 53,497,889 B, sha256
  `02171bce52ff7bb5785b4daac9a8974413b8b89c525a886ebbd52422f9df3cc5`.
- Windows `Pennino-Windows-Setup.exe`, 10,930,514 B, sha256
  `ce58c99b3d5e96c04696f1880f5955bde9ea75f9e6fe2dbd35d613f0fb070a6b`.
- Carries PR #77: one compact tool row, with text as the starting tool.

Verified for 0.4.33-0.4.43: both assets were downloaded with `gh
release download` and their sizes and sha256 recomputed; all match the release
API's digest. `aapt2` reports versionCode 37 to 47 for these builds and
`apksigner` the signer certificate SHA-256 `f86428c3bbd47b52...`
(`f86428c3bbd47b522613ef6707b3ca57b24c06dc219fc50cf72a68b6a0285978`), unchanged.

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
