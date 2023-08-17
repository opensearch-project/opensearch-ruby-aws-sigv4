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
require 'aws-sigv4'
require 'timecop'

describe OpenSearch::Aws::Sigv4Client do
  subject(:client) do
    described_class.new(
      { host: 'http://localhost:9200',
        transport_options: { ssl: { verify: false } } },
      signer
    )
  end

  let(:signer) do
    Aws::Sigv4::Signer.new(service: 'es',
                           region: 'us-west-2',
                           access_key_id: 'key_id',
                           secret_access_key: 'secret')
  end

  describe '.initialize' do
    context 'when a Sigv4 Signer is NOT provided' do
      let(:signer) { nil }

      it 'raises an argument error' do
        expect { client }.to raise_error ArgumentError, 'Please pass a Aws::Sigv4::Signer. A NilClass was given.'
      end
    end

    context 'when a Sigv4 Signer is provided' do
      it 'does NOT raise any error' do
        expect { client }.not_to raise_error
      end
    end
  end

  describe '#perform_request' do
    let(:response) { { body: 'Response Body' } }
    let(:transport_double) do
      double = instance_double(OpenSearch::Transport::Client, perform_request: response)
      allow(double).to receive_message_chain(:transport, :hosts, :dig).and_return('localhost')
      double
    end
    let(:signed_headers) do
      { 'authorization' => 'AWS4-HMAC-SHA256 Credential=key_id/20220101/us-west-2/es/aws4_request, '\
                           'SignedHeaders=host;x-amz-content-sha256;x-amz-date, ' \
                           'Signature=9c4c690110483308f62a91c2ca873857750bca2607ba1aabdae0d2303950310a',
        'host' => 'localhost',
        'x-amz-content-sha256' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'x-amz-date' => '20220101T000000Z' }
    end

    before do
      Timecop.freeze(Time.utc(2022))
      client.transport = transport_double
    end

    after { Timecop.return }

    it 'signs the request before passing it to @transport' do
      output = client.perform_request('GET', '/', {}, '', {})
      expect(output).to eq(response)
      expect(transport_double).to have_received(:perform_request).with('GET', '/', {}, '', signed_headers)
    end

    it 'skips the opensearch verification' do
      allow(client).to receive(:open_search_validation_request)
      client.perform_request('GET', '/_stats', {}, '', {})
      expect(client).not_to have_received(:open_search_validation_request)
    end

    it 'passes the same body to sign_request and super' do
      body = {
        char_filter: {
          test: {
            type: 'mapping',
            mappings: ["’ => '"]
          }
        }
      }
      signature_body = body.to_json

      allow(signer).to receive(:sign_request).with(a_hash_including(body: signature_body)).and_call_original

      client.perform_request('GET', '/', {}, body, {})

      expect(transport_double).to have_received(:perform_request).with('GET', '/', {}, signature_body, kind_of(Hash))
    end
  end
end
