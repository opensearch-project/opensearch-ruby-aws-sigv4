- [User Guide](#user-guide)
  - [Setup](#setup)
  - [Usage](#usage)
    - [Amazon OpenSearch Service](#amazon-opensearch-service)
    - [Enable Sigv4 Debug Logging](#enable-sigv4-debug-logging)
# User Guide
## Setup

To add the gem to your project, install it using [RubyGems](https://rubygems.org/):

```
gem install opensearch-aws-sigv4
```

or add it to your Gemfile:
```
gem opensearch-aws-sigv4
```
and run:
```
bundle install
```

## Usage

This library provides an AWS SigV4 request signer for [`opensearch-ruby`](https://github.com/opensearch-project/opensearch-ruby/tree/main), which is a Ruby client for OpenSearch.

### Amazon OpenSearch Service
To sign requests for the Amazon OpenSearch Service:

```ruby
require 'opensearch-aws-sigv4'
require 'aws-sigv4'

signer = Aws::Sigv4::Signer.new(service: 'es', # signing service name, use "aoss" for OpenSearch Serverless
                                region: 'us-west-2', # signing service region
                                access_key_id: 'key_id',
                                secret_access_key: 'secret')

logger = Logger.new($stdout) 

client = OpenSearch::Client.new({
  host: 'https://your.amz-managed-opensearch.domain', # serverless endpoint for OpenSearch Serverless
  logger: logger,
  request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(signer)
})

# create an index and document
index = 'prime'
client.indices.create(index: index)
client.index(index: index, id: '1', body: { name: 'Amazon Echo', 
                                            msrp: '5999', 
                                            year: 2011 })

# search for the document
client.search(body: { query: { match: { name: 'Echo' } } })

# delete the document
client.delete(index: index, id: '1')

# delete the index
client.indices.delete(index: index)
```

### Enable Sigv4 Debug Logging
The `opensearch-aws-sigv4` gem outputs the contents of the signature at the `debug` level via the logger passed to the `OpenSearch::Client`.

To inspect the actual signature content being generated for each request (e.g. for debugging purposes or troubleshooting), pass a logger configured with `DEBUG` level like this:

```
I, [2025-03-29T22:17:44.029909 #7409]  INFO -- : Signing request with AWS SigV4: GET https://your.amz-managed-opensearch.domain/test-index/_refresh
D, [2025-03-29T22:17:44.030121 #7409] DEBUG -- : Signed headers with AWS SigV4: {"host" => "your.amz-managed-opensearch.domain", "x-amz-date" => "20250329T131744Z", "x-amz-content-sha256" => "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", "authorization" => "AWS4-HMAC-SHA256 Credential=key_id/20250329/us-west-2/es/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=58e902bbbe7554695f3ad4a21db2eca9e1932aeaca87617c27af3b10a0b1233c"}
I, [2025-03-29T22:17:44.038131 #7409]  INFO -- : GET https://your.amz-managed-opensearch.domain/test-index/_refresh [status:200, request:0.008s, query:n/a]
```
