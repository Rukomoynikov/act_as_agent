# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"
require "fileutils"

module ActAsAgent
  module Tools
    class WriteFile
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      attr_reader :file_path, :base_folder, :return_content

      def initialize(file_path: nil, base_folder: nil, return_content: false)
        @file_path = file_path
        @base_folder = base_folder
        @return_content = return_content
      end

      def name
        self.class.to_s.gsub("::", "__")
      end

      def description
        "
        It writes content into file. If file doesn't exist it will create a new one.
        It accepts two parameters file_path and file_content.
        But file_path is optional as by default it will write into the file
        user want it to be saved.
        Supports both absolute paths (e.g., /tmp/file.txt) and relative paths (e.g., ./file.txt).
        "
      end

      def input_schema # rubocop:disable Metrics/MethodLength
        {
          type: "object",
          properties: {
            file_path: { type: "string",
                         description: "File path to write. " \
                                      "Can be an absolute path (e.g., /tmp/file.txt) " \
                                      "or relative path (e.g., ./file.txt)" },
            file_content: { type: "string", description: "File content" }
          },
          required: ["file_content"]
        }
      end

      def call(args = {})
        path = args.fetch("file_path", "")
        content = args.fetch("file_content", nil)

        return write(base_folder, path, content) unless path.chomp == ""
        return write(base_folder, file_path, content) unless file_path.nil?
        return write(nil, base_folder, content) unless base_folder.nil?

        ERROR.new("Incorrect params have been given to write file tool")
      end

      private

      def write(base_folder, path, content)
        path = File.join(base_folder, path) unless base_folder.nil? || base_folder.chomp == ""
        path = File.expand_path(path)

        dir_level = path.end_with?("/") ? 0 : 1
        FileUtils.mkdir_p(File.dirname(path, dir_level))

        return if File.directory?(path)

        File.write(path, content)

        File.read(path) if return_content
      end
    end
  end
end
