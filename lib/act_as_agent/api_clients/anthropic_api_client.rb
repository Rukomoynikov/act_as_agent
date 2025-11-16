# frozen_string_literal: true

require "act_as_api_client"

module ActAsAgent
  module ApiClients
    class AnthropicClient < ApiClient
      act_as_api_client for: %i[anthropic messages]

      def initialize(key:, max_tokens:)
        super()

        options[:x_api_key] = key
        options[:max_tokens] = max_tokens
      end
    end
  end
end
