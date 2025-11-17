# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"

module ActAsAgent
  module Tools
    class WriteFile
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      attr_reader :file_path

      def initialize(file_path: nil)
        @file_path = file_path
      end

      def name
        self.class.to_s.gsub("::", "__")
      end

      def description
        "It writes content into file. If file doesn't exist it will create a new one. It accepts two parameters file_path and file_content. But file_path is optional as by default it will write into the file user want it to be saved"
      end

      def input_schema
        {
          type: "object",
          properties: {
            file_path: { type: "string",
                         description: "File path to write" },
            file_content: { type: "string", description: "File content" }
          },
          required: ["file_content"]
        }
      end

      def call(args = {})
        path = args.fetch("file_path", nil)
        content = args.fetch("file_content", nil)

        return write(path, content) unless path.nil? || path.chomp == ""
        return write(path, content) unless file_path.nil?

        ERROR.new("Incorrect params have been given to list files tool")
      end

      private

      def write(path, content)
        File.write(path, content)

        File.read(path)
      end
    end
  end
end
