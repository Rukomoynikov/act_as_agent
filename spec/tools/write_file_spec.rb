# frozen_string_literal: true

require "act_as_agent/tools/write_file"
require "tmpdir"
require "tempfile"

RSpec.describe ActAsAgent::Tools::WriteFile do
  let(:before_file_content) { "11 + 11 = ?" }
  let(:after_file_content) { "11 + 11 = 22" }
  let(:temp_file_path) do
    file = Tempfile.create("file1.txt", Dir.mktmpdir)
    file.write(before_file_content)
    file.rewind

    file.path
  end

  describe "when glob parameter is passed" do
    it "returns list of files" do
      expect(
        subject.call({
                       "file_path" => temp_file_path,
                       "file_content" => after_file_content
                     })
      ).to eq(after_file_content)
    end
  end
end
