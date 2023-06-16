# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.

# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in opensearch-aws-sigv4.gemspec
gemspec

gem 'bundler', '~> 2'
gem 'rake', '~> 13'
gem 'yard', '~> 0.9'

if RUBY_VERSION.start_with?('2.4')
  gem 'rubocop', '~> 1.12.1'
  gem 'rubocop-rake', '~> 0.5.1'
  gem 'rubocop-rspec', '~> 2.2.0'
  gem 'simplecov', '~> 0.18.5'
else
  gem 'rubocop', '~> 1.28'
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.10'
  gem 'simplecov', '~> 0.22'
end

gem 'rspec', '~> 3'
gem 'timecop', '~> 0.9'

gem 'pry', '~> 0.14'
