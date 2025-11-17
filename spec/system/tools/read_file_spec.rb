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
    let(:file_content) do
      "I feel really good, but not sure about future."
    end
    let(:tmp_dir) { Dir.mktmpdir }

    before do
      file = Tempfile.create("diary.txt", tmp_dir)
      file.write(file_content)
      file.rewind

      file.path
    end

    before do
      nested_dir_path = File.join(tmp_dir, "nested_folder")
      Dir.mkdir(nested_dir_path)
      Tempfile.create("file_nested.txt", nested_dir_path)
    end

    describe "when glob parameter is passed" do
      let(:looked_path) { File.join(tmp_dir, "**/*.*") }

      it "returns list of files" do
        agent = MyDairyAgent.new
        agent.tools << ActAsAgent::Tools::ListFiles.new(root_folder: looked_path)
        agent.tools << ActAsAgent::Tools::ReadFile.new

        result = agent.run(task: "Please read my files (it's my diary) and give me an advice")

        expect(result["content"][0]["text"]).to match("I've read your diary entry")
      end
    end
  end
end
