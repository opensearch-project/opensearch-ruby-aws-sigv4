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

client = OpenSearch::Client.new({
  host: 'https://your.amz-managed-opensearch.domain', # serverless endpoint for OpenSearch Serverless
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

```ruby
signer = Aws::Sigv4::Signer.new(service: 'es', # signing service name, use "aoss" for OpenSearch Serverless
                                region: 'us-west-2', # signing service region
                                access_key_id: 'key_id',
                                secret_access_key: 'secret')

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

client = OpenSearch::Client.new({
  host: 'https://your.amz-managed-opensearch.domain', # serverless endpoint for OpenSearch Serverless
  logger: logger,
  request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(signer)
})

client.info
```

This will output log messages like this:

```
I, [2025-03-31T20:32:24.398301 #77479]  INFO -- : Signing request with AWS SigV4: GET http://your.amz-managed-opensearch.domain/
D, [2025-03-31T20:32:24.399198 #77479] DEBUG -- : Signed headers with AWS SigV4: {"host" => "your.amz-managed-opensearch.domain", "x-amz-date" => "20250331T113224Z", "x-amz-content-sha256" => "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", "authorization" => "AWS4-HMAC-SHA256 Credential=key_id/20250331/us-west-2/es/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=57c69c2da9597c40625e2dbef3806bdfa0e9e50c99918d2ae10a264110352e51"}
...
```
