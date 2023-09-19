# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.

# frozen_string_literal: true

require_relative 'lib/opensearch-aws-sigv4/version'

Gem::Specification.new do |s|
  s.name          = 'opensearch-aws-sigv4'
  s.version       = OpenSearch::Aws::Sigv4::VERSION
  s.homepage      = 'https://github.com/opensearch-project/opensearch-ruby-aws-sigv4'
  s.license       = 'Apache-2.0'
  s.authors       = ['OpenSearch Contributors']
  s.email         = 'opensearch@amazon.com'
  s.summary       = 'Ruby AWS Sigv4 Client for OpenSearch'
  s.description   = <<~DESC
    A wrapper for opensearch-ruby gem that provides AWS Sigv4 signing.
    It behaves like OpenSearch::Client, but signs every request with AWS Sigv4
    using the credentials provided during the client's initialization.
  DESC
  s.metadata = {
    'homepage_uri'          => 'https://github.com/opensearch-project/opensearch-ruby-aws-sigv4',
    'documentation_uri'     => 'https://rubydoc.info/gems/opensearch-aws-sigv4/OpenSearch/Aws/Sigv4Client',
    'source_code_uri'       => 'https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/tree/main',
    'bug_tracker_uri'       => 'https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/issues',
    'changelog_uri'         => 'https://github.com/opensearch-project/opensearch-ruby-aws-sigv4/blob/main/CHANGELOG.md'
  }

  s.files         = Dir['lib/**/*', '*.gemspec']
  s.test_files    = Dir['spec/unit/**/*']
  s.require_paths = ['lib']
  s.bindir        = 'bin'
  s.executables   = 'opensearch_sigv4_console'

  s.extra_rdoc_files  = %w[README.md USER_GUIDE.md LICENSE]
  s.rdoc_options      = ['--charset=UTF-8']

  signing_key = File.expand_path('gem-private_key.pem')
  if $PROGRAM_NAME.end_with?('gem') && ARGV.first == 'build' && File.exist?(signing_key)
    s.signing_key = signing_key
    s.cert_chain  = ['.github/opensearch-rubygems.pem']
  end

  s.required_ruby_version = '>= 2.4'

  s.add_dependency 'aws-sigv4', '>= 1'
  s.add_dependency 'opensearch-ruby', '>= 1.0.1'
end
