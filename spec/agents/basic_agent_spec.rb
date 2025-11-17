# frozen_string_literal: true

RSpec.describe "Basic agent" do
  let(:basic_agent) do
    Class.new do
      include ActAsAgent::Base

      llm_provider ActAsAgent::Providers::Anthropic, with: {
        key: "key"
      }
    end
  end

  it "triggers the process" do
    basic_agent.new
  end
end
