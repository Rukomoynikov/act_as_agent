# frozen_string_literal: true

require "act_as_agent/providers/anthropic"

module ActAsAgent
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    def run(args)
      llm_provider.request(content: args[:task])
    end

    def tools
      @tools ||= self.class.instance_variable_get("@tools") || []
    end

    def llm_provider
      klass = self.class.instance_variable_get("@llm_provider")
      @llm_provider ||= if klass == ActAsAgent::Providers::Anthropic
                          key = llm_provider_options.fetch(:key, nil)
                          ActAsAgent::Providers::Anthropic.new(tools: tools, key: key)
                        end
    end

    def llm_provider_options
      @llm_provider_options ||= self.class.instance_variable_get("@llm_provider_options")
    end

    module ClassMethods
      def tools(tls)
        instance_variable_set("@tools", tls)
      end

      def llm_provider(klass, args)
        instance_variable_set("@llm_provider", klass)
        instance_variable_set("@llm_provider_options", args.fetch(:with, {}))
      end
    end
  end
end
