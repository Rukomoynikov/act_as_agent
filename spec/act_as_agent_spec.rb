# frozen_string_literal: true

require "act_as_agent"

RSpec.describe ActAsAgent do
  describe "basic examples" do
    let(:basic_class) do
      Class.new do
        include ActAsAgent::Base
      end
    end

    it "supports run method" do
      my_agent = basic_class.new

      my_agent.run
    end
  end

  describe ".llm_provider" do
    let(:class_with_llm_provider) do
      Class.new do
        include ActAsAgent::Base

        llm_provider ActAsAgent::Providers::OpenAi, with: {
          key: "key"
        }
      end
    end
  end
end
