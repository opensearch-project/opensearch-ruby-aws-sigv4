# CHANGELOG
Inspired from [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## Unreleased
### Added
### Changed
- Compatibility with opensearch-ruby 4.0
### Deprecated
### Removed
- `OpenSearch::AWS::Sigv4Client` is removed. No longer extend `OpenSearch::Client` and use `OpenSearch::Aws::Sigv4RequestSigner` instead. (See [UPGRADING.md](UPGRADING.md))
### Fixed
### Security

---

## 1.3.0
### Added
- Added workflow to test building and installing the gem ([#63](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/63))
### Changed
- Made CI workflows compatible with OS 2.12 and later. ([#40](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/40))
- Exclude `ignore` param when creating SigV4 signatures. ([#46](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/46))
### Removed
- Removed support for ruby 2.4 and 2.5 ([58](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/58))
### Security
- Upgraded `rubocop-rspec` to the latest 2.x version to resolve CVE in its rexml dependency ([#42](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/42))

---

## 1.2.1
### Changed
- Add compatibility with Ruby 2.4 ([#21](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/21))
### Fixed
- Pass exact signed body to perform_request to prevent Sigv4 mismatch ([#24](https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/pull/24))

---

## 1.2.0
### Added
- Ability to printout Sigv4 Signature for debugging ([#149](https://github.com/opensearch-project/opensearch-ruby/issues/149))

---

## 1.1.0
### Added
- Added support for Amazon OpenSearch Serverless ([#131](https://github.com/opensearch-project/opensearch-ruby/issues/131))
### Fixed
- Sign validation requests when using AWS Sigv4 ([#134](https://github.com/opensearch-project/opensearch-ruby/pull/134))

---

## 1.0.0
### Added
- Added `OpenSearch::AWS::Sigv4Client` ([#110](https://github.com/opensearch-project/opensearch-ruby/pull/110))
