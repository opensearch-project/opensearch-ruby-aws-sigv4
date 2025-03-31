# Upgrading

## Upgrading to 2.0

### Breaking Changes
- The class `OpenSearch::Aws::Sigv4Client` has been removed.
- Code that extends `OpenSearch::Aws::Sigv4Client` must now use `OpenSearch::Client` with a `OpenSearch::Aws::Sigv4RequestSigner`.

### Migration
1. Remove any references to `OpenSearch::Aws::Sigv4Client`.
2. Use `OpenSearch::Client` and pass `request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(your_signer)`.

### Example
Below is a brief example of updating your client configuration:

```ruby
signer = Aws::Sigv4::Signer.new(
  service: 'es',
  region: 'us-west-2',
  access_key_id: 'key_id',
  secret_access_key: 'secret'
)

client = OpenSearch::Client.new({
  host: 'https://your.amz-managed-opensearch.domain',
  request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(signer)
})
