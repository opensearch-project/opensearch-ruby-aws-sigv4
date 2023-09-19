# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.

# frozen_string_literal: true

require 'bundler/gem_tasks'

task(:default) { system 'rake --tasks' }

desc 'Run unit tests'
task test: 'test:spec'

# ----- Test tasks ------------------------------------------------------------
require 'rspec/core/rake_task'

namespace :test do
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/**{,/*/**}/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**{,/*/**}/*_spec.rb'
  end

  desc 'Run unit and integration tests'
  task :all do
    Rake::Task['test:unit'].invoke
    Rake::Task['test:integration'].invoke
  end
end

# ----- Documentation tasks ---------------------------------------------------
desc 'Generate documentation for preview'
task :gh_pages do
  yard_cmd = 'yard doc --embed-mixins --markup=rdoc --output-dir docs ./docs lib/**/*.rb'
  Kernel.system yard_cmd

  %w[OpenSearch.svg].each do |file|
    cp file, './docs'
  end
end
