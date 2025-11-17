# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"

module ActAsAgent
  module Tools
    class ReadFile
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      attr_reader :file_path

      def initialize(file_path: nil)
        @file_path = file_path
      end

      def name
        self.class.to_s.gsub("::", "__")
      end

      def description
        "Read file by the given path"
      end

      def input_schema
        {
          type: "object",
          properties: {
            file_path: { type: "string",
                         description: "File path to read" }
          },
          required: []
        }
      end

      def call(args = {})
        path = args.fetch("file_path", nil)

        return File.read(path) unless path.nil? || path.chomp == ""
        return File.read(file_path) unless file_path.nil?

        ERROR.new("Incorrect params have been given to list files tool")
      end
    end
  end
end
