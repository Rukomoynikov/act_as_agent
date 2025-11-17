# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"

module ActAsAgent
  module Tools
    class ListFiles
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      attr_reader :root_folder

      def initialize(root_folder: nil)
        @root_folder = root_folder
      end

      def name
        self.class.to_s.gsub("::", "__")
      end

      def description
        "List files in the directory and all subdirectories. Pass the path to lookup"
      end

      def input_schema
        {
          type: "object",
          properties: {
            root_folder: { type: "string",
                           description: "The root folder of the list folder. By default it will use current folder." }
          },
          required: []
        }
      end

      def call(args = {})
        path = args.fetch("path", nil)

        return Dir.glob(path) unless path.nil? || path.chomp == ""
        return Dir.glob(root_folder) unless root_folder.nil?

        ERROR.new("Incorrect params have been given to list files tool")
      end
    end
  end
end
