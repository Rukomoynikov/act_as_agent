# frozen_string_literal: true

require "act_as_agent/tools/write_file"
require "act_as_agent/errors/tool_incorrect_args_error"
require "tmpdir"
require "tempfile"
require "fileutils"

RSpec.describe ActAsAgent::Tools::WriteFile do
  let(:after_file_content) { "11 + 11 = 22" }
  let(:temp_file_path) do
    file = Tempfile.create("file1.txt", Dir.mktmpdir)
    file.rewind

    file.path
  end

  it "creates a folder (and file) if they don't exist"
  it "updates the content of the file"

  context "when parameter return_content" do
    context "is true" do
      let(:tool) { ActAsAgent::Tools::WriteFile.new(return_content: true, file_path: temp_file_path) }

      it "returns content of the file" do
        expect(
          tool.call({ "file_content" => after_file_content })
        ).to eq(after_file_content)
      end
    end

    context "is false" do
      let(:tool) { ActAsAgent::Tools::WriteFile.new(return_content: false, file_path: temp_file_path) }

      it "doesn't return content of the file" do
        expect(
          tool.call({ "file_content" => after_file_content })
        ).to eq(nil)
      end
    end
  end

  context "when file_path is provided for initializer" do
    let(:tool) { ActAsAgent::Tools::WriteFile.new(file_path: temp_file_path, return_content: true) }

    it "creates a folder (and file) if they don't exist" do
      expect(
        tool.call({ "file_content" => after_file_content })
      ).to eq(after_file_content)
    end
  end

  context "when file_path is provided for #call method" do
    let(:tool) { ActAsAgent::Tools::WriteFile.new(return_content: true) }

    it "creates a folder (and file) if they don't exist" do
      expect(
        tool.call({ "file_path" => temp_file_path,
                    "file_content" => after_file_content })
      ).to eq(after_file_content)
    end
  end

  context "when neither file_path and call triggered without file_path" do
    let(:tool) { ActAsAgent::Tools::WriteFile.new }

    it "returns error" do
      expect(
        tool.call
      ).to an_instance_of(
        ActAsAgent::Errors::ToolIncorrectArgsError
      )
    end
  end

  context "when base_folder parameter is provided" do
    let(:base_folder) { "./tmp/#{rand(1000)}/" }
    let(:tool) { ActAsAgent::Tools::WriteFile.new(base_folder: base_folder) }
    let(:file_name) { Time.now.strftime("%H_%M_%S_#{rand(1000)}.txt") }

    context "when file_path is provided for #call method" do
      after do
        File.delete(File.join(base_folder, "file.txt"))
        Dir.rmdir(base_folder)
      end

      it "creates a folder (and file) inside this folder" do
        expect do
          tool.call({
                      "file_path" => "file.txt"
                    })
        end.to(change { File.exist?(File.join(base_folder, "file.txt")) })
      end
    end

    context "when file_path is provided for initializer"
  end
end
