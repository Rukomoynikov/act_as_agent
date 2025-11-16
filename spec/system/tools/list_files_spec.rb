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

        expect(result).to eq({ "model" => "claude-sonnet-4-5-20250929",
                               "id" => "msg_01SCyqg4YQrCv3LY4JFQaZcs",
                               "type" => "message",
                               "role" => "assistant",
                               "content" => [
                                 { "type" => "text",
                                   "text" => "# File List\n\n## Root Directory\n- `diary.txt20251116-12369-yan3h6`\n\n## Subdirectory: nested_folder/\n- `file_nested.txt20251116-12369-dzwy00`\n\n---\n\n**Total Files:** 2" } # rubocop:disable Layout/LineLength
                               ],
                               "stop_reason" => "end_turn",
                               "stop_sequence" => nil,
                               "usage" => {
                                 "input_tokens" => 790,
                                 "cache_creation_input_tokens" => 0,
                                 "cache_read_input_tokens" => 0,
                                 "cache_creation" => {
                                   "ephemeral_5m_input_tokens" => 0,
                                   "ephemeral_1h_input_tokens" => 0
                                 },
                                 "output_tokens" => 67, "service_tier" => "standard"
                               } })
      end
    end
  end
end
