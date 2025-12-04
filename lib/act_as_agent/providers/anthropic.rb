# frozen_string_literal: true

# https://docs.claude.com/en/api/messages#body-tools
# https://docs.claude.com/en/docs/agents-and-tools/tool-use/overview#tool-use-examples
require "act_as_agent/api_clients/anthropic_api_client"
require "act_as_agent/errors/providers/anthropic/authentication_error"
require "act_as_agent/errors/providers/anthropic/too_many_requests_error"
require "act_as_agent/errors/providers/anthropic/invalid_request_error"

module ActAsAgent
  module Providers
    class Anthropic
      attr_reader :config, :tools, :client, :max_tokens

      MODEL_VERSION = "claude-sonnet-4-5"

      def initialize(key:, tools:, max_tokens: 1024)
        @config = { key: key, max_tokens: max_tokens }
        @tools = tools
        @max_tokens = max_tokens
        @client = ActAsAgent::ApiClients::AnthropicClient.new(key: key, max_tokens: max_tokens)
      end

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def request(content:)
        content = [{ role: "user", content: content }] unless content.is_a?(Array)

        response = client.create(
          model: MODEL_VERSION,
          messages: content,
          tools: tools_payload,
          max_tokens: max_tokens
        )

        if response["type"] == "error"
          case response["error"]["type"]
          when "authentication_error"
            return ActAsAgent::Errors::Providers::AuthenticationError
          when "rate_limit_error"
            return ActAsAgent::Errors::Providers::TooManyRequestsError
          when "invalid_request_error"
            return ActAsAgent::Errors::Providers::InvalidRequestError
          end
        end

        return response if response["stop_reason"] == "end_turn"

        tool_responses = response["content"].each_with_object([]) do |message, memo|
          next memo unless message["type"] == "tool_use"

          @tools.each do |tool|
            next unless tool.name == message["name"]

            memo << {
              "role" => "assistant",
              "content" => [
                message
              ]
            }

            memo << {
              role: "user",
              content: [
                {
                  type: "tool_result",
                  tool_use_id: message["id"],
                  content: tool.call(message["input"]).to_s
                }
              ]
            }
          end
        end

        p tool_responses

        request(content: content + tool_responses) unless tool_responses.empty?
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      private

      def tools_payload
        @tools_payload ||= tools.map do |tool|
          {
            name: tool.name,
            description: tool.description,
            input_schema: tool.input_schema
          }
        end
      end
    end
  end
end
