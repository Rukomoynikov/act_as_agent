# frozen_string_literal: true

require "act_as_agent/providers/anthropic"

RSpec.describe ActAsAgent::Providers::Anthropic do
  let(:api_key) do
    YAML.load_file("spec/credentials.yml").dig("anthropic", "messages", "x-api-key")
  end

  let(:basic_tool_class) do
    Class.new do
      attr_reader :name, :description, :input_schema

      def initialize(name:, description:, input_schema:)
        @name = name
        @description = description
        @input_schema = input_schema
      end

      def call(args)
        "Hello, #{args["name"]}!"
      end
    end
  end

  let(:basic_tool_instance) do
    basic_tool_class.new(
      name: "greet_user",
      description: "Greets a user by their name.",
      input_schema: {
        type: "object",
        properties: {
          name: { type: "string", description: "The name of the user to greet." }
        },
        required: ["name"]
      }
    )
  end
  let(:provider) do
    ActAsAgent::Providers::Anthropic.new(key: api_key, tools: [basic_tool_instance])
  end

  describe "#send", :vcr do
    it "sends request" do
      provider.request(content: "Hello, Anthropic!")
    end
  end
end
