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

This library is an AWS Sigv4 wrapper for [`opensearch-ruby`](https://github.com/opensearch-project/opensearch-ruby/tree/main), which is a Ruby client for OpenSearch. The `OpenSearch::Aws::Sigv4Client`, therefore, has all features of `OpenSearch::Client`.

### Amazon OpenSearch Service
To sign requests for the Amazon OpenSearch Service:

```ruby
require 'opensearch-aws-sigv4'
require 'aws-sigv4'

signer = Aws::Sigv4::Signer.new(service: 'es', # signing service name, use "aoss" for OpenSearch Serverless
                                region: 'us-west-2', # signing service region
                                access_key_id: 'key_id',
                                secret_access_key: 'secret')

client = OpenSearch::Aws::Sigv4Client.new({
    host: 'https://your.amz-managed-opensearch.domain', # serverless endpoint for OpenSearch Serverless
    log: true
}, signer)

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
If you run into credentials errors, usually from expired session, set the `sigv4_debug` option to `true` when creating the client to print out the Sigv4 Signing Debug information.

```ruby
client = OpenSearch::Aws::Sigv4Client.new({
    host: 'https://your.amz-managed-opensearch.domain',
}, signer, sigv4_debug: true)

client.info
```

```shell
(2023-04-25 11:02:59 -0600)  Sigv4 - STRING TO SIGN: 
AWS4-HMAC-SHA256
20230425T170259Z
20230425/us-east-1/aoss/aws4_request
0e20bdc5eda484f2b0e65f8a33514c48471500da91b1f0c8bb6b86770b5dc6c4

(2023-04-25 11:02:59 -0600)  Sigv4 - CANONICAL REQUEST:
GET
/

host:your.amz-managed-opensearch.domain
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20230425T170259Z

host;x-amz-content-sha256;x-amz-date
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

(2023-04-25 11:02:59 -0600)  Sigv4 - SIGNATURE HEADERS:
{"host"=>"your.amz-managed-opensearch.domain", 
"x-amz-date"=>"20230425T170259Z", 
"x-amz-content-sha256"=>"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", 
"authorization"=>"AWS4-HMAC-SHA256 Credential=ABCDEFGH/20230425/us-east-1/aoss/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=858f171c834231ae3c885c670217f94c68f010e85c50b0ad095444966fb5df0c"}
```
