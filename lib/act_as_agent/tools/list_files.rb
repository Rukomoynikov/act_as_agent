# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"

module ActAsAgent
  module Tools
    class ListFiles
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      def run(**args)
        path = args.fetch(:path, nil)

        return ERROR.new("Incorrect params have been given to list files tool") if path.nil? || path.chomp == ""

        Dir.glob(path)
      end
    end
  end
end
