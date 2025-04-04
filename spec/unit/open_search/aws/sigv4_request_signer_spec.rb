# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenSearch::Aws::Sigv4RequestSigner do
  subject(:signer) { described_class.new(options) }

  context 'with region and credentials' do
    let(:options) do
      {
        region: 'us-east-1',
        access_key_id: 'access_key_id',
        secret_access_key: 'secret_access_key',
        session_token: 'session_token'
      }
    end

    describe '#initialize' do
      it 'creates a new AWS Sigv4 signer' do
        expect(signer.service).to eq('es')
        expect(signer.region).to eq('us-east-1')
      end
    end
  end

  context 'with all options' do
    let(:options) do
      {
        service: 'aoss',
        region: 'us-west-2',
        access_key_id: 'access_key_id',
        secret_access_key: 'secret_access_key',
        session_token: 'session_token'
      }
    end

    describe '#initialize' do
      it 'creates a new AWS Sigv4 signer with custom options' do
        expect(signer.service).to eq('aoss')
        expect(signer.region).to eq('us-west-2')
      end
    end

    describe 'delegated methods' do
      it 'delegates service method' do
        expect(signer.service).to eq('aoss')
      end

      it 'delegates region method' do
        expect(signer.region).to eq('us-west-2')
      end

      it 'delegates credentials_provider method' do
        expect(signer.credentials_provider).to be_a(Aws::Sigv4::StaticCredentialsProvider)
      end

      it 'delegates unsigned_headers method' do
        expect(signer.unsigned_headers).to be_an(Set)
        expect(signer.unsigned_headers).to eq(Set.new(%w[authorization x-amzn-trace-id expect]))
      end

      it 'delegates apply_checksum_header method' do
        expect(signer.apply_checksum_header).to be(true)
      end
    end

    describe '#sign_request' do
      let(:request_params) do
        {
          method: 'GET',
          path: '/_cluster/health',
          params: {},
          body: '',
          headers: { 'Content-Type' => 'application/json' },
          host: 'localhost',
          port: 9200,
          url: 'http://localhost:9200/_cluster/health',
          logger: nil
        }
      end

      it 'signs the request with AWS SigV4' do
        signed_headers = signer.sign_request(**request_params)

        expect(signed_headers).to be_a(Hash)
        expect(signed_headers.keys).to include('authorization')
        expect(signed_headers.keys).to include('x-amz-date')
        expect(signed_headers.keys).to include('x-amz-security-token')
      end

      context 'with JSON body' do
        let(:json_body) { { query: { match_all: {} } } }

        let(:request_params_with_json) do
          request_params.merge(body: json_body)
        end

        it 'properly handles JSON body' do
          signed_headers = signer.sign_request(**request_params_with_json)

          expect(signed_headers).to be_a(Hash)
          expect(signed_headers.keys).to include('authorization')
          expect(signed_headers.keys).to include('x-amz-date')
          expect(signed_headers.keys).to include('x-amz-security-token')
        end
      end

      context 'with logger' do
        let(:logger) { instance_double(Logger, info: nil, debug: nil) }

        let(:request_params_with_logger) do
          request_params.merge(logger: logger)
        end

        it 'logs signing information' do
          signer.sign_request(**request_params_with_logger)

          expect(logger).to have_received(:debug).with(/Signed headers with AWS SigV4/)
          expect(logger).to have_received(:info).with(/Signing request with AWS SigV4/)
        end
      end
    end
  end
end
