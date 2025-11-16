# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"

module ActAsAgent
  module Tools
    class ListFiles
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      def name
        self.to_s
      end

      def description
        "List files in the directory and all subdirectories. Pass the path to lookup"
      end

      def input_schema
        {
          type: "object",
          properties: {
            root_folder: { type: "string", description: "The root folder of the list folder" },
          },
          required: ["root_folder"]
        }
      end

      def run(**args)
        path = args.fetch(:path, nil)

        return ERROR.new("Incorrect params have been given to list files tool") if path.nil? || path.chomp == ""

        Dir.glob(path)
      end
    end
  end
end
