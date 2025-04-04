# Upgrading

## Upgrading to >= 2.0

### Breaking Changes

- The class `OpenSearch::Aws::Sigv4Client` has been removed.
- Code that extends `OpenSearch::Aws::Sigv4Client` must now use `OpenSearch::Client` with a `OpenSearch::Aws::Sigv4RequestSigner`.

### Migration

1. Remove any references to `OpenSearch::Aws::Sigv4Client`.
2. Use `OpenSearch::Client` and pass an instance of `OpenSearch::Aws::Sigv4RequestSigner` to `request_signer`.

### Example

Below is a brief example of updating your client configuration:

```ruby
request_signer = OpenSearch::Aws::Sigv4RequestSigner.new(
  service: 'es',
  region: 'us-west-2',
  access_key_id: 'key_id',
  secret_access_key: 'secret'
)

client = OpenSearch::Client.new({
  host: 'https://your.amz-managed-opensearch.domain',
  request_signer: request_signer
})
```

### Debug Logging

By default, the signer will use the logger from the `opensearch-ruby` gem. To ensure safe logging in a production environment, make sure its level is set to `INFO` to avoid logging debug-level signed headers.

```ruby
logger = Logger.new
logger.level = Logger::INFO

client = OpenSearch::Client.new(
  host: 'https://your.amz-managed-opensearch.domain',
  request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(...),
  logger: logger
)
```
