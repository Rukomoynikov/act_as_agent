# frozen_string_literal: true

require "act_as_agent/providers/anthropic"

RSpec.describe ActAsAgent::Providers::Anthropic do
  let(:client) { ActAsAgent::Providers::Anthropic.new(key: "key") }

  describe "#send" do
    it "sends request" do
      p client.request(message: "sgsdg")
    end
  end
end
