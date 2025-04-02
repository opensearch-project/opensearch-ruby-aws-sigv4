# rubocop:disable Naming/FileName
# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.

# frozen_string_literal: true

require 'opensearch-ruby'
require 'aws-sigv4/signer'
require 'faraday'
require 'json'

module OpenSearch
  module Aws
    # AWS Sigv4 request signer for <tt>OpenSearch::Transport::Client</tt>.
    #
    # @link https://github.com/opensearch-project/opensearch-ruby/blob/main/DEVELOPER_GUIDE.md#create-a-request-signer
    #
    # @param [Aws::Sigv4::Signer] sigv4_signer Signer used to sign every request
    #
    # @example
    #   signer = Aws::Sigv4::Signer.new(service: 'es',
    #                                   region: 'us-east-1',
    #                                   access_key_id: '<access_key_id>',
    #                                   secret_access_key: '<secret_access_key>',
    #                                   session_token: '<session_token>')
    #   client = OpenSearch::Client.new({
    #     host: 'https://my-os-domain.us-east-1.es.amazonaws.com/',
    #     request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(signer)
    #   })
    #
    #   puts client.cat.health
    class Sigv4RequestSigner
      def initialize(sigv4_signer)
        unless sigv4_signer.is_a?(::Aws::Sigv4::Signer)
          raise ArgumentError, "Please pass a Aws::Sigv4::Signer. A #{sigv4_signer.class} was given."
        end

        @sigv4_signer = sigv4_signer
      end

      def sign_request(method:, path:, params:, body:, headers:, host:, port:, url:, logger:) # rubocop:disable Lint/UnusedMethodArgument
        logger&.info("Signing request with AWS SigV4: #{method} #{url}")

        signature_body = body.is_a?(Hash) ? body.to_json : body.to_s
        signature = @sigv4_signer.sign_request(
          http_method: method,
          url: url,
          headers: headers,
          body: signature_body
        )

        signed_headers = signature.headers
        logger&.debug("Signed headers with AWS SigV4: #{signed_headers}")

        (headers || {}).merge(signed_headers)
      end
    end
  end
end
# rubocop:enable Naming/FileName
