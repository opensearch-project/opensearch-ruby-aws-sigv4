# CHANGELOG
Inspired from [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## Unreleased
### Added
### Changed
- Made CI workflows compatible with OS 2.12 and later. ([#40](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/40))
### Deprecated
### Removed
### Fixed
### Security

---

## 1.2.1
### Added
### Changed
- Add compatibility with Ruby 2.4 ([#21](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/21))
### Deprecated
### Removed
### Fixed
- Pass exact signed body to perform_request to prevent Sigv4 mismatch ([#24](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/24))
### Security

---

## 1.2.0
### Added
- Ability to printout Sigv4 Signature for debugging ([#149](https://github.com/opensearch-project/opensearch-ruby/issues/149))
### Changed
### Deprecated
### Removed
### Fixed
### Security

---

## 1.1.0
### Added
- Added support for Amazon OpenSearch Serverless ([#131](https://github.com/opensearch-project/opensearch-ruby/issues/131))
### Fixed
- Sign validation requests when using AWS Sigv4 ([#134](https://github.com/opensearch-project/opensearch-ruby/pull/134))
### Security

---

## 1.0.0
### Added
- Added `OpenSearch::AWS::Sigv4Client` ([#110](https://github.com/opensearch-project/opensearch-ruby/pull/110))
