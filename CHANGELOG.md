# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2026-04-05

### Fixed

- `PosixLocaleLang` constructor now accepts minimal locale identifiers (`'C'` and `'POSIX'`);
  `minimalLocale` getter now correctly returns `true` for these values.

### Added

- `PosixLocaleLang` implements `==`, `hashCode`, and `copyWith`.
- `PosixLocaleLang` is now annotated `@immutable`; `meta` added as a direct dependency.
- `example/example.dart` demonstrating `PosixLocaleLang.parse` and constructor usage.

## 0.1.2

- Upgrade ac_lints package to 0.4.0

## 0.1.1

- Upgrade ac_lints package to 0.3.0

## 0.1.0

- Initial release
