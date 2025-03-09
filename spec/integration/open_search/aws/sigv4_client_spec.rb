# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.

# frozen_string_literal: true

require_relative '../../../spec_helper'
require 'logger'
require 'aws-sigv4'

describe OpenSearch::Aws::Sigv4Client do
  let(:client) do
    signer = Aws::Sigv4::Signer.new(service: 'es',
                                    region: 'us-west-2',
                                    access_key_id: 'key_id',
                                    secret_access_key: 'secret')

    described_class.new({ host: OPENSEARCH_URL, logger: Logger.new($stdout) }, signer, options: { sigv4_debug: true })
  end

  it 'performs API actions without throwing any errors' do
    expect do
      expect(client.indices.exists(index: 'test-index')).to be false

      # Index a document
      client.index(index: 'test-index', id: '1', body: { title: 'Test' })

      # Refresh the index
      client.indices.refresh(index: 'test-index')

      expect(client.indices.exists(index: 'test-index')).to be true

      # Search
      response = client.search(index: 'test-index', body: { query: { match: { title: 'test' } } })

      expect(response['hits']['total']['value']).to eq 1
      expect(response['hits']['hits'][0]['_source']['title']).to eq 'Test'

      # Delete the index
      client.indices.delete(index: 'test-index')
    end.not_to raise_error
  end
end
