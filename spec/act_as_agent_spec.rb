# frozen_string_literal: true

RSpec.describe ActAsAgent do
  describe "basic examples" do
    let(:basic_class) do
      Class.new do
        include ActAsAgent::Base
      end
    end

    it "supports run method" do
      basic_class.new
    end
  end

  describe ".llm_provider" do
    describe "when it was provided" do
      let(:agent_with_llm_provider) do
        Class.new do
          include ActAsAgent::Base

          llm_provider ActAsAgent::Providers::Anthropic, with: {
            key: "key"
          }
        end
      end

      it "responds with correctly set llm provider" do
        my_agent = agent_with_llm_provider.new

        expect(my_agent.llm_provider).to be_an_instance_of(ActAsAgent::Providers::Anthropic)
        expect(my_agent.llm_provider_options).to eq({ key: "key" })
      end
    end

    describe "when it was not provided" do
      let(:agent_with_llm_provider) do
        Class.new do
          include ActAsAgent::Base
        end
      end

      it "responds with correctly set llm provider" do
        my_agent = agent_with_llm_provider.new

        expect(my_agent.llm_provider).to eq(nil)
      end
    end
  end

  describe ".tools" do
    let(:class_with_tools) do
      Class.new do
        include ActAsAgent::Base

        tools [:text_tool]
      end
    end

    it "supports setting provider for agent" do
      my_agent = class_with_tools.new

      expect(my_agent.tools).to eq([:text_tool])
    end

    it "supports adding tools along the way" do
      my_agent = class_with_tools.new

      my_agent.tools << :new_super_tool

      expect(my_agent.tools).to eq(%i[text_tool new_super_tool])
    end
  end
end
