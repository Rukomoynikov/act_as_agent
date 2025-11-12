# frozen_string_literal: true

RSpec.describe "Basic agent" do
  let(:basic_tool_class) do
    Class.new do
      attr_reader :name, :description, :input_schema

      def initialize(name:, description:, input_schema:)
        @name = name
        @description = description
        @input_schema = input_schema
      end

      def call(args)
        p args["question"]

        gets.chomp
      end
    end
  end

  let(:basic_tool_instance) do
    basic_tool_class.new(
      name: "ask_my_name",
      description: "Ask users their name",
      input_schema: {
        type: "object",
        properties: {
          question: { type: "string", description: "Question to ask user" }
        },
        required: ["question"]
      }
    )
  end
  let(:basic_agent) do
    Class.new do
      include ActAsAgent::Base

      llm_provider ActAsAgent::Providers::Anthropic, with: {
        key: "key"
      }
    end
  end

  it "triggers the process" do
    agent = basic_agent.new

    p agent.tools
  end
end
