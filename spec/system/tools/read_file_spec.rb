# frozen_string_literal: true

require "act_as_agent/tools/list_files"
require "act_as_agent/tools/read_file"
require "act_as_agent/providers/anthropic"
require "tmpdir"
require "tempfile"

class MyDairyAgent
  include ActAsAgent::Base

  llm_provider ActAsAgent::Providers::Anthropic, with: {
    key: YAML.load_file("spec/credentials.yml").dig("anthropic", "messages", "x-api-key")
  }
end

RSpec.describe ActAsAgent::Tools::ReadFile, :vcr do
  context "when param path is passed" do
    describe "when glob parameter is passed" do
      let(:lookup_path) { File.join(__dir__, "../../files_for_agents/**/*.txt") }
      let(:file_diary_path) { File.join(__dir__, "../../files_for_agents/diary.txt") }

      before do
        allow_any_instance_of(
          ActAsAgent::Tools::ReadFile
        ).to receive(:call)
          .and_return("I feel really good, but not sure about future.")
      end

      it "reads the files in the folder and creates a summary" do
        agent = MyDairyAgent.new
        agent.tools << ActAsAgent::Tools::ListFiles.new(root_folder: lookup_path)
        agent.tools << ActAsAgent::Tools::ReadFile.new

        result = agent.run(task: "Please read my files (it's my diary) and give me an advice")

        expect(result["content"][0]["text"]).to match("Thank you for sharing your diary with me")
      end
    end
  end
end
