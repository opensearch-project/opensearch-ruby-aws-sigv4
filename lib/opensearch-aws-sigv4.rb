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
require 'forwardable'

module OpenSearch
  module Aws
    # AWS Sigv4 request signer for <tt>OpenSearch::Transport::Client</tt>.
    #
    # @link https://github.com/opensearch-project/opensearch-ruby/blob/main/DEVELOPER_GUIDE.md#create-a-request-signer
    #
    # @param [Hash] options Signer options
    # @option options [String] :service ('es') The AWS service name.
    # @option options [String] :region The AWS region.
    # @option options [String] :access_key_id The AWS access key ID.
    # @option options [String] :secret_access_key The AWS secret access key.
    # @option options [String] :session_token (optional) The AWS session token.
    #
    # @example
    #   client = OpenSearch::Client.new({
    #     host: 'https://my-os-domain.us-east-1.es.amazonaws.com/',
    #     request_signer: OpenSearch::Aws::Sigv4RequestSigner.new(
    #       service: 'es',
    #       region: 'us-east-1',
    #       access_key_id: '<access_key_id>',
    #       secret_access_key: '<secret_access_key>',
    #       session_token: '<session_token>'
    #     )
    #   })
    #
    #   puts client.cat.health
    class Sigv4RequestSigner
      extend Forwardable

      attr_reader :signer

      def_delegators :@signer, :service, :region, :credentials_provider, :unsigned_headers, :apply_checksum_header

      def initialize(options = {})
        @signer = ::Aws::Sigv4::Signer.new({
          service: 'es'
        }.merge(options))
      end

      def sign_request(method:, path:, params:, body:, headers:, host:, port:, url:, logger:) # rubocop:disable Lint/UnusedMethodArgument
        logger&.info("Signing request with AWS SigV4: #{method} #{url}")

        signature_body = body.is_a?(Hash) ? body.to_json : body.to_s
        signature = @signer.sign_request(
          http_method: method,
          url: url,
          headers: headers,
          body: signature_body,
          logger: logger
        )

        signed_headers = signature.headers
        logger&.debug("Signed headers with AWS SigV4: #{signed_headers}")

        (headers || {}).merge(signed_headers)
      end
    end
  end
end
# rubocop:enable Naming/FileName
