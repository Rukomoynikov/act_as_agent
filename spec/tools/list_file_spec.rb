# frozen_string_literal: true

require "act_as_agent/tools/list_files"
require "tmpdir"
require "tempfile"

RSpec.describe ActAsAgent::Tools::ListFiles do
  context "when param path is passed" do
    let(:tmp_dir) { Dir.mktmpdir }

    before do
      Tempfile.create("file1.txt", tmp_dir)
    end

    before do
      nested_dir_path = File.join(tmp_dir, "nested_folder")
      Dir.mkdir(nested_dir_path)
      Tempfile.create("file_nested.txt", nested_dir_path)
    end

    describe "when glob parameter is passed" do
      let(:looked_path) { File.join(tmp_dir, "**/*.*") }

      it "returns list of files" do
        expect(
          subject.call({ "path" => looked_path }).length
        ).to eq(2)
      end
    end
  end

  context "when param path is not passed" do
    it "returns error" do
      expected_error = ActAsAgent::Errors::ToolIncorrectArgsError
                       .new("Incorrect params have been given to list files tool")

      expect(subject.call).to eq(expected_error)
    end
  end
end
