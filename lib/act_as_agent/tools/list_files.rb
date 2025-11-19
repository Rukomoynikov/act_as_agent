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

        return list_files(path) unless path.nil? || path.chomp == ""
        return list_files(root_folder) unless root_folder.nil?

        ERROR.new("Incorrect params have been given to list files tool")
      end

      private

      def list_files(path)
        return ERROR.new("Path is not absolute: #{path}") unless Pathname.new(path).absolute?

        path = File.expand_path(path)

        Dir.glob(path)
      end
    end
  end
end
