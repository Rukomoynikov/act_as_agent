# frozen_string_literal: true

require "act_as_agent/errors/tool_incorrect_args_error"
require "rake"

module ActAsAgent
  module Tools
    class ListFiles
      ERROR = ActAsAgent::Errors::ToolIncorrectArgsError

      attr_reader :root_folder, :excluded_paths

      def initialize(root_folder: nil, excluded_paths: [])
        @root_folder = root_folder
        @excluded_paths = excluded_paths
      end

      def name
        self.class.to_s.gsub("::", "__")
      end

      def description
        <<~TEXT.chomp
          List files in the directory and all subdirectories.
          Pass the path to lookup.
          Supports only absolute paths (e.g., /tmp/**/*.txt)
          #{"By default it will use #{root_folder}" unless root_folder.to_s.empty?}
        TEXT
      end

      def input_schema # rubocop:disable Metrics/MethodLength
        { type: "object",
          properties: {
            root_folder: {
              type: "string",
              description: <<~TEXT.chomp
                The root folder of the list folder.
                Can be only an absolute path (e.g., /tmp/**/*.txt)"
                #{"By default it will use #{root_folder}" unless root_folder.to_s.empty?}
              TEXT
            }
          },
          required: [] }
      end

      def call(args = {})
        path = args.fetch("root_folder", nil)

        return list_files(path) unless path.nil? || path.chomp == ""
        return list_files(root_folder) unless root_folder.nil?

        ERROR.new("Incorrect params have been given to list files tool")
      end

      private

      def list_files(path)
        return ERROR.new("Path is not absolute: #{path}") unless Pathname.new(path).absolute?

        path = File.expand_path(path)

        # p FileList[path]
        # p Dir.glob(path)

        FileList[path].exclude do |f|
          excluded_paths.any? do |excluded_path|
            # excluded_path = File.join(root_folder, excluded_path) unless File.absolute_path?(excluded_path) && root_folder.to_s != ""
            # p excluded_path

            File.fnmatch(excluded_path, f)
            p File.fnmatch(excluded_path, f)
            p excluded_path, f
            # f.start_with?(excluded_path)
          end
        end
      end
    end
  end
end
