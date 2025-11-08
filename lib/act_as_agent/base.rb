# frozen_string_literal: true

module ActAsAgent
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    def run(); end

    module ClassMethods
      def tools(list)
        define_method(:tools) { list }
      end

      def llm_provider(klass, args)
        define_method(:llm_provider) { klass }
        define_method(:llm_provider_options) { args.fetch(:with) }
      end
    end
  end
end
