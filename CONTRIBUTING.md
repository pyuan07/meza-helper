# Contributing to MezaHelper

Thanks for wanting to help! MezaHelper is a community fan project and contributions of all kinds
are welcome.

By participating you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to Contribute

- **Tag data corrections** — wrong stats, missing tags, incorrect version assignments. These are
  the most valuable contributions and don't require writing code.
- **Bug reports** — something not working on your device
- **Translations** — the app supports English and 中文; more languages are welcome
- **Features** — open an issue first so we can agree on the approach
- **Documentation** — clarifications and fixes

## Development Setup

```bash
git clone https://github.com/pyuan07/meza-helper.git
cd meza-helper
flutter pub get
flutter run
```

You'll need the Flutter SDK with Dart 3.2.0+. Run `flutter doctor` to check your toolchain.

### Code Generation

Models and providers use `build_runner`. After editing anything annotated with `@HiveType`,
`@riverpod`, or similar, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Commit the generated `.g.dart` files** — they're tracked in this repository.

## Project Conventions

### Structure

The codebase is feature-first. A feature lives entirely under `lib/features/<name>/`:

```
lib/features/my_feature/
├── my_feature_screen.dart      Screen(s)
├── widgets/                    Feature-specific widgets
└── data/                       Repositories and data sources
```

Put shared, reusable widgets in `lib/shared/widgets/` and cross-cutting utilities in `lib/core/`.

### State Management

- Use **Riverpod** providers; put them in `lib/providers/` or alongside their feature
- Prefer `ConsumerWidget` / `ConsumerStatefulWidget` over passing state down manually
- Keep business logic in providers and services, not in widget `build` methods

### Data & Storage

- Persistence goes through Hive via `StorageService` — don't open boxes ad hoc in widgets
- New persisted models need `@HiveType` with a **unique** type ID and registered adapters
- **Never reuse or renumber an existing `@HiveField` index** — it will corrupt existing users'
  data. Add new fields with the next free number and make them nullable.

### Error Handling

Use the `Result` type in `lib/core/result.dart` and the shared error handler rather than throwing
raw exceptions to the UI. User-facing messages should be friendly and actionable.

### Platform-Specific Code

Web-only code uses conditional imports with a stub (see `lib/utils/web_qr/`). Follow that pattern
rather than sprinkling `kIsWeb` checks throughout. Use `lib/core/platform_utils.dart` for
platform detection.

### Style

- Follow the rules in [`analysis_options.yaml`](analysis_options.yaml)
- Run `dart format .` before committing
- Prefer `const` constructors wherever possible
- Match the surrounding code's style; keep diffs focused

## Adding or Correcting Tag Data

Tag data lives in `lib/features/tag_dex/data/`. When submitting a correction, please include a
source in your pull request or issue — a photo of the physical tag, or a link to a reliable
reference. Bundled artwork must not be added for tags you don't have rights to distribute; see
[Asset Contributions](#asset-contributions).

## Before You Submit

```bash
flutter analyze     # must pass with no new issues
flutter test        # must pass
dart format .       # formatting
```

Build at least one target to be sure nothing broke:

```bash
flutter build apk --debug
```

## Pull Request Process

1. Fork the repository and branch from `main`:
   `git checkout -b feature/short-description`
2. Make your change, regenerating code if needed
3. Verify `flutter analyze` and `flutter test` pass
4. Write a clear commit message in the imperative mood:
   ```
   Fix brightness not restoring after closing trainer QR

   The brightness reset ran only on the success path, so backing out of
   the QR sheet left the screen at 100%.
   ```
5. Open a pull request against `main` and fill in the template
6. Respond to review feedback with additional commits on the same branch

## Asset Contributions

Please **do not** submit copyrighted artwork, scans, or images you do not have the right to
redistribute. This is a fan project and we want to keep it on the right side of that line. Data
(names, stats, types) and original artwork you created yourself are fine.

## Questions

Open an issue with the `question` label — happy to help.
