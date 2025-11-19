# frozen_string_literal: true

require "act_as_agent/tools/read_file"
require "tmpdir"
require "tempfile"

RSpec.describe ActAsAgent::Tools::ReadFile do
  let(:file_content) { "11 + 11 * 2 = ?" }
  let(:tmp_dir) { Dir.mktmpdir }
  let(:temp_file_path) do
    file = Tempfile.create("file1.txt", tmp_dir)
    file.write(file_content)
    file.rewind

    file.path
  end

  describe "when glob parameter is passed" do
    it "returns list of files" do
      expect(
        subject.call({ "file_path" => temp_file_path })
      ).to eq(file_content)
    end
  end

  describe "when absolute path is provided" do
    it "reads the file using absolute path" do
      expect(temp_file_path).to start_with("/")
      expect(
        subject.call({ "file_path" => temp_file_path })
      ).to eq(file_content)
    end
  end

  describe "when relative path is provided" do
    let(:relative_file_path) { "spec/tools/read_file_spec.rb" }

    it "reads the file using relative path" do
      content = subject.call({ "file_path" => relative_file_path })
      expect(content).to include("RSpec.describe ActAsAgent::Tools::ReadFile")
    end
  end
end
