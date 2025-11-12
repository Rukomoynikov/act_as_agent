# frozen_string_literal: true

module ActAsAgent
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    def tools
      @tools ||= defined?(tools_from_class) ? tools_from_class : []
    end

    def llm_provider
      @llm_provider ||= defined?(llm_provider_from_class) ? llm_provider_from_class : nil
    end

    def llm_provider_options
      @llm_provider_options ||= defined?(llm_provider_options_from_class) ? llm_provider_options_from_class : nil
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
