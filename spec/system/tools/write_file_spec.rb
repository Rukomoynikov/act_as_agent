# frozen_string_literal: true

require "act_as_agent/tools/list_files"
require "act_as_agent/tools/read_file"
require "act_as_agent/tools/write_file"
require "act_as_agent/providers/anthropic"
require "tmpdir"
require "tempfile"

class MyDairyAgent
  include ActAsAgent::Base

  llm_provider ActAsAgent::Providers::Anthropic, with: {
    key: YAML.load_file("spec/credentials.yml").dig("anthropic", "messages", "x-api-key")
  }
end

RSpec.describe ActAsAgent::Tools::WriteFile, :vcr do
  context "when param path is passed" do
    describe "when glob parameter is passed" do
      let(:lookup_path) { File.join(__dir__, "../../files_for_agents/**/*.txt") }
      let(:react_app_folder) { "./tmp/#{rand(1000)}/" }

      after do
        FileUtils.rm_r(react_app_folder) if Dir.exist?(react_app_folder)
      end

      it "updates the file with new content" do
        agent = MyDairyAgent.new
        agent.tools << ActAsAgent::Tools::ListFiles.new(root_folder: lookup_path)
        agent.tools << ActAsAgent::Tools::ReadFile.new
        agent.tools << ActAsAgent::Tools::WriteFile.new(return_content: false, base_folder: react_app_folder)

        result = agent.run(task: "Please create a React app with Todo functionality")

        expect(
          result["content"][0]["text"]
        ).to match(
          "Perfect! I've created a fully functional React Todo app for you!"
        )
      end
    end
  end
end
