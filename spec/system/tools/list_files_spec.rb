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
      Tempfile.new("diary.txt", tmp_dir)
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
        result = agent.run(task: "Please get me list of files (make it in markdown format).")

        expect(result["content"][0]["text"]).to match("# File List\n\n- `/var/folders/38/gv19_k_12ng_m2fyg7k9ztqh0000gn/T/d20251117-9853-23f6r/diary.txt20251117-9853-vjom33`\n- `/var/folders/38/gv19_k_12ng_m2fyg7k9ztqh0000gn/T/d20251117-9853-23f6r/nested_folder/file_nested.txt20251117-9853-fjohm`\n\n## Directory Structure\n\n```\n/var/folders/38/gv19_k_12ng_m2fyg7k9ztqh0000gn/T/d20251117-9853-23f6r/\n├── diary.txt20251117-9853-vjom33\n└── nested_folder/\n    └── file_nested.txt20251117-9853-fjohm\n```") # rubocop:disable Layout/LineLength
      end
    end
  end
end
