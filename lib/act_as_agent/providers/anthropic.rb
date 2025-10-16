# frozen_string_literal: true

# https://docs.claude.com/en/api/messages#body-tools
# https://docs.claude.com/en/docs/agents-and-tools/tool-use/overview#tool-use-examples

module ActAsAgent
  module Providers
    class Anthropic
      attr_reader :config, :tools, :client, :max_tokens

      MODEL_VERSION = "claude-sonnet-4-5"

      def initialize(key:, tools:, max_tokens: 1024)
        @config = { key: key, max_tokens: max_tokens }
        @tools = tools
        @max_tokens = max_tokens
        @client = AnthropicClient.new(key: key, max_tokens: max_tokens)
      end

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def request(content:)
        content = [{ role: "user", content: content }] unless content.is_a?(Array)

        response = client.create(
          model: MODEL_VERSION,
          messages: content,
          tools: tools_payload,
          max_tokens: max_tokens
        )

        tool_responses = []

        response["content"].each do |message|
          next unless message["type"] == "tool_use"

          @tools.each do |tool|
            next unless tool.name == message["name"]

            tool_responses << {
              "role" => "assistant",
              "content" => [
                message
              ]
            }

            tool_responses << {
              role: "user",
              content: [
                {
                  type: "tool_result",
                  tool_use_id: message["id"],
                  content: tool.call(message["input"])
                }
              ]
            }
          end
        end

        request(content: content + tool_responses) unless tool_responses.empty?

        response["content"]
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

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

class AnthropicClient < ApiClient
  act_as_api_client for: %i[anthropic messages]

  def initialize(key:, max_tokens:)
    super()

    options[:x_api_key] = key
    options[:max_tokens] = max_tokens
  end
end
