module ActAsAgent
  module Providers
    class Anthropic
      attr_reader :config, :tools

      def initialize(key:, tools:)
        @config = { key: key }
        @tools = tools
      end

      def request(message:)

      end
    end
  end
end
