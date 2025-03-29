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

describe OpenSearch::Aws::Sigv4RequestSigner do
  subject(:request_signer) do
    described_class.new(signer)
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
        expect do
          request_signer
        end.to raise_error ArgumentError, 'Please pass a Aws::Sigv4::Signer. A NilClass was given.'
      end
    end

    context 'when a Sigv4 Signer is provided' do
      it 'does NOT raise any error' do
        expect { request_signer }.not_to raise_error
      end
    end
  end

  describe '#sign_request' do
    let(:expected_signed_headers) do
      { 'authorization' => 'AWS4-HMAC-SHA256 Credential=key_id/20220101/us-west-2/es/aws4_request, ' \
                           'SignedHeaders=host;x-amz-content-sha256;x-amz-date, ' \
                           'Signature=9c4c690110483308f62a91c2ca873857750bca2607ba1aabdae0d2303950310a',
        'host' => 'localhost',
        'x-amz-content-sha256' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'x-amz-date' => '20220101T000000Z' }
    end

    before do
      Timecop.freeze(Time.utc(2022))
    end

    after { Timecop.return }

    it 'signs the request' do
      signed_headers = request_signer.sign_request(method: 'GET', path: '/', params: {}, body: '', headers: {},
                                                   host: 'localhost', port: 9200, url: 'http://localhost/', logger: nil)
      expect(signed_headers).to eq(expected_signed_headers)
    end
  end
end
