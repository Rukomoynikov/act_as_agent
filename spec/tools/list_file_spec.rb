# frozen_string_literal: true

require "act_as_agent/tools/list_files"
require "tmpdir"
require "tempfile"

RSpec.describe ActAsAgent::Tools::ListFiles do
  context "when root_folder is passed" do
    context "when param is relative" do
      let(:looked_path) { "./" }

      it "returns error" do
        tool = ActAsAgent::Tools::ListFiles.new(root_folder: looked_path)
        expected_error = ActAsAgent::Errors::ToolIncorrectArgsError
                         .new("Path is not absolute: #{looked_path}")

        expect(tool.call).to eq(expected_error)
      end
    end

    context "when param is absolute" do
      let(:tmp_dir) { Dir.mktmpdir }

      before do
        Tempfile.create("file1.txt", tmp_dir)

        nested_dir_path = File.join(tmp_dir, "nested_folder")
        Dir.mkdir(nested_dir_path)
        Tempfile.create("file_nested.txt", nested_dir_path)
      end

      let(:looked_path) { File.join(tmp_dir, "**/*.*") }

      it "returns list of files" do
        tool = ActAsAgent::Tools::ListFiles.new(root_folder: looked_path)

        expect(
          tool.call.length
        ).to eq(2)
      end

      describe "it changes the description of the tool" do
        it "adds root_folder path into description" do
          tool = ActAsAgent::Tools::ListFiles.new(root_folder: looked_path)

          expect(tool.description).to end_with("By default it will use #{looked_path}")
        end
      end

      describe "it changes input_schema" do
        it "adds root_folder path into description" do
          tool = ActAsAgent::Tools::ListFiles.new(root_folder: looked_path)
          input_schema_param_description = tool.input_schema.dig(:properties, :root_folder, :description)

          expect(input_schema_param_description).to end_with("By default it will use #{looked_path}")
        end
      end
    end
  end

  context "when param path is passed" do
    context "when path is relative" do
      let(:looked_path) { "./" }

      it "returns error" do
        expected_error = ActAsAgent::Errors::ToolIncorrectArgsError
                         .new("Path is not absolute: #{looked_path}")

        expect(
          subject.call({ "path" => looked_path })
        ).to eq(expected_error)
      end
    end

    context "when path is absolute" do
      let(:tmp_dir) { Dir.mktmpdir }

      before do
        Tempfile.create("file1.txt", tmp_dir)
      end

      before do
        nested_dir_path = File.join(tmp_dir, "nested_folder")
        Dir.mkdir(nested_dir_path)
        Tempfile.create("file_nested.txt", nested_dir_path)
      end

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
