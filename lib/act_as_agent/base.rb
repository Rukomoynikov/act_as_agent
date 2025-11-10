# frozen_string_literal: true

require "act_as_api_client"
require "act_as_agent/providers/anthropic"

module ActAsAgent
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    def tools
      @tools ||= self.tools_from_class
    end

    def llm_provider
      @llm_provider ||= self.llm_provider_from_class
    end

    def llm_provider_options
      @llm_provider_options ||= self.llm_provider_options_from_class
    end

    def run(); end

    module ClassMethods
      def tools(list)
        define_method(:tools_from_class) { list || [] }
      end

      def llm_provider(klass, args)
        define_method(:llm_provider_from_class) { klass }
        define_method(:llm_provider_options_from_class) { args.fetch(:with) }
      end
    end
  end
end
