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
gem 'yard', '~> 0.9', '>= 0.9.35'

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.4') && Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.5')
  gem 'rubocop', '~> 1.12.1'
  gem 'rubocop-rake', '~> 0.5.1'
  gem 'rubocop-rspec', '~> 2'
  gem 'simplecov', '~> 0.18.5'
else
  # We need to disable Bundler/DuplicatedGem only because of rubocop 1.12.1.
  # Rubocop 1.28 allows conditional declaration of gems.  See: https://docs.rubocop.org/rubocop/cops_bundler.html#bundlerduplicatedgem
  gem 'rubocop', '~> 1.28' # rubocop:disable Bundler/DuplicatedGem, Lint/RedundantCopDisableDirective
  gem 'rubocop-rake', '~> 0.6' # rubocop:disable Bundler/DuplicatedGem, Lint/RedundantCopDisableDirective
  gem 'rubocop-rspec', '~> 2.10' # rubocop:disable Bundler/DuplicatedGem, Lint/RedundantCopDisableDirective
  gem 'simplecov', '~> 0.22' # rubocop:disable Bundler/DuplicatedGem, Lint/RedundantCopDisableDirective
end

gem 'rspec', '~> 3'
gem 'timecop', '~> 0.9'

gem 'pry', '~> 0.14'
