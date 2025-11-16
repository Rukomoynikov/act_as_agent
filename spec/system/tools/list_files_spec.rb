# frozen_string_literal: true

require "act_as_agent/tools/list_files"
require "act_as_agent/providers/anthropic"
require "tmpdir"
require "tempfile"

class MyDairyAgent
  include ActAsAgent::Base

  llm_provider ActAsAgent::Providers::Anthropic, with: {
    key: YAML.load_file("spec/credentials.yml").dig("anthropic", "messages", "x-api-key")
  }
end

RSpec.describe ActAsAgent::Tools::ListFiles, :vcr do
  context "when param path is passed" do
    let(:tmp_dir) { Dir.mktmpdir }

    before do
      Tempfile.create("diary.txt", tmp_dir) do |file|
        file.write("Here is my dairy")
      end
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
        agent.tools << ActAsAgent::Tools::ListFiles.new(root_folder: File.join(tmp_dir, "**/*.*"))
        agent.run(task: "Please get me list of files (make it in markdown format).")
      end
    end
  end
end
