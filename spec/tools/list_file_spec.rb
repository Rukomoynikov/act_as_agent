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

  describe "when absolute path is provided" do
    let(:tmp_dir) { Dir.mktmpdir }

    before do
      File.write(File.join(tmp_dir, "file1.txt"), "content1")
      File.write(File.join(tmp_dir, "file2.txt"), "content2")
    end

    after do
      FileUtils.rm_rf(tmp_dir)
    end

    it "lists files using absolute path" do
      absolute_path = File.join(tmp_dir, "*.txt")
      expect(absolute_path).to start_with("/")
      result = subject.call({ "path" => absolute_path })
      expect(result.length).to eq(2)
      expect(result.all? { |f| f.start_with?("/") }).to be true
    end
  end

  describe "when relative path is provided" do
    it "lists files using relative path" do
      relative_path = "spec/tools/*.rb"
      result = subject.call({ "path" => relative_path })
      expect(result.length).to be > 0
      expect(result).to include(match(/read_file_spec\.rb$/))
    end
  end
end
